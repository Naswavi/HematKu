import 'dart:math';
import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int mode = 1;
  DateTime ref = DateTime.now();
  bool inRange(DateTime d) {
    if (mode == 2) return d.year == ref.year;
    if (mode == 1) return d.year == ref.year && d.month == ref.month;
    final s = DateTime(ref.year, ref.month, ref.day).subtract(Duration(days: ref.weekday - 1));
    return !d.isBefore(s) && d.isBefore(s.add(const Duration(days: 7)));
  }
  @override
  Widget build(BuildContext c) {
    final data = <String, int>{};
    for (final t in store.list.where((t) => t.expense && inRange(t.date))) { data[t.cat] = (data[t.cat] ?? 0) + t.amount; }
    final total = data.values.fold(0, (a, b) => a + b);
    final es = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Grafik', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      SegmentedButton<int>(segments: const [ButtonSegment(value: 0, label: Text('Minggu')), ButtonSegment(value: 1, label: Text('Bulan')), ButtonSegment(value: 2, label: Text('Tahun'))],
          selected: {mode}, onSelectionChanged: (s) => setState(() => mode = s.first)),
      const SizedBox(height: 12),
      Center(child: Text(mode == 2 ? '${ref.year}' : '${bln[ref.month - 1]} ${ref.year}')),
      const SizedBox(height: 16),
      SizedBox(height: 220, child: total == 0 ? const Center(child: Text('Belum ada pengeluaran')) : CustomPaint(painter: Donut(es), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Total Pengeluaran', style: TextStyle(fontSize: 11)), Text(rp(total), style: const TextStyle(fontWeight: FontWeight.bold))])))),
      const SizedBox(height: 16),
      for (final e in es) ListTile(dense: true, leading: CircleAvatar(radius: 6, backgroundColor: catOf(e.key).color), title: Text(e.key),
          trailing: Text('${(e.value * 100 / total).round()}%    ${rp(e.value)}')),
    ]);
  }
}

class Donut extends CustomPainter {
  final List<MapEntry<String, int>> es;
  Donut(this.es);
  @override
  void paint(Canvas c, Size s) {
    final total = es.fold(0, (a, e) => a + e.value);
    final r = min(s.width, s.height) / 2 - 12;
    final rect = Rect.fromCircle(center: s.center(Offset.zero), radius: r);
    double a = -pi / 2;
    for (final e in es) {
      final sw = 2 * pi * e.value / total;
      c.drawArc(rect, a, sw, false, Paint()..style = PaintingStyle.stroke..strokeWidth = 28..color = catOf(e.key).color);
      a += sw;
    }
  }
  @override
  bool shouldRepaint(_) => true;
}

