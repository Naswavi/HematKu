import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool busy = false;
  String? path;
  String fmt = 'pdf';
  Future<void> export() async {
    setState(() => busy = true);
    final f = fmt == 'pdf' ? await Repo.exportPdf(store.list) : await Repo.exportJson(store.list); // async: tulis berkas
    setState(() { busy = false; path = f.path; });
  }
  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Laporan Transaksi', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          InputDecorator(decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today_outlined)), child: Text('1 ${bln[DateTime.now().month - 1]} ${DateTime.now().year} - ${tgl(DateTime.now())}')),
          const SizedBox(height: 16),
          const Text('Format Export', style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(value: 'pdf', groupValue: fmt, activeColor: green, secondary: const Icon(Icons.picture_as_pdf, color: Colors.red), title: const Text('PDF'), subtitle: const Text('File PDF'), onChanged: (v) => setState(() => fmt = v!)),
          RadioListTile<String>(value: 'json', groupValue: fmt, activeColor: green, secondary: const Icon(Icons.data_object, color: Colors.blue), title: const Text('JSON'), subtitle: const Text('File JSON'), onChanged: (v) => setState(() => fmt = v!)),
          const SizedBox(height: 8),
          FilledButton(onPressed: busy ? null : export, child: busy ? const CircularProgressIndicator(color: Colors.white) : const Text('Export')),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF3DD), borderRadius: BorderRadius.circular(12)),
              child: Text(path == null ? 'File akan disimpan di penyimpanan internal perangkat kamu.' : 'Berhasil disimpan di:\n$path', style: const TextStyle(color: Colors.black87))),
        ]),
      );
}
