import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';

class TxForm extends StatefulWidget {
  final Tx? edit;
  const TxForm({super.key, this.edit});
  @override
  State<TxForm> createState() => _TxFormState();
}

class _TxFormState extends State<TxForm> {
  late bool expense = widget.edit?.expense ?? true;
  late final nominal = TextEditingController(text: widget.edit?.amount.toString() ?? '');
  late final note = TextEditingController(text: widget.edit?.note ?? '');
  late String? cat = widget.edit?.cat;
  late DateTime date = widget.edit?.date ?? DateTime.now();
  bool busy = false;

  Future<void> simpan() async {
    final n = int.tryParse(nominal.text.replaceAll('.', ''));
    if (n == null || n <= 0 || cat == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi nominal dan kategori')));
      return;
    }
    setState(() => busy = true);
    await store.save(Tx(id: widget.edit?.id, expense: expense, amount: n, cat: cat!, date: date, note: note.text)); // async -> SQLite
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: Text(widget.edit == null ? 'Tambah Transaksi' : 'Edit Transaksi', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          SegmentedButton<bool>(
              style: SegmentedButton.styleFrom(selectedBackgroundColor: pink, selectedForegroundColor: Colors.red.shade700),
              segments: const [ButtonSegment(value: true, label: Text('Pengeluaran')), ButtonSegment(value: false, label: Text('Pemasukan'))],
              selected: {expense}, onSelectionChanged: (s) => setState(() => expense = s.first)),
          const SizedBox(height: 16),
          const Text('Nominal'), const SizedBox(height: 6),
          TextField(controller: nominal, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Rp 0', prefixIcon: Icon(Icons.payments_outlined))),
          const SizedBox(height: 14),
          const Text('Kategori'), const SizedBox(height: 6),
          InkWell(
            onTap: () async { final r = await Navigator.push<String>(c, MaterialPageRoute(builder: (_) => const CategoryPage())); if (r != null) setState(() => cat = r); },
            child: InputDecorator(decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined), suffixIcon: Icon(Icons.keyboard_arrow_down)), child: Text(cat ?? 'Pilih kategori')),
          ),
          const SizedBox(height: 14),
          const Text('Tanggal'), const SizedBox(height: 6),
          InkWell(
            onTap: () async { final d = await showDatePicker(context: c, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100)); if (d != null) setState(() => date = d); },
            child: InputDecorator(decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today_outlined), suffixIcon: Icon(Icons.event)), child: Text(tgl(date))),
          ),
          const SizedBox(height: 14),
          const Text('Catatan (opsional)'), const SizedBox(height: 6),
          TextField(controller: note, maxLines: 3, decoration: const InputDecoration(hintText: 'Tulis catatan...')),
          const SizedBox(height: 20),
          FilledButton(onPressed: busy ? null : simpan, child: const Text('Simpan')),
          if (widget.edit != null) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red, minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () async { await store.remove(widget.edit!.id!); if (mounted) Navigator.pop(context); },
                icon: const Icon(Icons.delete_outline), label: const Text('Hapus Transaksi')),
          ],
        ]),
      );
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Pilih Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent),
        body: GridView.count(crossAxisCount: 3, padding: const EdgeInsets.all(16), mainAxisSpacing: 12, crossAxisSpacing: 12, children: [
          for (final k in cats)
            InkWell(onTap: () => Navigator.pop(c, k.name), borderRadius: BorderRadius.circular(16),
                child: Container(decoration: BoxDecoration(color: k.color.withOpacity(.15), borderRadius: BorderRadius.circular(16)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(k.icon, color: k.color, size: 30), const SizedBox(height: 8), Text(k.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))]))),
        ]),
      );
}

