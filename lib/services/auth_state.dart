import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Menyimpan token login di memori dan memberi tahu widget yang "mendengar"
/// (lewat `context.watch<AuthState>()`) setiap kali status login berubah.
class AuthState extends ChangeNotifier {
  AuthState(this._apiClient, {String? initialToken}) : _token = initialToken;

  final ApiClient _apiClient;
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  /// Melempar [ApiException] (400) jika username/password salah.
  Future<void> login(String username, String password) async {
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  /// Logout normal: cabut token di server, lalu hapus dari memori.
  Future<void> logout() async {
    final current = _token;
    if (current == null) return;

    try {
      await _apiClient.logout(token: current);
    } on Exception {
      // ApiException (token sudah tidak berlaku) atau ClientException
      // (server tidak terjangkau): tetap lanjut logout lokal.
    } finally {
      // Selalu dijalankan, meskipun request ke server gagal.
      _token = null;
      notifyListeners();
    }
  }

  /// Dipakai saat server membalas 401: token sudah tidak berlaku, jadi
  /// tidak perlu menghubungi server lagi, cukup hapus sesi lokal.
  void clearSession() {
    if (_token == null) return;
    _token = null;
    notifyListeners();
  }
}
