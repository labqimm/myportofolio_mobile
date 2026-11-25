import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Tombol aksi berbentuk kartu. Warna latarnya diambil dari [ItemHomepage.color].
///
/// Saat ditekan, kartu memunculkan SnackBar berisi nama tombol, lalu
/// menjalankan aksi yang sesuai. Aksi "Tambah ..." dijaga [ensureLoggedIn].
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Memakai push() agar pengguna bisa kembali ke menu dengan tombol Back.
  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> _openProtected(BuildContext context, Widget page) async {
    final allowed = await ensureLoggedIn(context);
    if (!allowed || !context.mounted) return;
    _open(context, page);
  }

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthState>();
    if (!auth.isLoggedIn) {
      _showSnackBar(context, 'Kamu belum login.');
      return;
    }
    await auth.logout();
    if (!context.mounted) return;
    _showSnackBar(context, 'Kamu sudah logout.');
  }

  Future<void> _onTap(BuildContext context) async {
    // SnackBar penanda tombol ditekan (fitur Tugas 7). Logout punya pesan sendiri.
    if (item.name != 'Logout') {
      _showSnackBar(context, 'Kamu telah menekan tombol ${item.name}!');
    }

    switch (item.name) {
      case 'Lihat Proyek':
        _open(context, const ProjectListScreen());
      case 'Tambah Proyek':
        await _openProtected(context, const ProjectFormPage());
      case 'Tambah Education':
        await _openProtected(context, const EducationFormPage());
      case 'Logout':
        await _logout(context);
      default:
        // Tombol yang halamannya belum dibuat (mis. Lihat Experience)
        // cukup memunculkan SnackBar di atas.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // InkWell memberi efek riak (ripple) saat kartu disentuh.
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
