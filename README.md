# MyPortfolio Mobile

Aplikasi mobile Flutter untuk **portofolio pribadi Muhammad Iqbal**, dibuat untuk mata kuliah **Pemrograman Berbasis Platform (CSGE602022)**, Fakultas Ilmu Komputer Universitas Indonesia, Semester Gasal 2026/2027.

Aplikasi ini adalah klien mobile dari situs portofolio Django saya ([myportofolio](https://github.com/labqimm/myportofolio)). Pada tutorial mendatang, aplikasi ini akan terhubung langsung ke REST API (Django REST Framework) milik situs tersebut.

| | |
|---|---|
| **Nama** | Muhammad Iqbal |
| **NPM** | 2506657075 |
| **Kelas** | PBP C |
| **Framework** | Flutter (Dart) |
| **Repositori web (Django)** | [labqimm/myportofolio](https://github.com/labqimm/myportofolio) |

---

## Daftar Isi

- [Fitur](#fitur)
- [Tampilan](#tampilan)
- [Cara Menjalankan](#cara-menjalankan)
- [Struktur Proyek](#struktur-proyek)
- [Widget Tree Halaman Utama](#widget-tree-halaman-utama)
- [Progres Mingguan](#progres-mingguan)
- [Troubleshooting](#troubleshooting)
- [Pertanyaan Reflektif](#pertanyaan-reflektif)
- [AI Disclosure](#ai-disclosure)

---

## Fitur

**Kartu identitas (`InfoCard`)**
Tiga kartu di bagian atas halaman yang menampilkan NPM, nama, dan kelas.

**Tombol aksi (`ItemCard`) dengan warna unik**

| Tombol | Ikon | Warna |
|---|---|---|
| Lihat Proyek | `Icons.folder` | Biru |
| Tambah Proyek | `Icons.add_circle` | Hijau |
| Lihat Education | `Icons.school` | Ungu |
| Lihat Experience | `Icons.work` | Teal |
| Logout | `Icons.logout` | Merah |

Warna setiap tombol disimpan di model `ItemHomepage` (atribut `color`), sehingga `ItemCard` tidak memerlukan percabangan `if-else`. Menambah tombol baru cukup dengan menambah satu baris di list `items`.

**SnackBar interaktif**
Saat tombol ditekan, muncul pesan *"Kamu telah menekan tombol [Nama Tombol]!"* di bagian bawah layar. SnackBar sebelumnya ditutup dulu (`hideCurrentSnackBar`), jadi pesan tidak menumpuk saat tombol ditekan berkali-kali.

**Tata letak responsif** *(fitur tambahan)*
- Halaman dibungkus `SingleChildScrollView`, sehingga bisa di-scroll dan tidak terjadi *overflow* saat isi halaman lebih tinggi dari layar.
- Lebar grid tombol dibatasi maksimal 600 piksel (`ConstrainedBox`), sehingga tombol tetap berukuran wajar saat dibuka di browser desktop yang lebar.

---

## Tampilan

> Tambahkan screenshot aplikasi ke folder `docs/` lalu ganti baris di bawah ini.

<!-- ![Tampilan halaman utama](docs/screenshot-tugas7.png) -->

---

## Cara Menjalankan

### Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Google Chrome (untuk menjalankan versi web)
- VS Code dengan ekstensi **Flutter** dan **Dart** (opsional, tapi disarankan)

Periksa kelengkapan instalasi dengan:
```bash
flutter doctor
```

### Langkah
```bash
# 1. Clone repositori
git clone https://github.com/labqimm/myportofolio_mobile.git
cd myportofolio_mobile

# 2. Unduh dependensi
flutter pub get

# 3. Jalankan di Chrome
flutter run -d chrome

# 4. Periksa kualitas kode
flutter analyze
```

Saat aplikasi berjalan di terminal:
- `r` untuk **hot reload**
- `R` untuk **hot restart**
- `q` untuk keluar

---

## Struktur Proyek

```
myportofolio_mobile/
├── lib/
│   ├── main.dart      # Titik masuk aplikasi: MyApp, MaterialApp, dan tema warna
│   └── menu.dart      # Halaman utama dan komponennya
├── test/              # Widget test
├── web/, android/, ios/, windows/, linux/, macos/   # Pembungkus native tiap platform
├── pubspec.yaml       # Informasi proyek dan dependensi
└── analysis_options.yaml   # Aturan linter
```

Isi `lib/menu.dart`:

| Kelas | Jenis | Fungsi |
|---|---|---|
| `MyHomePage` | `StatelessWidget` | Halaman utama: menyusun AppBar, kartu identitas, dan grid tombol |
| `InfoCard` | `StatelessWidget` | Kartu identitas berisi judul dan isi |
| `ItemHomepage` | Model data | Menyimpan nama, ikon, dan warna sebuah tombol |
| `ItemCard` | `StatelessWidget` | Tampilan tombol berwarna yang memunculkan SnackBar |

Pemisahan `main.dart` dan `menu.dart` menerapkan prinsip *separation of concerns*: `main.dart` hanya bertugas menyalakan aplikasi, sedangkan semua tampilan halaman ada di `menu.dart`.

---

## Widget Tree Halaman Utama

```
MyApp
└── MaterialApp
    └── MyHomePage
        └── Scaffold
            ├── AppBar
            │   └── Text ("MyPortfolio")
            └── SingleChildScrollView
                └── Column
                    ├── Row
                    │   ├── InfoCard (NPM)  → Card → Container → Column → Text, SizedBox, Text
                    │   ├── InfoCard (Name)
                    │   └── InfoCard (Class)
                    ├── SizedBox
                    ├── Padding → Text ("Selamat datang ...")
                    └── ConstrainedBox
                        └── GridView.count
                            └── ItemCard ×5 → Material → InkWell → Container → Center → Column → Icon, Padding, Text
```

---

## Progres Mingguan

| Minggu | Tugas | Isi |
|---|---|---|
| 8 | Tutorial 08 | Instalasi Flutter SDK, membuat proyek `myportofolio_mobile`, memisahkan `menu.dart` dari `main.dart`, mengubah `MyHomePage` menjadi `StatelessWidget`, membuat `InfoCard` dan `ItemCard` |
| 8 | Tugas 7 | Identitas pribadi pada `InfoCard`, warna latar unik per tombol lewat atribut `color` di `ItemHomepage`, SnackBar per tombol. **Tambahan:** tombol Lihat Education dan Lihat Experience, tata letak responsif (scroll dan lebar grid dibatasi), komentar dokumentasi pada setiap kelas |

---

## Troubleshooting

Masalah yang saya temui selama pengerjaan dan cara mengatasinya:

| Masalah | Penyebab | Solusi |
|---|---|---|
| `flutter : The term 'flutter' is not recognized` | Flutter SDK belum terpasang atau belum terdaftar di `PATH` | Unduh SDK lewat `Flutter: New Project` di VS Code, klik **Add SDK to PATH**, lalu restart VS Code |
| `Flutter failed to delete a directory at ...\build\flutter_assets` | Folder `build` dikunci oleh sinkronisasi OneDrive dan proses `dart.exe` lama | Pindahkan proyek keluar dari OneDrive, matikan proses dengan `taskkill /F /IM dart.exe`, hapus folder `build` dengan `Remove-Item -Recurse -Force build`, lalu jalankan ulang |
| Garis kuning-hitam *"BOTTOM OVERFLOWED BY ... PIXELS"* | Di jendela browser yang lebar, grid 3 kolom membuat tombol sangat besar sehingga halaman melebihi tinggi layar | Membungkus body dengan `SingleChildScrollView` dan membatasi lebar grid dengan `ConstrainedBox(maxWidth: 600)` |
| Proyek Flutter sempat terbuat di dalam folder repo Django | Terminal masih berada di folder proyek Django saat membuat proyek | Membuat ulang proyek di folder terpisah agar repositori Git tidak bersarang |

---

## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree dan hubungan parent-child.**
   Di Flutter, seluruh tampilan aplikasi disusun dari widget, dan widget-widget itu saling bersarang membentuk struktur pohon yang disebut *widget tree*. Widget paling atas (root) adalah induk dari semua widget lain. Setiap widget bisa punya anak lewat properti `child` (satu anak) atau `children` (banyak anak). Hubungannya bekerja dua arah:
   - **Constraints turun ke bawah:** induk memberi batasan ukuran kepada anaknya. Contohnya `ConstrainedBox` membatasi lebar `GridView` maksimal 600 piksel, dan `Padding` memberi jarak di sekeliling anaknya.
   - **Ukuran naik ke atas:** anak menentukan ukurannya sendiri di dalam batasan itu, lalu melaporkannya kembali ke induk.
   - **Induk mengatur posisi:** setelah tahu ukuran anak-anaknya, induk menentukan posisinya. Contohnya `Row` menyusun tiga `InfoCard` berjajar dengan `spaceEvenly`.
   - **Data mengalir dari atas:** tema dan informasi lain bisa diakses widget di bawahnya. Contohnya `Theme.of(context)` di `MyHomePage` membaca tema yang dipasang oleh `MaterialApp`.

   Gambaran lengkap pohon widget aplikasi ini ada di bagian [Widget Tree Halaman Utama](#widget-tree-halaman-utama).

2. **Widget yang digunakan dan fungsinya.**
   - `MaterialApp`: root aplikasi. Menyediakan tema, navigasi, dan gaya Material Design.
   - `Scaffold`: kerangka halaman dengan slot untuk `appBar` dan `body`, sekaligus tempat SnackBar ditampilkan.
   - `AppBar`: bilah judul di bagian atas halaman.
   - `Text`: menampilkan teks (judul, isi kartu, nama tombol).
   - `SingleChildScrollView`: membuat isi halaman bisa di-scroll agar tidak *overflow*.
   - `Padding`: memberi jarak kosong di sekitar widget anaknya.
   - `Column`: menyusun anak-anaknya secara vertikal.
   - `Row`: menyusun anak-anaknya secara horizontal (dipakai untuk tiga `InfoCard`).
   - `SizedBox`: memberi jarak dengan ukuran tetap antar-widget.
   - `Center`: menempatkan anaknya di tengah.
   - `ConstrainedBox`: membatasi lebar maksimal grid tombol.
   - `GridView.count`: menampilkan tombol aksi dalam kisi 3 kolom.
   - `Card`: kotak dengan bayangan (*elevation*), dipakai sebagai wadah `InfoCard`.
   - `Container`: mengatur lebar dan padding isi kartu.
   - `Material`: memberi warna latar dan sudut melengkung pada `ItemCard`, sekaligus permukaan untuk efek *ripple*.
   - `InkWell`: membuat area yang bisa ditekan (`onTap`) dengan efek riak.
   - `Icon`: menampilkan ikon pada tombol.
   - `ScaffoldMessenger` dan `SnackBar`: menampilkan notifikasi singkat di bawah layar saat tombol ditekan.
   - `MediaQuery`: membaca ukuran layar agar lebar `InfoCard` menyesuaikan layar.
   - Widget buatan sendiri: `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard`.

3. **Fungsi `MaterialApp` dan alasan dipakai sebagai root.**
   `MaterialApp` adalah widget pembungkus yang menyiapkan semua hal yang dibutuhkan aplikasi bergaya Material Design: tema (`theme`, `colorScheme`), navigasi antarhalaman (`Navigator`, `routes`), judul aplikasi, lokalisasi, dan arah teks. Widget ini dipakai sebagai root karena banyak widget Material di bawahnya bergantung pada apa yang ia sediakan:
   - `Scaffold`, `AppBar`, dan `SnackBar` membutuhkan tema dan `Navigator`.
   - `Theme.of(context)` hanya mengembalikan tema buatan kita (indigo) jika di atasnya ada `MaterialApp` yang memasang tema tersebut.

   Dengan memasangnya di paling atas, seluruh halaman otomatis mendapat gaya dan fitur yang konsisten tanpa perlu diatur ulang di setiap halaman.

4. **`StatelessWidget` vs `StatefulWidget`.**
   - `StatelessWidget` tidak menyimpan *state* (data yang bisa berubah). Tampilannya hanya bergantung pada data yang diberikan saat dibuat, jadi tidak akan berubah sendiri.
   - `StatefulWidget` dipasangkan dengan objek `State` yang menyimpan data yang bisa berubah. Saat data itu diubah lewat `setState()`, Flutter memanggil ulang `build()` sehingga tampilan ikut diperbarui.

   Pilih `StatelessWidget` untuk tampilan yang tetap, seperti halaman menu ini (identitas dan daftar tombol tidak berubah). SnackBar pun tidak butuh state, karena ia ditampilkan oleh `ScaffoldMessenger`. Pilih `StatefulWidget` jika tampilan harus berubah karena interaksi atau data, misalnya penghitung klik (seperti aplikasi bawaan Flutter), form input, checkbox, atau data yang dimuat dari API. Aturan praktisnya: mulai dengan `StatelessWidget`, lalu ganti ke `StatefulWidget` hanya jika memang ada data yang perlu berubah.

5. **`BuildContext`.**
   `BuildContext` adalah "alamat" sebuah widget di dalam widget tree. Lewat context, sebuah widget bisa mencari dan memakai sesuatu yang disediakan oleh widget di atasnya. Di metode `build(BuildContext context)` pada proyek ini, context dipakai untuk:
   - `Theme.of(context)`: mengambil warna primer tema untuk `AppBar`.
   - `MediaQuery.of(context)`: membaca lebar layar untuk menentukan lebar `InfoCard`.
   - `ScaffoldMessenger.of(context)`: menemukan `Scaffold` terdekat untuk menampilkan SnackBar.

   Context itu penting karena posisinya menentukan apa yang bisa ditemukan. Pencarian selalu berjalan ke atas dari posisi widget tersebut, jadi context yang salah tempat (misalnya context milik widget di atas `Scaffold`) bisa membuat `.of(context)` gagal menemukan widget yang dicari.

6. **Hot reload vs hot restart.**
   - **Hot reload** (`r`) menyuntikkan kode yang berubah ke aplikasi yang sedang berjalan, lalu menjalankan ulang `build()`. Prosesnya sangat cepat dan **state tetap dipertahankan** (misalnya angka counter tidak kembali ke nol). Cocok untuk mengubah tampilan, warna, atau teks.
   - **Hot restart** (`R`) memuat ulang seluruh kode dan menjalankan aplikasi dari awal (`main()`), sehingga **semua state hilang**. Hasilnya lebih lambat dari hot reload, tapi masih lebih cepat daripada menjalankan ulang aplikasi sepenuhnya.

   Hot reload tidak cukup, sehingga perlu hot restart, ketika perubahan menyentuh hal yang hanya dijalankan sekali di awal. Contohnya: mengubah `main()` atau `initState()`, mengubah nilai variabel global atau `static`, mengubah `StatelessWidget` menjadi `StatefulWidget` (atau sebaliknya), atau mengubah definisi enum dan generic. **Full restart** (menghentikan lalu menjalankan ulang aplikasi) diperlukan saat mengubah kode native (Android/iOS), menambah *package* baru di `pubspec.yaml` yang punya kode native, atau mengubah aset dan konfigurasi platform.

---

## AI Disclosure

**Tools yang digunakan:** Claude (Anthropic).

**Log chat AI:** Percakapan dilakukan di Claude Cowork, yang tidak mendukung fitur share link. Sebagai gantinya, log prompting saya cantumkan di bawah, dan tangkapan layar percakapan ada di folder [`docs/ai-log/`](docs/ai-log/).

### Bagian yang dibantu AI
- **Setup lingkungan:** panduan instalasi Flutter SDK lewat ekstensi VS Code, serta troubleshooting saat `flutter` belum dikenali di `PATH`.
- **Struktur proyek:** saran untuk memindahkan proyek Flutter keluar dari folder repositori Django dan keluar dari OneDrive.
- **Kode `lib/menu.dart`:** penambahan atribut `color` pada `ItemHomepage` dan pemakaiannya di `ItemCard`, tombol tambahan Education dan Experience, perbaikan *overflow*, serta komentar dokumentasi.
- **Dokumentasi:** draf jawaban pertanyaan reflektif dan struktur README ini.

### Strategi prompting
Saya mengunggah PDF Tutorial 08 dan soal Tugas 7, lalu meminta penjelasan langkah demi langkah. Setiap kali ada error, saya mengirim screenshot terminal, VS Code, atau tampilan aplikasi di Chrome untuk didiagnosis, alih-alih mendeskripsikan error dengan kata-kata.

Ringkasan prompt yang saya gunakan:
1. "coba gimana cara kerjain tutor ini step by step" (lampiran PDF Tutorial 08)
2. "donlot versi yang mana dart nya" (screenshot halaman Dart SDK archive)
3. "ini gimana" (screenshot error `flutter` is not recognized)
4. "runnya gimana" (screenshot `main.dart` di VS Code)
5. "coba kerjakan step by step" (lampiran PDF Tugas 7)
6. "bearti kita disuruh ngapain sih di tugas 7 ini"
7. "masih gabisa" (screenshot error `Flutter failed to delete a directory ... build\flutter_assets`)
8. "ini udah nilai 4 belom buat semuanya"
9. "ini emang gini" (screenshot tampilan dengan garis *overflow*)

### Pemeriksaan dan perbaikan manual
- Mengisi NPM saya sendiri dan menyesuaikan identitas pada `InfoCard`.
- Menjalankan aplikasi di Chrome untuk memastikan warna tiap tombol berbeda dan SnackBar muncul dengan nama tombol yang benar.
- Menemukan sendiri tampilan *overflow* saat aplikasi dibuka di jendela browser yang lebar, lalu meminta perbaikannya.
- Menjalankan `flutter analyze` sampai hasilnya *No issues found*.
- Membaca ulang dan menyesuaikan jawaban reflektif dengan pemahaman saya sendiri.

### Keterbatasan AI yang saya temui
- **Tidak bisa menguji kode secara langsung.** AI tidak menjalankan proyek di laptop saya, sehingga kode yang diberikan belum teruji. Hasilnya harus saya verifikasi sendiri lewat `flutter run` dan `flutter analyze`.
- **Kode awal menimbulkan bug tata letak.** Versi pertama `menu.dart` dari AI mengalami *overflow* saat dibuka di browser desktop yang lebar, karena AI tidak memperhitungkan ukuran layar selain HP. Bug ini baru ketahuan setelah saya menjalankan aplikasinya sendiri.
- **Perkiraan alur instalasi kurang tepat.** AI mengira akan langsung muncul tombol *Download SDK*, padahal VS Code lebih dulu menampilkan pilihan template proyek.
- **Konteks lingkungan perlu diberikan secara eksplisit.** Masalah folder `build` yang terkunci baru bisa didiagnosis setelah AI melihat path proyek di screenshot (folder OneDrive), sehingga screenshot yang lengkap sangat membantu.