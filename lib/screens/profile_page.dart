import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext c) => ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height: 16),
        const Center(child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40))),
        const SizedBox(height: 8),
        const Center(child: Text('Naswa Vifda Zalianti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
        Center(child: Text(Prefs.email.isEmpty ? 'email@contoh.com' : Prefs.email)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Total Pemasukan', style: TextStyle(fontSize: 11, color: Colors.black54)), Text(rp(store.income), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))]))),
          const SizedBox(width: 12),
          Expanded(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: pink, borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Total Pengeluaran', style: TextStyle(fontSize: 11, color: Colors.black54)), Text(rp(store.spent), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))]))),
        ]),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFFFF3DD), borderRadius: BorderRadius.circular(14)),
            child: const Text('"Keuangan yang baik adalah langkah kecil menuju impian besar."', style: TextStyle(color: Colors.black87))),
        const SizedBox(height: 16),
        ListTile(leading: const Icon(Icons.settings), title: const Text('Pengaturan'), onTap: () => go(c, const SettingsPage())),
      ]);
}

