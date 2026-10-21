import 'package:flutter/material.dart';
import 'data.dart';
import 'screens/transaction_form.dart';

const green = Color(0xFF2F6B4F);
const mint = Color(0xFFD9EFE3);
const pink = Color(0xFFFBE3E3);
const cream = Color(0xFFFAF6EF);

String rp(int v) => 'Rp ${v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';
const bln = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
String tgl(DateTime d) => '${d.day} ${bln[d.month - 1]} ${d.year}';
bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// State aplikasi: data dimuat secara asinkron dari SQLite.
class Store extends ChangeNotifier {
  List<Tx> list = [];
  bool loading = true;
  int budget = Prefs.budget;
  Future<void> load() async {
    loading = true;
    notifyListeners();
    list = await Repo.all(); // async: baca SQLite
    budget = Prefs.budget;
    loading = false;
    notifyListeners();
  }
  Future<void> save(Tx t) async {
    t.id == null ? await Repo.insert(t) : await Repo.update(t);
    await load();
  }
  Future<void> remove(int id) async {
    await Repo.delete(id);
    await load();
  }
  int get income => list.where((t) => !t.expense).fold(0, (a, t) => a + t.amount);
  int get spent => list.where((t) => t.expense).fold(0, (a, t) => a + t.amount);
}
final store = Store();

void go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

Widget txTile(BuildContext c, Tx t) {
  final k = catOf(t.cat);
  return ListTile(
    onTap: () => go(c, TxForm(edit: t)),
    leading: CircleAvatar(backgroundColor: k.color.withOpacity(.2), child: Icon(k.icon, color: k.color)),
    title: Text(t.cat, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(t.note.isEmpty ? '${t.date.hour.toString().padLeft(2, '0')}:${t.date.minute.toString().padLeft(2, '0')}' : t.note),
    trailing: Text('${t.expense ? '-' : '+'} ${rp(t.amount)}', style: TextStyle(color: t.expense ? Colors.red : green, fontWeight: FontWeight.w600)),
  );
}

