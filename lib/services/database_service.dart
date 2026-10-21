import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart';

/// PERSISTENCE #1 - SQLite: menyimpan data transaksi (data terstruktur).
class Repo {
  static Database? _db;
  static Future<Database> get db async => _db ??= await openDatabase(
        join(await getDatabasesPath(), 'hematku.db'), version: 1,
        onCreate: (d, _) => d.execute(
            'CREATE TABLE tx(id INTEGER PRIMARY KEY AUTOINCREMENT, expense INTEGER, amount INTEGER, cat TEXT, date TEXT, note TEXT)'),
      );
  static Future<List<Tx>> all() async =>
      (await (await db).query('tx', orderBy: 'date DESC, id DESC')).map(Tx.fromMap).toList();
  static Future<void> insert(Tx t) async => (await db).insert('tx', t.toMap()..remove('id'));
  static Future<void> update(Tx t) async => (await db).update('tx', t.toMap(), where: 'id=?', whereArgs: [t.id]);
  static Future<void> delete(int id) async => (await db).delete('tx', where: 'id=?', whereArgs: [id]);

  /// Read & Write Files (tambahan): ekspor transaksi ke berkas JSON.
  static Future<File> exportJson(List<Tx> list) async {
    final dir = await getApplicationDocumentsDirectory();
    final f = File(join(dir.path, 'laporan_hematku.json'));
    return f.writeAsString(const JsonEncoder.withIndent('  ').convert(list.map((e) => e.toMap()).toList()));
  }

  /// Read & Write Files: ekspor transaksi ke berkas PDF.
  static Future<File> exportPdf(List<Tx> list) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(build: (_) => [
          pw.Text('Laporan Transaksi HematKu', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
              headers: ['Tanggal', 'Jenis', 'Kategori', 'Nominal', 'Catatan'],
              data: list.map((t) => [t.date.toIso8601String().substring(0, 10), t.expense ? 'Pengeluaran' : 'Pemasukan', t.cat, t.amount.toString(), t.note]).toList()),
        ]));
    final dir = await getApplicationDocumentsDirectory();
    final f = File(join(dir.path, 'laporan_hematku.pdf'));
    return f.writeAsBytes(await doc.save());
  }
}
