import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// Authentication state for the entire application.
///
/// Holds the JWT token, username, and display name after a successful
/// WebUntis login. Consumed by the widget tree via [ChangeNotifierProvider].
class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  String? _token;
  String? _username;
  String? _displayName;
  String? _password; // kept in memory to allow timetable re-auth

  bool get isLoggedIn => _token != null;
  String? get username => _username;
  String? get displayName => _displayName;
  String? get password => _password;

  /// The shared [ApiService] instance, pre-configured with the current token.
  ApiService get api => _api;

  /// Authenticate against WebUntis via the backend.
  ///
  /// Returns `null` on success, or an error message string on failure.
  Future<String?> login(String username, String password) async {
    try {
      final result = await _api.login(username, password);
      _token = result['access_token'] as String;
      _username = result['username'] as String? ?? username;
      _displayName = result['display_name'] as String? ?? username;
      _password = password;
      _api.setToken(_token!);
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Backend nicht erreichbar. Bitte versuche es später.';
    }
  }

  /// Clear the session and notify all listeners.
  Future<void> logout() async {
    await _api.logout();
    _token = null;
    _username = null;
    _displayName = null;
    _password = null;
    notifyListeners();
  }
}
