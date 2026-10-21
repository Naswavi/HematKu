import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';
import 'budget_page.dart';
import 'report_page.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent),
        body: ListView(children: [
          ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: const Text('Naswa Vifda Zalianti'), subtitle: Text(Prefs.email)),
          ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Anggaran Bulanan'), onTap: () => go(c, const BudgetPage())),
          ValueListenableBuilder<bool>(valueListenable: Prefs.dark, builder: (_, d, __) => SwitchListTile(secondary: const Icon(Icons.palette_outlined), title: const Text('Tema Gelap'), value: d, activeColor: green, onChanged: Prefs.setDark)),
          ListTile(leading: const Icon(Icons.description_outlined), title: const Text('Laporan Transaksi'), onTap: () => go(c, const ReportPage())),
          const ListTile(leading: Icon(Icons.info_outline), title: Text('Tentang Aplikasi'), subtitle: Text('HematKu v1.0.0 - UTS Pemrograman Multiplatform')),
          ListTile(leading: const Icon(Icons.logout), title: const Text('Keluar'), onTap: () async {
            await Prefs.setLoggedIn(false);
            if (c.mounted) Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_) => const Login()), (_) => false);
          }),
        ]),
      );
}

