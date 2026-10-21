# HematKu
Aplikasi pencatatan keuangan pribadi (UTS Pemrograman Multiplatform).

## Fitur Utama
Login & "Ingat saya", beranda saldo + anggaran, CRUD transaksi, pencarian & filter, pilih kategori, grafik donut (minggu/bulan/tahun), atur anggaran, tema gelap, ekspor laporan JSON.

## Teknologi
Flutter, Dart, `sqflite` (SQLite - data transaksi), `shared_preferences` (anggaran, tema, sesi login), `path_provider` + `dart:io` (ekspor berkas JSON), `async/await` + `Future`.

## Menjalankan
```
flutter create .   # generate folder android/ios (sekali saja)
flutter pub get
flutter run
```
