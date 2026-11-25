/// Base URL backend Django REST Framework (tanpa garis miring di akhir).
///
/// Default `http://10.0.2.2:8000`: dari dalam emulator Android, alamat
/// 10.0.2.2 menunjuk ke komputer host (tempat `python manage.py runserver`).
///
/// Ganti saat menjalankan aplikasi dengan `--dart-define`, misalnya:
/// - Chrome : `--dart-define=API_BASE_URL=http://localhost:8000`
/// - PWS    : `--dart-define=API_BASE_URL=https://muhammad-iqbal517-myportofolio.pws.cs.ui.ac.id`
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
