/// HTTP client for the BK-Witten Flask backend API.
///
/// Usage:
/// ```dart
/// final service = ApiService();
/// final result = await service.login("user", "pass");
/// ```
///
/// All methods return a [Map<String, dynamic>] on success or throw an
/// [ApiException] on HTTP / network errors.

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thrown when the backend returns a non-2xx status code.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  /// Base URL of the Flask backend.
  ///
  /// Override this constant (or add a build-time environment variable via
  /// `--dart-define=API_BASE_URL=https://...`) for production deployments.
  static const String baseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:5000/api');

  String? _token;

  /// Store the JWT token after a successful login.
  void setToken(String token) => _token = token;

  /// Clear the stored token on logout.
  void clearToken() => _token = null;

  /// Whether the user currently has a token.
  bool get isAuthenticated => _token != null;

  // ─── Helpers ─────────────────────────────────────────────────────────────

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final body = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> data;
    try {
      data = json.decode(body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(response.statusCode, body);
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }
    final msg = data['error'] ?? data['message'] ?? 'Unbekannter Fehler';
    throw ApiException(response.statusCode, msg.toString());
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────

  /// Authenticate with WebUntis credentials.
  ///
  /// Returns ``{ access_token, username, display_name }`` on success.
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: json.encode({'username': username, 'password': password}),
    );
    return _handleResponse(response);
  }

  /// Logout (server-side confirmation).
  Future<void> logout() async {
    if (_token == null) return;
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _headers,
      );
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      clearToken();
    }
  }

  /// Fetch the current user's profile.
  Future<Map<String, dynamic>> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // ─── Timetable ────────────────────────────────────────────────────────────

  /// Fetch the weekly timetable from WebUntis via the backend.
  ///
  /// [date] defaults to today (ISO format YYYY-MM-DD).
  /// [password] must be re-sent because the backend re-authenticates against
  /// WebUntis to fetch live data.
  /// [klasse] is the optional school-class name (e.g. "IT21A").
  Future<Map<String, dynamic>> getWeekTimetable({
    String? date,
    required String password,
    String? klasse,
  }) async {
    final body = <String, dynamic>{
      'password': password,
      if (date != null) 'date': date,
      if (klasse != null) 'klasse': klasse,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/timetable/week'),
      headers: _headers,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // ─── Mitteilungen ─────────────────────────────────────────────────────────

  /// Return all Mitteilungen (newest first).
  Future<List<Map<String, dynamic>>> getMitteilungen() async {
    final response = await http.get(
      Uri.parse('$baseUrl/mitteilungen/'),
      headers: _headers,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final list = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    }
    final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final msg = data['error'] ?? 'Fehler beim Laden';
    throw ApiException(response.statusCode, msg.toString());
  }

  /// Create a new Mitteilung.
  Future<Map<String, dynamic>> createMitteilung({
    required String title,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mitteilungen/'),
      headers: _headers,
      body: json.encode({'title': title, 'content': content}),
    );
    return _handleResponse(response);
  }

  /// Update an existing Mitteilung.
  Future<Map<String, dynamic>> updateMitteilung({
    required int id,
    required String title,
    required String content,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/mitteilungen/$id'),
      headers: _headers,
      body: json.encode({'title': title, 'content': content}),
    );
    return _handleResponse(response);
  }

  /// Delete a Mitteilung by its ID.
  Future<void> deleteMitteilung(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/mitteilungen/$id'),
      headers: _headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final msg = data['error'] ?? 'Fehler beim Löschen';
      throw ApiException(response.statusCode, msg.toString());
    }
  }
}
