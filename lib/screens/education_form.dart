import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan riwayat pendidikan (Education).
///
/// Field-nya mengikuti model `Education` di proyek Django:
/// - `institution` : CharField(max_length=150), wajib
/// - `level`       : pilihan SD, SMP, SMA/SMK, D3, S1, S2 (default S1)
/// - `major`       : CharField(max_length=100), boleh kosong
/// - `start_year`  : PositiveIntegerField, wajib
/// - `end_year`    : PositiveIntegerField, boleh kosong (masih berlangsung)
///
/// Dibuat sebagai [StatefulWidget] karena isi formulir berubah-ubah
/// mengikuti input pengguna.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  // Kunci untuk mengakses state Form: validate() dan reset().
  final _formKey = GlobalKey<FormState>();

  // Batas panjang sesuai max_length di model Django.
  static const int _maxInstitutionLength = 150;
  static const int _maxMajorLength = 100;

  // Batas tahun yang masuk akal untuk riwayat pendidikan.
  static const int _minYear = 1950;
  final int _currentYear = DateTime.now().year;

  // Pilihan jenjang, sama dengan LEVEL_CHOICES di model Django.
  static const List<String> _levels = ['SD', 'SMP', 'SMA/SMK', 'D3', 'S1', 'S2'];

  // Variabel penyimpan isi setiap field.
  String _institution = "";
  String _level = "S1"; // default sama dengan model Django
  String _major = "";
  String _startYear = "";
  String _endYear = "";
  bool _isOngoing = false; // true = masih menempuh, end_year dikosongkan

  // ------------------------------------------------------------------
  // Validator. Dipisah dari build() agar aturan validasi mudah dibaca.
  // ------------------------------------------------------------------

  /// Institusi wajib diisi, tidak boleh hanya spasi, maksimal 150 karakter.
  String? _validateInstitution(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nama institusi tidak boleh kosong!";
    }
    if (value.trim().length > _maxInstitutionLength) {
      return "Nama institusi maksimal $_maxInstitutionLength karakter!";
    }
    return null;
  }

  /// Jurusan boleh kosong, tapi jika diisi tidak boleh hanya spasi
  /// dan maksimal 100 karakter.
  String? _validateMajor(String? value) {
    if (value == null || value.isEmpty) return null; // opsional
    if (value.trim().isEmpty) {
      return "Jurusan tidak boleh hanya berisi spasi!";
    }
    if (value.trim().length > _maxMajorLength) {
      return "Jurusan maksimal $_maxMajorLength karakter!";
    }
    return null;
  }

  /// Tahun mulai wajib, harus 4 digit, dan berada di antara 1950
  /// sampai tahun sekarang (tidak bisa mulai di masa depan).
  String? _validateStartYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Tahun mulai tidak boleh kosong!";
    }
    final year = int.tryParse(value.trim());
    if (year == null || value.trim().length != 4) {
      return "Tahun mulai harus berupa 4 digit angka!";
    }
    if (year < _minYear || year > _currentYear) {
      return "Tahun mulai harus antara $_minYear dan $_currentYear!";
    }
    return null;
  }

  /// Tahun selesai wajib jika pendidikan sudah selesai, harus 4 digit,
  /// tidak boleh lebih awal dari tahun mulai, dan maksimal 10 tahun
  /// dari sekarang (perkiraan tahun lulus).
  String? _validateEndYear(String? value) {
    if (_isOngoing) return null; // field disembunyikan, tidak perlu dicek
    if (value == null || value.trim().isEmpty) {
      return "Isi tahun selesai atau aktifkan 'Masih berlangsung'!";
    }
    final year = int.tryParse(value.trim());
    if (year == null || value.trim().length != 4) {
      return "Tahun selesai harus berupa 4 digit angka!";
    }
    final start = int.tryParse(_startYear.trim());
    if (start != null && year < start) {
      return "Tahun selesai tidak boleh sebelum tahun mulai ($start)!";
    }
    if (year > _currentYear + 10) {
      return "Tahun selesai maksimal ${_currentYear + 10}!";
    }
    return null;
  }

  // ------------------------------------------------------------------
  // Aksi tombol
  // ------------------------------------------------------------------

  /// Dipanggil saat tombol Simpan ditekan. Dialog ringkasan hanya muncul
  /// jika semua validator mengembalikan null (lolos validasi).
  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Riwayat pendidikan tersimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryRow(label: 'Institusi', value: _institution.trim()),
                _SummaryRow(label: 'Jenjang', value: _level),
                _SummaryRow(
                  label: 'Jurusan',
                  value: _major.trim().isEmpty ? '-' : _major.trim(),
                ),
                _SummaryRow(label: 'Tahun mulai', value: _startYear.trim()),
                _SummaryRow(
                  label: 'Tahun selesai',
                  value: _isOngoing ? 'Masih berlangsung' : _endYear.trim(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog, kembali ke formulir
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Mengosongkan semua field teks setelah data disimpan.
  /// Jenjang sengaja tidak di-reset agar dropdown dan variabel `_level`
  /// tetap sinkron (pengguna juga sering mengisi jenjang yang sama).
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _institution = "";
      _major = "";
      _startYear = "";
      _endYear = "";
      _isOngoing = false;
    });
  }

  /// Dekorasi seragam untuk setiap input agar tampilannya konsisten.
  InputDecoration _decoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      // AppBar memakai warna primer tema, sama seperti halaman utama.
      appBar: AppBar(
        title: const Text(
          'Add Education',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      // Drawer yang sama dengan halaman utama dan formulir proyek.
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // SingleChildScrollView membuat formulir bisa di-scroll, sehingga
        // tombol Simpan tetap terjangkau di layar sempit atau saat
        // papan ketik muncul.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            // Lebar formulir dibatasi agar tetap rapi di browser desktop.
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // === Institution ===
                  TextFormField(
                    decoration: _decoration(
                      "Nama Institusi",
                      "Contoh: Universitas Indonesia",
                      Icons.account_balance,
                    ),
                    maxLength: _maxInstitutionLength,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      setState(() => _institution = value);
                    },
                    validator: _validateInstitution,
                  ),
                  const SizedBox(height: 12),

                  // === Level ===
                  DropdownButtonFormField<String>(
                    decoration: _decoration(
                      "Jenjang",
                      "Pilih jenjang pendidikan",
                      Icons.school,
                    ),
                    initialValue: _level,
                    items: _levels
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() => _level = newValue!);
                    },
                  ),
                  const SizedBox(height: 20),

                  // === Major ===
                  TextFormField(
                    decoration: _decoration(
                      "Jurusan (opsional)",
                      "Contoh: Ilmu Komputer",
                      Icons.menu_book,
                    ),
                    maxLength: _maxMajorLength,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      setState(() => _major = value);
                    },
                    validator: _validateMajor,
                  ),
                  const SizedBox(height: 12),

                  // === Start Year ===
                  TextFormField(
                    decoration: _decoration(
                      "Tahun Mulai",
                      "Contoh: 2025",
                      Icons.calendar_today,
                    ),
                    // Papan ketik angka + filter hanya digit, maksimal 4.
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    onChanged: (String value) {
                      setState(() => _startYear = value);
                    },
                    validator: _validateStartYear,
                  ),
                  const SizedBox(height: 8),

                  // === Switch: masih berlangsung ===
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Masih berlangsung'),
                    subtitle: const Text('Aktifkan jika belum lulus'),
                    value: _isOngoing,
                    onChanged: (bool value) {
                      setState(() {
                        _isOngoing = value;
                        if (value) _endYear = "";
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  // === End Year (disembunyikan jika masih berlangsung) ===
                  if (!_isOngoing) ...[
                    TextFormField(
                      decoration: _decoration(
                        "Tahun Selesai",
                        "Contoh: 2029",
                        Icons.event_available,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (String value) {
                        setState(() => _endYear = value);
                      },
                      validator: _validateEndYear,
                    ),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 12),

                  // === Tombol Simpan ===
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _onSave,
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan"),
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

/// Satu baris ringkasan di dalam dialog: label tebal lalu nilainya.
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}