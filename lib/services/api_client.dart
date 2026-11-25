import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Dilempar ketika server membalas dengan status di luar 2xx.
class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;

  /// Isi body mentah dari server (bisa JSON error DRF atau halaman HTML).
  final String message;

  /// Pesan yang aman ditampilkan ke pengguna, tanpa membocorkan body mentah
  /// (halaman error HTML/stack trace Django saat DEBUG=True).
  String get friendlyMessage {
    switch (statusCode) {
      case 400:
        return _firstValidationError() ?? 'Data yang dikirim tidak valid.';
      case 401:
        return 'Sesi kamu sudah berakhir. Silakan login lagi.';
      case 403:
        return 'Kamu tidak punya izin untuk melakukan aksi ini.';
      case 404:
        return 'Data tidak ditemukan.';
      default:
        if (statusCode >= 500) {
          return 'Server sedang bermasalah ($statusCode). Coba lagi nanti.';
        }
        return 'Permintaan gagal (kode $statusCode).';
    }
  }

  /// Mengambil pesan pertama dari error validasi DRF, misalnya
  /// `{"start_year": ["Tahun masuk wajib diisi."]}` -> "start_year: Tahun ...".
  String? _firstValidationError() {
    try {
      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic> && decoded.isNotEmpty) {
        final entry = decoded.entries.first;
        final value = entry.value;
        final text = value is List && value.isNotEmpty ? value.first : value;
        if (entry.key == 'non_field_errors' || entry.key == 'detail') {
          return text.toString();
        }
        return '${entry.key}: $text';
      }
    } on FormatException {
      // Body bukan JSON (misalnya halaman HTML) -> pakai pesan umum.
    }
    return null;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Mengubah error apa pun dari pemanggilan API menjadi kalimat untuk pengguna.
String describeError(Object? error) {
  if (error is ApiException) return error.friendlyMessage;
  if (error is http.ClientException) {
    // Server mati, URL salah, atau (di Chrome) diblokir CORS.
    return 'Tidak dapat terhubung ke server. Pastikan Django berjalan '
        'dan API_BASE_URL benar ($apiBaseUrl).';
  }
  return 'Terjadi kesalahan: $error';
}

/// Klien HTTP untuk backend Django REST Framework MyPortfolio.
///
/// Semua pemanggilan jaringan dikumpulkan di sini, sehingga widget/screen
/// cukup fokus menampilkan UI.
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  // Kunci header ditulis sebagai string biasa (bukan HttpHeaders dari
  // dart:io) agar aplikasi tetap bisa di-build untuk Flutter Web.
  static const Map<String, String> _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _authHeaders(String token) => {
    ..._jsonHeaders,
    'Authorization': 'Token $token',
  };

  // ------------------------------ Auth ------------------------------

  /// Menukar username + password menjadi token DRF.
  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: _jsonHeaders,
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['token'] as String;
  }

  /// Mencabut token di server (balasan 204 No Content, body kosong).
  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: _authHeaders(token),
    );
    _ensureSuccess(response);
  }

  // ---------------------------- Projects ----------------------------

  /// GET publik: tidak perlu token.
  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      _uri('/api/v1/projects/'),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST terautentikasi: wajib membawa header Authorization.
  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: _authHeaders(token),
      body: jsonEncode(project.toJson()),
    );
    _ensureSuccess(response);
    return Project.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ----------------------------- Helper -----------------------------

  /// Melempar [ApiException] (bukan mengembalikan null) jika status bukan 2xx,
  /// sehingga FutureBuilder/try-catch di UI bisa menampilkan error.
  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, response.body);
  }
}
