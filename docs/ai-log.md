# Log Percakapan AI: Tutorial 08 & Tugas 7

**Tools:** Claude (Anthropic), lewat Claude Cowork
**Periode:** 11–16 November 2026
**Catatan:** Claude Cowork tidak mendukung fitur share link, jadi log ini adalah ringkasan percakapan yang disusun ulang. Prompt ditulis apa adanya. Jawaban AI diringkas.

---

## Bagian 1: Tutorial 08 (Setup dan Kode Dasar)

| No | Prompt saya | Ringkasan jawaban AI |
|---|---|---|
| 1 | "coba gimana cara kerjain tutor ini step by step" (lampiran PDF Tutorial 08) | Menjelaskan alur tutorial: instalasi Flutter dan Android Studio, `flutter doctor`, `flutter create`, menjalankan di Chrome, memisahkan `menu.dart`, membuat `InfoCard` dan `ItemCard`, `flutter analyze`, lalu push ke GitHub. Disertai kode final `main.dart` dan `menu.dart`. |
| 2 | "donlot versi yang mana dart nya" (screenshot Dart SDK archive) | Dart tidak perlu diunduh terpisah karena sudah termasuk di dalam Flutter SDK. Disarankan langsung mengunduh Flutter. |
| 3 | "yang kiri ya" (screenshot pilihan *Install with VS Code*) | Boleh, dan lebih mudah karena PATH diatur otomatis. Butuh VS Code dan Git. Langkahnya: `Flutter: New Project` → Download SDK → Add SDK to PATH. |
| 4 | "ini gimana" (screenshot error `flutter is not recognized`) | Flutter belum terunduh atau VS Code belum di-restart. Cek dengan `Test-Path`. AI juga mengingatkan agar proyek Flutter tidak dibuat di dalam folder proyek Django. |
| 5 | (screenshot hasil `Test-Path` = `False`) | SDK memang belum ada. Langkah unduh SDK lewat VS Code ke `C:\src`. |
| 6 | "udah diinstall kok" (screenshot ekstensi Flutter) | Yang terpasang baru ekstensinya, SDK-nya belum. Lanjut unduh SDK lewat Command Palette. |
| 7 | (screenshot `mkdir C:\src`) | Folder berhasil dibuat. Git dipastikan terpasang dari indikator branch di VS Code. |
| 8 | (screenshot pilihan template Flutter) | Pilih *Application*, lalu buat proyek bernama `myportofolio_mobile` di folder terpisah. |
| 9 | "kalo dah gini ngapain lagi" (screenshot proyek berhasil dibuat) | Cek `flutter --version`, pilih Chrome sebagai device, jalankan, lalu tulis kode. |
| 10 | (screenshot *Select debugger* dan hasil `pwd`) | Proyek ternyata terbuat di dalam folder repo Django. AI menyarankan membuat ulang proyek di folder terpisah. Untuk debugger, pilih *Dart & Flutter*. |
| 11 | "kanan bawah gmn cara biar web javascript" | Klik *No Device* di status bar, lalu pilih Chrome. Notifikasi Java dan Git boleh diabaikan. |
| 12 | "apa codenya" | Kode lengkap `lib/menu.dart` dan `lib/main.dart`, beserta penjelasan singkat tiap kelas. |
| 13 | "runnya gimana" | Jalankan lewat *Run* di atas `main()`, tombol F5, atau `flutter run -d chrome`. |
| 14 | "sudah bisa selanjutnya gimana" | Langkah `flutter analyze`, membuat repo GitHub publik, `git init` sampai `git push`, lalu mengumpulkan link commit. |

## Bagian 2: Tugas 7 (Kustomisasi dan Dokumentasi)

| No | Prompt saya | Ringkasan jawaban AI |
|---|---|---|
| 15 | "coba kerjakan step by step" (lampiran PDF Tugas 7) | Membuat `menu.dart` versi Tugas 7: identitas pribadi, atribut `color` di `ItemHomepage`, warna unik per tombol, dan komentar dokumentasi. Membuat draf README berisi jawaban reflektif dan AI disclosure. Menyarankan commit bertahap dengan format *conventional commits*. |
| 16 | "mana file menu dan readmenya tidak muncul" | File dikirim ulang. |
| 17 | "bearti kita disuruh ngapain sih di tugas 7 ini" | Ringkasan 5 poin tugas: data diri, tombol berwarna unik, SnackBar, `flutter analyze` bersih, README dan push. |
| 18 | (screenshot error `Flutter failed to delete a directory ... build\flutter_assets`) | Penyebabnya folder `build` dikunci oleh OneDrive. Solusi: `flutter clean`, jeda sinkronisasi OneDrive, atau pindahkan proyek keluar dari OneDrive. |
| 19 | "masih gabisa" (error yang sama setelah proyek dipindah) | Matikan proses lama dengan `taskkill /F /IM dart.exe`, lalu hapus folder `build` dengan `Remove-Item -Recurse -Force build`. |
| 20 | "ini y atau n jawabnya" (*Terminate batch job*) | Jawaban Y atau N sama saja. Lain kali gunakan `q` untuk menghentikan `flutter run`. |
| 21 | "bagian link dmn yak di readme" | Menunjukkan dua link GitHub di README yang perlu disesuaikan. |
| 22 | "bukan maksdunya link chat ai" | Menambahkan bagian log chat AI dan ringkasan prompt ke README. |
| 23 | "ini udah nilai 4 belom buat semuanya" | Perkiraan per rubrik: fungsionalitas masih 3.5, kategori lain berpotensi 4. Saran: tambah tombol Lihat Education dan Lihat Experience sebagai fitur ekstra. |
| 24 | "ini emang gini" (screenshot *BOTTOM OVERFLOWED*) | Bug *overflow* di layar lebar. Diperbaiki dengan `SingleChildScrollView`, `ConstrainedBox(maxWidth: 600)`, dan `NeverScrollableScrollPhysics`. |
| 25 | "harusnya gini yak" (screenshot tampilan sudah benar) | Tampilan sudah sesuai. Lanjut `flutter analyze`, commit, dan push. |
| 26 | "oke sekarang gimana readme yang super lengkap" | README lengkap: fitur, cara menjalankan, struktur proyek, widget tree, progres mingguan, troubleshooting, jawaban reflektif, dan AI disclosure dengan analisis keterbatasan AI. |
| 27 | "gimana cara share chat ini" | Sesi Cowork tidak bisa di-share lewat link (sesuai dokumentasi resmi Claude). Sebagai gantinya, cantumkan log prompting. |
| 28 | "bisa gak ringkas chat ini jadi tinggal di tempel" | Membuat file log ini. |

---

## Catatan Kritis

- **Kode dari AI tidak teruji oleh AI sendiri.** Semua kode saya jalankan dan cek sendiri dengan `flutter run -d chrome` dan `flutter analyze`.
- **Ada bug dari kode AI.** Versi pertama `menu.dart` di Tugas 7 mengalami *overflow* di browser desktop. Bug ini saya temukan saat menjalankan aplikasi, lalu saya minta perbaikannya (prompt no. 24).
- **AI butuh konteks lengkap.** Error folder `build` dan lokasi proyek yang salah baru bisa didiagnosis setelah AI melihat path di screenshot. Mengirim screenshot terbukti lebih efektif daripada menjelaskan error dengan kata-kata.
- **Perkiraan alur instalasi dari AI tidak selalu tepat.** Contohnya, AI memperkirakan tombol *Download SDK* akan muncul lebih dulu, padahal VS Code langsung menampilkan pilihan template.