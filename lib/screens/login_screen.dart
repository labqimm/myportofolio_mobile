import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Halaman login. Mengembalikan `true` lewat `Navigator.pop` jika berhasil,
/// sehingga pemanggil ([ensureLoggedIn]) tahu login sukses.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Ambil objek dari context SEBELUM await (context bisa tidak valid sesudahnya).
    final auth = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      await auth.login(_username.trim(), _password);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Berhasil login sebagai ${_username.trim()}.')),
      );
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      // DRF membalas 400 jika username/password salah.
      final text = e.statusCode == 400
          ? 'Username atau password salah.'
          : e.friendlyMessage;
      messenger.showSnackBar(
        SnackBar(content: Text('Login gagal (${e.statusCode}): $text')),
      );
    } on http.ClientException {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat terhubung ke server. Cek API_BASE_URL.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Login dengan akun Django kamu untuk menambah data.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => _username = value,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onChanged: (value) => _password = value,
                    // Tekan Enter di kolom password = sama dengan tombol Login.
                    onFieldSubmitted: (_) {
                      if (!_isSubmitting) _submit();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    // null = tombol nonaktif selama request berjalan
                    // (mencegah login terkirim dua kali).
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
