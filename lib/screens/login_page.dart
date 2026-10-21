import 'package:flutter/material.dart';
import '../data.dart';
import '../core.dart';
import 'shell.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController(), pass = TextEditingController();
  bool hide = true, remember = true, busy = false;

  /// Async: simulasi proses autentikasi (butuh waktu) dengan Future.delayed.
  Future<void> masuk() async {
    if (!email.text.contains('@') || pass.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email/password tidak valid')));
      return;
    }
    setState(() => busy = true);
    await Future.delayed(const Duration(seconds: 1));
    await Prefs.setEmail(email.text);
    await Prefs.setLoggedIn(remember); // Shared Preferences: "Ingat saya"
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()));
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(24), children: [
            const SizedBox(height: 24),
            const Icon(Icons.eco, color: green, size: 32),
            const Text('HematKu', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: green)),
            const SizedBox(height: 12),
            const Text('Yuk, masuk dulu\nuntuk melanjutkan', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 28),
            const Text('Email'), const SizedBox(height: 6),
            TextField(controller: email, keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Masukkan email kamu', prefixIcon: Icon(Icons.mail_outline))),
            const SizedBox(height: 16),
            const Text('Password'), const SizedBox(height: 6),
            TextField(controller: pass, obscureText: hide,
                decoration: InputDecoration(hintText: 'Masukkan password', prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(icon: Icon(hide ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => hide = !hide)))),
            Row(children: [
              Checkbox(value: remember, activeColor: green, onChanged: (v) => setState(() => remember = v!)),
              const Text('Ingat saya'), const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Lupa password?')),
            ]),
            FilledButton(onPressed: busy ? null : masuk,
                child: busy ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Masuk')),
            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: Text('atau'))),
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () => ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('Login Google belum tersedia'))),
                icon: const Icon(Icons.g_mobiledata, size: 30), label: const Text('Lanjut dengan Google')),
            const SizedBox(height: 16),
            const Center(child: Text('Belum punya akun? Daftar')),
          ]),
        ),
      );
}

