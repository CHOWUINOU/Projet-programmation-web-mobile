import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Code: $statusCode)';
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? _cachedToken;

  Future<String?> _getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> setToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, String>> _getHeaders({bool needsAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // GET request
  Future<dynamic> get(String url, {bool needsAuth = true}) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .get(uri, headers: await _getHeaders(needsAuth: needsAuth))
          .timeout(
            const Duration(milliseconds: ApiConstants.connectionTimeout),
            onTimeout: () => throw ApiException('Délai de connexion dépassé'),
          );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on FormatException {
      throw ApiException('Format de réponse invalide');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erreur: $e');
    }
  }

  // POST request
  Future<dynamic> post(
    String url, {
    Map<String, dynamic>? body,
    bool needsAuth = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .post(
            uri,
            headers: await _getHeaders(needsAuth: needsAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            const Duration(milliseconds: ApiConstants.connectionTimeout),
            onTimeout: () => throw ApiException('Délai de connexion dépassé'),
          );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on FormatException {
      throw ApiException('Format de réponse invalide');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erreur: $e');
    }
  }

  // PUT request
  Future<dynamic> put(
    String url, {
    Map<String, dynamic>? body,
    bool needsAuth = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .put(
            uri,
            headers: await _getHeaders(needsAuth: needsAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            const Duration(milliseconds: ApiConstants.connectionTimeout),
            onTimeout: () => throw ApiException('Délai de connexion dépassé'),
          );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erreur: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String url, {bool needsAuth = true}) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .delete(uri, headers: await _getHeaders(needsAuth: needsAuth))
          .timeout(
            const Duration(milliseconds: ApiConstants.connectionTimeout),
            onTimeout: () => throw ApiException('Délai de connexion dépassé'),
          );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erreur: $e');
    }
  }

  // PATCH request
  Future<dynamic> patch(
    String url, {
    Map<String, dynamic>? body,
    bool needsAuth = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .patch(
            uri,
            headers: await _getHeaders(needsAuth: needsAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            const Duration(milliseconds: ApiConstants.connectionTimeout),
            onTimeout: () => throw ApiException('Délai de connexion dépassé'),
          );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erreur: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    print('API Response [${response.statusCode}]: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body);
      case 204:
        return {};
      case 400:
        final body = _parseErrorBody(response.body);
        throw ApiException(
          body['message'] ?? 'Requête invalide',
          statusCode: 400,
        );
      case 401:
        clearToken();
        throw ApiException(
          'Session expirée. Veuillez vous reconnecter.',
          statusCode: 401,
        );
      case 403:
        throw ApiException('Accès interdit', statusCode: 403);
      case 404:
        throw ApiException('Ressource non trouvée', statusCode: 404);
      case 409:
        final body = _parseErrorBody(response.body);
        throw ApiException(
          body['message'] ?? 'Conflit de données',
          statusCode: 409,
        );
      case 422:
        final body = _parseErrorBody(response.body);
        throw ApiException(
          body['message'] ?? 'Données invalides',
          statusCode: 422,
        );
      case 500:
        throw ApiException(
          'Erreur serveur. Réessayez plus tard.',
          statusCode: 500,
        );
      default:
        throw ApiException('Erreur inconnue', statusCode: response.statusCode);
    }
  }

  Map<String, dynamic> _parseErrorBody(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {};
    }
  }
}
