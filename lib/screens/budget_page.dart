import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});
  @override
  Widget build(BuildContext c) {
    final sisa = store.budget - store.spent;
    final pct = store.budget == 0 ? 0.0 : (store.spent / store.budget).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(title: const Text('Anggaran Bulanan', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Total Anggaran', style: TextStyle(color: Colors.black87)),
          Text(rp(store.budget), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black87)),
          const SizedBox(height: 12),
          Row(children: [
            SizedBox(width: 64, height: 64, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: pct, strokeWidth: 7, color: green, backgroundColor: Colors.white), Text('${(pct * 100).round()}%', style: const TextStyle(color: Colors.black87))])),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Sisa Anggaran', style: TextStyle(color: Colors.black87)), Text(rp(sisa), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87))]),
          ]),
          const SizedBox(height: 12),
          OutlinedButton(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)), onPressed: () async {
            final ctl = TextEditingController(text: store.budget.toString());
            final ok = await showDialog<bool>(context: c, builder: (_) => AlertDialog(title: const Text('Atur Anggaran'), content: TextField(controller: ctl, keyboardType: TextInputType.number),
                actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')), TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Simpan'))]));
            if (ok == true) {
              await Prefs.setBudget(int.tryParse(ctl.text) ?? store.budget); // Shared Preferences
              await store.load();
            }
          }, child: const Text('Atur Anggaran')),
        ])),
        const SizedBox(height: 16),
        const Text('Anggaran ini disimpan di Shared Preferences dan akan tetap tersedia meskipun aplikasi ditutup.', style: TextStyle(fontSize: 12)),
      ]),
    );
  }
}

