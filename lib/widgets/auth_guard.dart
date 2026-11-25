import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// "Satpam" sebelum membuka halaman/aksi yang butuh login.
///
/// - Sudah login -> langsung `true`.
/// - Belum login -> buka [LoginScreen], tunggu hasilnya, lalu kembalikan
///   `true` kalau login berhasil atau `false` kalau pengguna menekan Back.
Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;

  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  return loggedIn ?? false;
}
