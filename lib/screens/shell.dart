import 'package:flutter/material.dart';
import '../core.dart';
import 'home_page.dart';
import 'transactions_page.dart';
import 'chart_page.dart';
import 'profile_page.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  @override
  Widget build(BuildContext c) {
    const pages = [HomePage(), TxPage(), ChartPage(), ProfilePage()];
    return Scaffold(
      body: SafeArea(child: ListenableBuilder(listenable: store, builder: (_, __) => store.loading ? const Center(child: CircularProgressIndicator()) : pages[i])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: i, onDestinationSelected: (v) => setState(() => i = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Transaksi'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Grafik'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

