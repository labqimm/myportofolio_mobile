import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

/// Halaman utama aplikasi MyPortfolio Mobile.
///
/// Dibuat sebagai [StatelessWidget] karena semua isinya statis:
/// identitas pemilik dan daftar tombol tidak berubah selama aplikasi berjalan.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Identitas pemilik portofolio yang ditampilkan pada InfoCard.
  final String npm = "2506657075";
  final String nama = "Muhammad Iqbal";
  final String kelas = "PBP C";

  // Daftar tombol aksi. Setiap tombol punya nama, ikon, dan warna latar sendiri,
  // sehingga ItemCard tidak perlu percabangan if-else untuk menentukan warna.
  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Proyek", Icons.folder, Colors.blue),
    ItemHomepage("Tambah Proyek", Icons.add_circle, Colors.green),
    ItemHomepage("Lihat Education", Icons.school, Colors.purple),
    ItemHomepage("Tambah Education", Icons.post_add, Colors.orange),
    ItemHomepage("Lihat Experience", Icons.work, Colors.teal),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan kerangka halaman: AppBar, drawer, dan body.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Ikon hamburger (pembuka drawer) dibuat putih agar kontras dengan AppBar.
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Drawer menu untuk berpindah antarhalaman.
      drawer: const LeftDrawer(),
      // SingleChildScrollView membuat halaman bisa di-scroll jika isinya
      // lebih tinggi dari layar, sehingga tidak terjadi overflow.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Baris berisi tiga kartu identitas yang disusun sejajar.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: nama),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Selamat datang di MyPortfolio Mobile!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            // Lebar kisi dibatasi maksimal 600 piksel agar tombol tidak
            // membesar berlebihan saat dibuka di layar lebar (browser desktop).
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: GridView.count(
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                // shrinkWrap agar tinggi kisi menyesuaikan jumlah tombol, dan
                // scroll kisi dimatikan karena halaman sudah bisa di-scroll.
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu kecil yang menampilkan satu informasi identitas,
/// berupa judul ([title]) dan isinya ([content]).
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        // Lebar kartu menyesuaikan lebar layar agar tiga kartu muat dalam satu baris.
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Model data untuk satu tombol aksi di halaman utama.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}
