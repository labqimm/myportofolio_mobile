import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Formulir tambah proyek yang mengirim `POST /api/v1/projects/`.
///
/// Field-nya mengikuti `ProjectSerializer` di Django (bukan mock form
/// Tutorial 09): title, description, tech_stack, year, repo_url, is_featured.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Batas panjang sesuai max_length di model Django.
  static const int _maxTitleLength = 120;
  static const int _maxTechStackLength = 200;

  String _title = '';
  String _description = '';
  String _techStack = '';
  String _year = '';
  String _repoUrl = '';
  bool _isFeatured = false;
  bool _isSubmitting = false;

  // ------------------------------ Validator ------------------------------

  String? _required(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field tidak boleh kosong!';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tahun tidak boleh kosong!';
    }
    final year = int.tryParse(value.trim());
    if (year == null || value.trim().length != 4) {
      return 'Tahun harus berupa 4 digit angka!';
    }
    if (year > DateTime.now().year + 1) {
      return 'Tahun tidak boleh terlalu jauh di masa depan!';
    }
    return null;
  }

  /// URL repositori opsional, tetapi jika diisi harus diawali http(s)://
  /// (sama dengan URLField Django, supaya tidak dapat error 400).
  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : 'Masukkan URL yang valid (https://...)';
  }

  // -------------------------------- Submit -------------------------------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Pastikan sudah login. Kalau belum, LoginScreen dibuka dulu.
    final allowed = await ensureLoggedIn(context);
    if (!allowed || !mounted) return;

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);
    final token = auth.token;
    if (token == null) return;

    final newProject = Project(
      title: _title.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      year: int.parse(_year.trim()),
      repoUrl: _repoUrl.trim(),
      isFeatured: _isFeatured,
    );

    setState(() => _isSubmitting = true);
    try {
      final created = await api.createProject(newProject, token: token);
      if (!mounted) return;
      await _showSuccessDialog(created);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token sudah dicabut/kedaluwarsa: hapus sesi, lalu minta login ulang.
        auth.clearSession();
        messenger.showSnackBar(SnackBar(content: Text(e.friendlyMessage)));
        if (mounted) await ensureLoggedIn(context);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: ${e.friendlyMessage}')),
        );
      }
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSuccessDialog(Project created) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil disimpan!'),
        content: Text(
          '"${created.title}" (${created.year}) sudah tersimpan di Django '
          'dengan id ${created.id}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _resetForm();
            },
            child: const Text('Tambah lagi'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // tutup dialog
              // Buka daftar yang baru (otomatis GET ulang) dan buang halaman
              // di atas Home, supaya tombol Back tidak kembali ke daftar lama.
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectListScreen(),
                ),
                (route) => route.isFirst,
              );
            },
            child: const Text('Lihat daftar'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _description = '';
      _techStack = '';
      _year = '';
      _repoUrl = '';
      _isFeatured = false;
    });
  }

  InputDecoration _decoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: _decoration('Title', 'Contoh: MyPortfolio'),
                    maxLength: _maxTitleLength,
                    onChanged: (value) => setState(() => _title = value),
                    validator: (value) => _required(value, 'Judul'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 4,
                    decoration: _decoration(
                      'Description',
                      'Ceritakan proyekmu',
                    ),
                    onChanged: (value) => setState(() => _description = value),
                    validator: (value) => _required(value, 'Deskripsi'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: _decoration(
                      'Tech Stack',
                      'Contoh: Django, Flutter',
                    ),
                    maxLength: _maxTechStackLength,
                    onChanged: (value) => setState(() => _techStack = value),
                    validator: (value) => _required(value, 'Tech stack'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: _decoration('Year', 'Contoh: 2026'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    onChanged: (value) => setState(() => _year = value),
                    validator: _validateYear,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: _decoration(
                      'Repository URL (Optional)',
                      'https://github.com/labqimm/...',
                    ),
                    keyboardType: TextInputType.url,
                    onChanged: (value) => setState(() => _repoUrl = value),
                    validator: _validateUrl,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Proyek unggulan (featured)'),
                    value: _isFeatured,
                    onChanged: (value) => setState(() => _isFeatured = value),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text('Save'),
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
