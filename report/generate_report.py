# Jalankan: pip install reportlab pillow && python generate_report.py
# Ubah data diri di bawah, (opsional) taruh logo fakultas sebagai report/logo.png, lalu jalankan ulang.
import os
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_JUSTIFY, TA_CENTER
from reportlab.platypus import (BaseDocTemplate, PageTemplate, Frame, Paragraph, Spacer, Image, Table, TableStyle,
                                PageBreak, Preformatted, KeepTogether, NextPageTemplate)
from reportlab.platypus.tableofcontents import TableOfContents

NAMA = "Naswa Vifda Zalianti"
NIM = "[ISI NIM]"
JURUSAN = "[ISI NAMA JURUSAN / PROGRAM STUDI]"
FAKULTAS = "[ISI NAMA FAKULTAS]"
KAMPUS = "[ISI NAMA PERGURUAN TINGGI]"
TAHUN = "2026"
HERE = os.path.dirname(os.path.abspath(__file__))

body = ParagraphStyle('b', fontName='Times-Roman', fontSize=11.5, leading=17, alignment=TA_JUSTIFY, spaceAfter=6)
h1 = ParagraphStyle('h1', fontName='Times-Bold', fontSize=14, leading=18, alignment=TA_CENTER, spaceAfter=12)
h2 = ParagraphStyle('h2', fontName='Times-Bold', fontSize=12, leading=16, spaceBefore=8, spaceAfter=6)
cap = ParagraphStyle('cap', fontName='Times-Italic', fontSize=9.5, leading=12, alignment=TA_CENTER, spaceAfter=8)
cell = ParagraphStyle('c', fontName='Times-Roman', fontSize=9.5, leading=12)
cellb = ParagraphStyle('cb', parent=cell, fontName='Times-Bold', alignment=TA_CENTER)
code = ParagraphStyle('code', fontName='Courier', fontSize=7.6, leading=9.4, backColor=colors.HexColor('#F3F4F6'),
                      borderPadding=5, leftIndent=4, rightIndent=4, spaceBefore=4, spaceAfter=10)
bl = ParagraphStyle('bl', parent=body, leftIndent=18, bulletIndent=4, spaceAfter=2)

class Doc(BaseDocTemplate):
    def __init__(self, fn):
        super().__init__(fn, pagesize=A4, leftMargin=4*cm, rightMargin=3*cm, topMargin=3*cm, bottomMargin=3*cm)
        f = Frame(self.leftMargin, self.bottomMargin, self.width, self.height, id='f')
        self.addPageTemplates([PageTemplate('cover', [f]), PageTemplate('main', [f], onPage=self.num)])
    def num(self, c, d):
        c.setFont('Times-Roman', 10); c.drawCentredString(A4[0]/2, 1.5*cm, str(d.page))
    def afterFlowable(self, fl):
        if isinstance(fl, Paragraph) and fl.style.name in ('h1', 'h2'):
            lvl = 0 if fl.style.name == 'h1' else 1
            t = fl.getPlainText(); self.notify('TOCEntry', (lvl, t, self.page))

S = []
P = lambda t: S.append(Paragraph(t, body))
H1 = lambda t: (S.append(PageBreak()), S.append(Paragraph(t, h1)))
H2 = lambda t: S.append(Paragraph(t, h2))
def B(items):
    for i in items: S.append(Paragraph(i, bl, bulletText='•'))
def C(t): S.append(Preformatted(t.strip('\n'), code))
fig = [0]
def figs(items, bab="2"):
    """items: list of (file, caption). Tampil 3 gambar per baris, bernomor."""
    for i in range(0, len(items), 3):
        row, caps = [], []
        for fn, c in items[i:i+3]:
            fig[0] += 1
            row.append(Image(os.path.join(HERE, 'img', fn + '.png'), width=4.1*cm, height=4.1*cm*{'splash':2.0}.get(fn, 1.0), kind='proportional'))
            caps.append(Paragraph(f'Gambar {bab}.{fig[0]} {c}', cap))
        S.append(Table([row, caps], colWidths=[4.3*cm]*len(row), style=[('VALIGN', (0,0), (-1,-1), 'TOP'), ('ALIGN', (0,0), (-1,-1), 'CENTER')]))
        S.append(Spacer(1, 6))
def tbl(rows, widths, head=True):
    data = [[Paragraph(str(x), cellb if (head and r == 0) else cell) for x in row] for r, row in enumerate(rows)]
    t = Table(data, colWidths=widths, repeatRows=1)
    t.setStyle(TableStyle([('GRID', (0,0), (-1,-1), .5, colors.black), ('BACKGROUND', (0,0), (-1,0), colors.HexColor('#D9EFE3')), ('VALIGN', (0,0), (-1,-1), 'TOP')]))
    S.append(t); S.append(Spacer(1, 10))

# ---------------- COVER ----------------
S.append(Spacer(1, 10))
logo = os.path.join(HERE, 'logo.png')
if os.path.exists(logo): S.append(Image(logo, width=3.6*cm, height=3.6*cm, kind='proportional'))
else: S.append(Table([[Paragraph('[LOGO FAKULTAS]<br/>(letakkan logo.png di folder report/ lalu jalankan ulang generate_report.py)', cellb)]], colWidths=[6*cm], rowHeights=[3.6*cm], style=[('BOX', (0,0), (-1,-1), .8, colors.grey), ('VALIGN', (0,0), (-1,-1), 'MIDDLE')]))
cs = lambda sz, b=True: ParagraphStyle('x', fontName='Times-Bold' if b else 'Times-Roman', fontSize=sz, leading=sz*1.4, alignment=TA_CENTER)
S += [Spacer(1, 30), Paragraph('LAPORAN UJIAN TENGAH SEMESTER', cs(14)), Paragraph('PEMROGRAMAN MULTIPLATFORM', cs(14)), Spacer(1, 20),
      Paragraph('APLIKASI PENCATATAN KEUANGAN PRIBADI<br/>"HEMATKU"', cs(17)), Spacer(1, 10),
      Paragraph('Implementasi Asynchronous Programming, SQLite, dan Shared Preferences pada Flutter', cs(12, False)), Spacer(1, 50),
      Paragraph('Disusun oleh:', cs(12, False)), Paragraph(NAMA, cs(13)), Paragraph(f'NIM: {NIM}', cs(12, False)), Spacer(1, 50),
      Paragraph(JURUSAN.upper(), cs(12)), Paragraph(FAKULTAS.upper(), cs(12)), Paragraph(KAMPUS.upper(), cs(12)), Paragraph(TAHUN, cs(12))]
S += [NextPageTemplate('main'), PageBreak()]
S.append(Paragraph('DAFTAR ISI', h1))
toc = TableOfContents(); toc.levelStyles = [ParagraphStyle('t0', fontName='Times-Bold', fontSize=11, leading=16), ParagraphStyle('t1', fontName='Times-Roman', fontSize=11, leading=15, leftIndent=18)]
S.append(toc)

# ---------------- BAB I ----------------
H1('BAB I. PENDAHULUAN')
H2('1.1. Latar Belakang dan Gambaran Aplikasi')
P('Pengelolaan keuangan pribadi merupakan kebutuhan sehari-hari, terutama bagi mahasiswa yang mengatur uang saku, biaya kuliah, transportasi, dan kebutuhan lainnya. Pencatatan secara manual sering terlupa, tidak rapi, dan sulit dievaluasi sehingga pengeluaran menjadi tidak terkontrol. Diperlukan aplikasi sederhana yang dapat mencatat pemasukan dan pengeluaran dengan cepat, menampilkan ringkasan kondisi keuangan, serta tetap dapat digunakan tanpa koneksi internet.')
P('Untuk menjawab kebutuhan tersebut dikembangkan aplikasi <b>HematKu</b>, yaitu aplikasi pencatatan keuangan pribadi berbasis Flutter dan Dart. Tujuan pengembangannya adalah (1) menerapkan konsep <i>asynchronous programming</i>, (2) menerapkan dua teknik <i>data persistence</i>, yaitu SQLite dan Shared Preferences, serta (3) merancang antarmuka yang mudah digunakan. Sasaran pengguna adalah mahasiswa dan masyarakat umum yang ingin mencatat dan memantau keuangan harian. Seluruh data disimpan pada perangkat sehingga aplikasi berfungsi secara <i>offline</i>.')
H2('1.2. Fitur Aplikasi')
tbl([['No.', 'Fitur', 'Fungsi dan Manfaat'],
     ['1', 'Splash dan Login', 'Pengguna masuk dengan email dan password; opsi "Ingat saya" menyimpan sesi sehingga pengguna langsung masuk pada pembukaan berikutnya.'],
     ['2', 'Beranda', 'Menampilkan total saldo, progres anggaran bulanan, ringkasan pemasukan/pengeluaran hari ini, dan transaksi terbaru.'],
     ['3', 'Tambah, ubah, hapus transaksi', 'Mencatat nominal, kategori, tanggal, dan catatan; data dapat diedit atau dihapus kapan saja.'],
     ['4', 'Daftar transaksi', 'Transaksi dikelompokkan per tanggal, dapat difilter (semua/pemasukan/pengeluaran) dan dicari.'],
     ['5', 'Pilih kategori', 'Sembilan kategori bergambar untuk mempercepat input.'],
     ['6', 'Grafik', 'Diagram donut pengeluaran per kategori berdasarkan rentang minggu, bulan, atau tahun.'],
     ['7', 'Anggaran bulanan', 'Pengguna menetapkan batas anggaran dan memantau sisa anggaran.'],
     ['8', 'Pengaturan dan profil', 'Tema terang/gelap, informasi akun, ringkasan total pemasukan dan pengeluaran, serta keluar akun.'],
     ['9', 'Laporan transaksi', 'Mengekspor seluruh transaksi ke berkas PDF atau JSON pada penyimpanan internal perangkat.']],
    [1*cm, 4*cm, 8*cm])

# ---------------- BAB II ----------------
H1('BAB II. PEMBAHASAN')
H2('2.1. Desain Antarmuka Pengguna (User Interface)')
P('Antarmuka dirancang dengan Material 3 dengan palet warna hijau (#2F6B4F) sebagai warna utama, latar krem lembut, serta kartu berwarna mint untuk pemasukan dan merah muda untuk pengeluaran agar mudah dibedakan. Navigasi utama menggunakan <i>bottom navigation bar</i> dengan empat menu: Beranda, Transaksi, Grafik, dan Profil. Fungsi setiap halaman dijelaskan berikut.')
B(['<b>Splash (Gambar 2.1)</b>: halaman pembuka berisi logo, slogan, dan tombol "Mulai".',
   '<b>Login (Gambar 2.2)</b>: formulir email, password dengan tombol tampil/sembunyi, kotak "Ingat saya", tombol Masuk, dan tombol Google.',
   '<b>Beranda (Gambar 2.3)</b>: kartu saldo dan anggaran, menu cepat (Tambah Transaksi, Grafik, Laporan, Pengaturan), ringkasan hari ini, dan transaksi terbaru.',
   '<b>Transaksi (Gambar 2.4)</b>: daftar transaksi per tanggal dengan filter, kolom pencarian, dan tombol tambah (+).',
   '<b>Tambah Transaksi (Gambar 2.5)</b> dan <b>Pilih Kategori (Gambar 2.6)</b>: formulir input dan kisi kategori.',
   '<b>Edit Transaksi (Gambar 2.7)</b>: formulir yang sama dengan data terisi serta tombol Hapus Transaksi.',
   '<b>Grafik (Gambar 2.8)</b>: diagram donut dan rincian persentase per kategori.',
   '<b>Anggaran Bulanan (Gambar 2.9)</b>: total anggaran, persentase pemakaian, sisa anggaran, dan tombol Atur Anggaran.',
   '<b>Pengaturan (Gambar 2.10)</b>, <b>Profil (Gambar 2.11)</b>, dan <b>Laporan Transaksi (Gambar 2.12)</b>.'])
figs([('splash', 'Halaman Splash'), ('login', 'Halaman Login'), ('home', 'Halaman Beranda'),
      ('transaksi', 'Halaman Daftar Transaksi'), ('tambah', 'Halaman Tambah Transaksi'), ('kategori', 'Halaman Pilih Kategori'),
      ('edit', 'Halaman Edit Transaksi'), ('grafik', 'Halaman Grafik'), ('anggaran', 'Halaman Anggaran Bulanan'),
      ('pengaturan', 'Halaman Pengaturan'), ('profil', 'Halaman Profil'), ('laporan', 'Halaman Laporan Transaksi')])
P('<i>Catatan: gambar di atas adalah rancangan antarmuka (UI design) yang menjadi acuan implementasi. Ganti dengan tangkapan layar aplikasi yang sedang berjalan bila diperlukan.</i>')

H2('2.2. Persiapan Project dan Package')
P('Project dibuat dengan perintah <font face="Courier">flutter create hematku</font>, kemudian dikembangkan dengan struktur folder berikut.')
C('''
hematku/
├── pubspec.yaml            # dependensi
├── README.md
└── lib/
    ├── main.dart           # entry point, tema, ThemeMode
    ├── core.dart           # warna, format rupiah/tanggal, Store (state)
    ├── data.dart           # barrel export models & services
    ├── models/
    │   ├── category.dart   # data kategori + ikon
    │   └── transaction.dart# model Tx (toMap/fromMap)
    ├── services/
    │   ├── database_service.dart # SQLite + ekspor berkas
    │   └── prefs_service.dart    # Shared Preferences
    └── screens/            # splash, login, shell, home, transaksi,
                            # form, chart, profile, settings, budget, report''')
P('Package tambahan yang digunakan:')
tbl([['Package', 'Fungsi', 'Alasan Penggunaan'],
     ['sqflite', 'Basis data SQLite lokal', 'Menyimpan data transaksi yang terstruktur dan membutuhkan operasi CRUD.'],
     ['path', 'Penyusunan lokasi berkas', 'Membentuk path basis data dan berkas ekspor lintas platform.'],
     ['shared_preferences', 'Penyimpanan key-value', 'Menyimpan anggaran, tema, email, dan status "Ingat saya".'],
     ['path_provider', 'Akses direktori aplikasi', 'Mendapatkan folder dokumen untuk menulis berkas laporan.'],
     ['pdf', 'Pembuatan dokumen PDF', 'Menghasilkan laporan transaksi berformat PDF.']], [3.2*cm, 4.3*cm, 5.5*cm])

H2('2.3. Implementasi Asynchronous Programming')
P('Operasi yang memerlukan waktu, seperti akses basis data, pembacaan preferensi, penulisan berkas, dan proses login, dijalankan secara asinkron agar antarmuka tidak membeku. Dart menyediakan <font face="Courier">Future</font> untuk mewakili hasil yang belum tersedia, serta <font face="Courier">async</font> dan <font face="Courier">await</font> untuk menunggu hasil tanpa memblokir <i>main thread</i>.')
B(['<b>Proses login</b> (login_page.dart): simulasi autentikasi dengan <font face="Courier">Future.delayed</font>; selama menunggu tombol dinonaktifkan dan indikator putar tampil.',
   '<b>Memuat transaksi</b> (core.dart, <font face="Courier">Store.load</font>): membaca SQLite; selama proses <font face="Courier">loading=true</font> aplikasi menampilkan <font face="Courier">CircularProgressIndicator</font>.',
   '<b>Menyimpan dan menghapus</b> transaksi: menunggu operasi basis data selesai, lalu memuat ulang data sehingga UI selalu mutakhir.',
   '<b>Ekspor laporan</b> (report_page.dart): menulis berkas PDF/JSON secara asinkron, lalu menampilkan lokasi berkas.'])
P('<b>Kode 1. Proses login asinkron</b>')
C('''
Future<void> masuk() async {
  setState(() => busy = true);                         // tampilkan loading
  await Future.delayed(const Duration(seconds: 1));    // proses butuh waktu
  await Prefs.setEmail(email.text);                    // simpan ke prefs
  await Prefs.setLoggedIn(remember);
  if (!mounted) return;
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => const Shell()));
}''')
P('Fungsi bertanda <font face="Courier">async</font> mengembalikan <font face="Courier">Future&lt;void&gt;</font>. Kata kunci <font face="Courier">await</font> menjeda eksekusi fungsi sampai proses selesai tanpa menghentikan penggambaran UI. Pemeriksaan <font face="Courier">mounted</font> memastikan widget masih aktif sebelum berpindah halaman.')
P('<b>Kode 2. Memuat dan menyimpan data dengan state loading</b>')
C('''
class Store extends ChangeNotifier {
  List<Tx> list = [];
  bool loading = true;
  Future<void> load() async {
    loading = true;  notifyListeners();
    list = await Repo.all();        // async: baca SQLite
    budget = Prefs.budget;
    loading = false; notifyListeners();
  }
  Future<void> save(Tx t) async {
    t.id == null ? await Repo.insert(t) : await Repo.update(t);
    await load();                   // muat ulang setelah simpan
  }
}''')
P('Pada <font face="Courier">main()</font>, <font face="Courier">Prefs.load()</font> dan <font face="Courier">store.load()</font> di-<i>await</i> sebelum <font face="Courier">runApp</font>. Widget <font face="Courier">ListenableBuilder</font> pada halaman utama memantau <font face="Courier">Store</font>: saat <font face="Courier">loading</font> bernilai true tampil indikator, dan setelah selesai data ditampilkan.')
P('<b>Kode 3. Ekspor laporan asinkron</b>')
C('''
Future<void> export() async {
  setState(() => busy = true);
  final f = fmt == 'pdf'
      ? await Repo.exportPdf(store.list)
      : await Repo.exportJson(store.list);   // tulis berkas
  setState(() { busy = false; path = f.path; });
}''')

H2('2.4. Implementasi Data Persistence')
P('Aplikasi menerapkan dua teknik penyimpanan data utama, yaitu <b>SQLite</b> dan <b>Shared Preferences</b>. Selain itu, fitur laporan menulis berkas PDF/JSON sebagai fitur tambahan.')
H2('A. SQLite')
B(['<b>Alasan pemilihan</b>: transaksi adalah data terstruktur dalam jumlah banyak yang perlu diurutkan, dicari, diubah, dan dihapus; hal ini sesuai dengan basis data relasional.',
   '<b>Jenis data</b>: tabel <font face="Courier">tx</font> dengan kolom id, expense (0/1), amount, cat, date (ISO-8601), dan note.',
   '<b>Hubungan dengan fitur</b>: dipakai oleh halaman Beranda, Transaksi, Tambah/Edit, Grafik, dan Profil.'])
C('''
static Future<Database> get db async => _db ??= await openDatabase(
  join(await getDatabasesPath(), 'hematku.db'), version: 1,
  onCreate: (d, _) => d.execute(
    'CREATE TABLE tx(id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'expense INTEGER, amount INTEGER, cat TEXT, date TEXT, note TEXT)'));

static Future<List<Tx>> all() async =>
  (await (await db).query('tx', orderBy: 'date DESC, id DESC'))
      .map(Tx.fromMap).toList();                       // READ
static Future<void> insert(Tx t) async =>
  (await db).insert('tx', t.toMap()..remove('id'));    // CREATE
static Future<void> update(Tx t) async => (await db)
  .update('tx', t.toMap(), where: 'id=?', whereArgs: [t.id]); // UPDATE
static Future<void> delete(int id) async =>
  (await db).delete('tx', where: 'id=?', whereArgs: [id]);    // DELETE''')
P('Basis data dibuka satu kali (<i>lazy singleton</i>) dan tabel dibuat pada <font face="Courier">onCreate</font>. Setiap operasi CRUD bersifat asinkron. Penyimpanan terjadi saat tombol Simpan ditekan (<font face="Courier">Store.save</font>), pembacaan terjadi saat aplikasi dibuka dan setiap setelah perubahan data.')
H2('B. Shared Preferences')
B(['<b>Alasan pemilihan</b>: data berupa pengaturan kecil berpasangan kunci-nilai yang tidak perlu struktur tabel.',
   '<b>Jenis data</b>: <font face="Courier">budget</font> (int), <font face="Courier">dark</font> (bool, tema), <font face="Courier">loggedIn</font> (bool, ingat saya), dan <font face="Courier">email</font> (string).',
   '<b>Hubungan dengan fitur</b>: Anggaran Bulanan, Tema pada Pengaturan, "Ingat saya" pada Login, dan email pada Profil.'])
C('''
class Prefs {
  static late SharedPreferences _p;
  static Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    dark.value = _p.getBool('dark') ?? false;
  }
  static int get budget => _p.getInt('budget') ?? 1000000;   // READ
  static Future<void> setBudget(int v) => _p.setInt('budget', v); // WRITE
  static Future<void> setDark(bool v) async {
    dark.value = v;                       // ubah tema langsung
    await _p.setBool('dark', v);          // simpan permanen
  }
}''')
P('Nilai tema disimpan dalam <font face="Courier">ValueNotifier</font> sehingga <font face="Courier">MaterialApp</font> langsung berganti tema saat saklar diubah dan pilihan tetap tersimpan setelah aplikasi ditutup.')
H2('C. Tambahan: Read and Write Files')
P('Fitur Laporan menulis seluruh transaksi ke berkas <font face="Courier">laporan_hematku.pdf</font> atau <font face="Courier">laporan_hematku.json</font> di direktori dokumen aplikasi menggunakan <font face="Courier">path_provider</font> dan <font face="Courier">dart:io</font>.')
C('''
static Future<File> exportJson(List<Tx> list) async {
  final dir = await getApplicationDocumentsDirectory();
  final f = File(join(dir.path, 'laporan_hematku.json'));
  return f.writeAsString(const JsonEncoder.withIndent('  ')
      .convert(list.map((e) => e.toMap()).toList()));
}''')

H2('2.5. Pengujian dan Hasil Implementasi')
P('Pengujian dilakukan secara <i>black-box</i> pada emulator/perangkat Android dengan menjalankan <font face="Courier">flutter run</font>. Kolom hasil pengujian diisi setelah pengujian dilakukan pada perangkat penguji.')
R = '[  ] Berhasil<br/>[  ] Gagal'
tbl([['No.', 'Fitur yang Diuji', 'Langkah Pengujian', 'Hasil yang Diharapkan', 'Hasil Pengujian'],
     ['1', 'Fitur utama: tambah transaksi', 'Buka Tambah Transaksi, isi nominal 25000, kategori Makan, tanggal, lalu tekan Simpan.', 'Transaksi muncul di Beranda dan daftar Transaksi; saldo ikut berubah.', R],
     ['2', 'Fitur utama: edit dan hapus', 'Buka salah satu transaksi, ubah nominal lalu Simpan; ulangi dan tekan Hapus Transaksi.', 'Data berubah sesuai input; setelah dihapus transaksi hilang dari daftar.', R],
     ['3', 'Fitur utama: filter, cari, grafik', 'Gunakan filter Pemasukan/Pengeluaran, ketik kata kunci, dan buka tab Grafik.', 'Daftar tersaring sesuai input; grafik menampilkan persentase per kategori.', R],
     ['4', 'Proses asinkron: login', 'Isi email valid dan password minimal 4 karakter, tekan Masuk.', 'Muncul indikator loading sekitar 1 detik, lalu pindah ke Beranda.', R],
     ['5', 'Proses asinkron: muat data', 'Buka aplikasi dengan beberapa data tersimpan.', 'Indikator loading tampil singkat, lalu data muncul tanpa UI membeku.', R],
     ['6', 'Penyimpanan data pertama (SQLite)', 'Simpan beberapa transaksi, pindah antar menu.', 'Data tersimpan dan terbaca kembali pada daftar.', R],
     ['7', 'Penyimpanan data kedua (Shared Preferences)', 'Atur anggaran menjadi 2.000.000 dan aktifkan Tema Gelap.', 'Anggaran dan tema berubah dan dapat dibaca kembali.', R],
     ['8', 'Persistensi data', 'Tutup aplikasi sepenuhnya lalu buka kembali.', 'Transaksi, anggaran, tema, dan sesi login (jika "Ingat saya") tetap ada.', R],
     ['9', 'Mode offline', 'Aktifkan mode pesawat, gunakan seluruh fitur.', 'Semua fitur tetap berjalan tanpa internet.', R],
     ['10', 'Ekspor laporan (berkas)', 'Buka Laporan, pilih PDF lalu Export; ulangi dengan JSON.', 'Berkas dibuat dan lokasi berkas ditampilkan.', R]],
    [1.1*cm, 2.5*cm, 3.8*cm, 3.4*cm, 2.2*cm])
P('<b>Kendala dan penanganan.</b> (1) Plugin <font face="Courier">sqflite</font> hanya berjalan pada Android, iOS, dan macOS sehingga pengujian dilakukan pada emulator/perangkat Android, bukan pada peramban web. (2) Pemanggilan <font face="Courier">Navigator</font> setelah <font face="Courier">await</font> dapat menimbulkan peringatan <i>use_build_context_synchronously</i>; kendala ini diatasi dengan memeriksa <font face="Courier">mounted</font> sebelum berpindah halaman. (3) Tambahkan di sini kendala lain yang ditemukan saat pengujian, jika ada.')

# ---------------- BAB III ----------------
H1('BAB III. PENUTUP')
H2('3.1. Kesimpulan')
P('Aplikasi HematKu berhasil dikembangkan menggunakan Flutter dan Dart sebagai aplikasi pencatatan keuangan pribadi dengan fitur pencatatan transaksi, ringkasan saldo, anggaran bulanan, grafik, dan ekspor laporan. Konsep <i>asynchronous programming</i> diterapkan dengan <font face="Courier">Future</font>, <font face="Courier">async</font>, dan <font face="Courier">await</font> pada proses login, akses basis data, dan penulisan berkas sehingga antarmuka tetap responsif. Dua teknik <i>data persistence</i> berfungsi sesuai kebutuhan: SQLite untuk data transaksi yang terstruktur dan Shared Preferences untuk pengaturan sederhana. Dengan demikian data tetap tersedia setelah aplikasi ditutup dan tanpa koneksi internet, sehingga tujuan pengembangan tercapai.')
H2('3.2. Saran')
B(['Menambahkan autentikasi sungguhan (misalnya Firebase Auth) dan sinkronisasi data ke <i>cloud</i>.',
   'Mengamankan data sensitif dengan enkripsi basis data atau <i>secure storage</i>.',
   'Menambahkan transaksi berulang, pengingat anggaran, serta anggaran per kategori.',
   'Menambahkan grafik tren (garis/batang) dan fitur impor data dari berkas.',
   'Menambahkan pengujian otomatis (unit dan widget test) dan dukungan lintas platform lebih luas.'])

H1('DAFTAR PUSTAKA')
for r in ['Flutter. (2026). <i>Flutter documentation</i>. https://docs.flutter.dev',
          'Flutter. (2026). <i>Persist data with SQLite</i>. https://docs.flutter.dev/cookbook/persistence/sqlite',
          'Flutter. (2026). <i>Store key-value data on disk</i>. https://docs.flutter.dev/cookbook/persistence/key-value',
          'Flutter. (2026). <i>Read and write files</i>. https://docs.flutter.dev/cookbook/persistence/reading-writing-files',
          'Dart. (2026). <i>Asynchronous programming: futures, async, await</i>. https://dart.dev/codelabs/async-await',
          'pub.dev. (2026). <i>sqflite</i>. https://pub.dev/packages/sqflite',
          'pub.dev. (2026). <i>shared_preferences</i>. https://pub.dev/packages/shared_preferences',
          'pub.dev. (2026). <i>path_provider</i>. https://pub.dev/packages/path_provider',
          'pub.dev. (2026). <i>pdf</i>. https://pub.dev/packages/pdf']:
    S.append(Paragraph(r, ParagraphStyle('r', parent=body, leftIndent=18, firstLineIndent=-18, alignment=0)))

doc = Doc(os.path.join(HERE, 'Laporan_UTS_HematKu.pdf'))
doc.multiBuild(S)
print('OK')
