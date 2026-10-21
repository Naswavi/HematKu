import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';
import 'transaction_form.dart';

class TxPage extends StatefulWidget {
  const TxPage({super.key});
  @override
  State<TxPage> createState() => _TxPageState();
}

class _TxPageState extends State<TxPage> {
  int f = 0;
  String q = '';
  @override
  Widget build(BuildContext c) {
    final items = store.list.where((t) => (f == 0 || (f == 1) != t.expense) && (q.isEmpty || t.cat.toLowerCase().contains(q) || t.note.toLowerCase().contains(q))).toList();
    final days = <String, List<Tx>>{};
    for (final t in items) { days.putIfAbsent(tgl(t.date), () => []).add(t); }
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(backgroundColor: green, foregroundColor: Colors.white, shape: const CircleBorder(), onPressed: () => go(c, const TxForm()), child: const Icon(Icons.add)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Transaksi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(children: [for (final e in ['Semua', 'Pemasukan', 'Pengeluaran'].asMap().entries) Padding(padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(label: Text(e.value), selected: f == e.key, selectedColor: green, labelStyle: TextStyle(color: f == e.key ? Colors.white : null), onSelected: (_) => setState(() => f = e.key)))]),
        const SizedBox(height: 8),
        TextField(onChanged: (v) => setState(() => q = v.toLowerCase()), decoration: const InputDecoration(hintText: 'Cari transaksi...', prefixIcon: Icon(Icons.search))),
        for (final d in days.entries) ...[
          Padding(padding: const EdgeInsets.only(top: 14, bottom: 4), child: Text(d.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
          ...d.value.map((t) => txTile(c, t)),
        ],
        if (items.isEmpty) const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('Tidak ada transaksi'))),
      ]),
    );
  }
}

