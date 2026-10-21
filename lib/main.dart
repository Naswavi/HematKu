import 'package:flutter/material.dart';
import 'core.dart';
import 'data.dart';
import 'screens/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.load();
  await store.load();
  runApp(const HematKu());
}

class HematKu extends StatelessWidget {
  const HematKu({super.key});
  ThemeData theme(bool dark) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: dark ? Brightness.dark : Brightness.light),
        scaffoldBackgroundColor: dark ? const Color(0xFF121614) : cream,
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(backgroundColor: green, minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
        inputDecorationTheme: InputDecorationTheme(
            filled: true, fillColor: dark ? Colors.white10 : Colors.black.withOpacity(.04),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
      );
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: Prefs.dark,
        builder: (_, dark, __) => MaterialApp(
            title: 'HematKu', debugShowCheckedModeBanner: false,
            theme: theme(false), darkTheme: theme(true),
            themeMode: dark ? ThemeMode.dark : ThemeMode.light, home: const Splash()),
      );
}

