import 'package:flutter/material.dart';
import '../core.dart';
import 'transaction_form.dart';
import 'chart_page.dart';
import 'report_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool show = true;
  @override
  Widget build(BuildContext c) {
    final today = store.list.where((t) => sameDay(t.date, DateTime.now()));
    final inc = today.where((t) => !t.expense).fold(0, (a, t) => a + t.amount);
    final exp = today.where((t) => t.expense).fold(0, (a, t) => a + t.amount);
    final pct = store.budget == 0 ? 0.0 : (store.spent / store.budget).clamp(0.0, 1.0);
    Widget act(IconData i, String l, Color col, Widget w) => InkWell(
        onTap: () => go(c, w),
        child: Column(children: [CircleAvatar(radius: 26, backgroundColor: col.withOpacity(.15), child: Icon(i, color: col)), const SizedBox(height: 6), Text(l, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))]));
    Widget box(String l, int v, Color bg) => Expanded(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(fontSize: 12, color: Colors.black54)), Text(rp(v), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87))])));
    return ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Halo, Maswa! 👋', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)), Text('Semangat mengatur keuangan hari ini!')])),
        const Icon(Icons.notifications_none), const SizedBox(width: 12), const CircleAvatar(child: Icon(Icons.person)),
      ]),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Text('Total Saldo', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)), const Spacer(),
              InkWell(onTap: () => setState(() => show = !show), child: Icon(show ? Icons.visibility : Icons.visibility_off, color: Colors.black87))]),
            Text(show ? rp(store.income - store.spent) : 'Rp ••••••', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black87)),
            const SizedBox(height: 12),
            Row(children: [Text('Anggaran Bulanan\n${rp(store.budget)}', style: const TextStyle(fontSize: 12, color: Colors.black87)), const Spacer(), Text('${(pct * 100).round()}%', style: const TextStyle(color: Colors.black87))]),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: pct, color: green, backgroundColor: Colors.white, minHeight: 6, borderRadius: BorderRadius.circular(6)),
          ])),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        act(Icons.add, 'Tambah\nTransaksi', green, const TxForm()),
        act(Icons.show_chart, 'Grafik', Colors.orange, const Scaffold(body: SafeArea(child: ChartPage()))),
        act(Icons.description, 'Laporan', Colors.indigo, const ReportPage()),
        act(Icons.settings, 'Pengaturan', Colors.grey, const SettingsPage()),
      ]),
      const SizedBox(height: 20),
      const Text('Ringkasan Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 10),
      Row(children: [box('Pemasukan', inc, mint), const SizedBox(width: 12), box('Pengeluaran', exp, pink)]),
      const SizedBox(height: 20),
      const Text('Transaksi Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ...store.list.take(3).map((t) => txTile(c, t)),
      if (store.list.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Belum ada transaksi'))),
    ]);
  }
}

