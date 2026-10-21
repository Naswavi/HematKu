import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';
import 'login_page.dart';
import 'shell.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Spacer(),
              const Icon(Icons.eco, color: green, size: 48),
              const Text('HematKu', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: green)),
              const SizedBox(height: 8),
              const Text('Kelola keuanganmu,\nraih masa depan yang lebih baik', textAlign: TextAlign.center),
              const Spacer(),
              const Icon(Icons.account_balance_wallet, size: 140, color: Color(0xFF7DBF9E)),
              const Spacer(),
              FilledButton(
                  onPressed: () => Navigator.pushReplacement(c,
                      MaterialPageRoute(builder: (_) => Prefs.loggedIn ? const Shell() : const Login())),
                  child: const Text('Mulai')),
              TextButton(onPressed: () => Navigator.pushReplacement(c, MaterialPageRoute(builder: (_) => const Login())),
                  child: const Text('Sudah punya akun? Masuk')),
            ]),
          ),
        ),
      );
}

