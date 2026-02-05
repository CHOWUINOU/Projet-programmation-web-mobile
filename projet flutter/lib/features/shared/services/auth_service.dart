import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiClient _apiClient = ApiClient();

  // LOGIN
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        body: {'email': email, 'motdepasse': password},
        needsAuth: false,
      );

      final user = UserModel.fromJson(response);

      // Sauvegarder le token et les données utilisateur
      await _apiClient.setToken(user.token);
      await _saveUserData(user);

      return user;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur de connexion: $e');
    }
  }

  // REGISTER
  Future<UserModel> register({
    required String nom,
    required String email,
    required String password,
    required UserRole role,
    String? telephone,
    String? adresse,
    // Champs spécifiques vendeur
    String? nomBoutique,
    String? description,
    // Champs spécifiques livreur
    String? moyenTransport,
  }) async {
    try {
      final body = {
        'nom': nom,
        'email': email,
        'motdepasse': password,
        'telephone': telephone ?? '',
        'adresse': adresse ?? '',
        'typeUtilisateur': role.apiValue,
      };

      // Ajouter champs spécifiques selon le rôle
      if (role == UserRole.vendor) {
        body['nomBoutique'] = nomBoutique ?? nom;
        body['description'] = description ?? '';
      } else if (role == UserRole.delivery) {
        body['moyenTransport'] = moyenTransport ?? 'Moto';
      }

      // Inscription
      await _apiClient.post(
        ApiConstants.register,
        body: body,
        needsAuth: false,
      );

      // Connecter automatiquement après inscription
      return await login(email, password);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur d\'inscription: $e');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout, needsAuth: true);
    } catch (_) {
      // Ignorer les erreurs lors de la déconnexion
    } finally {
      await _clearUserData();
      await _apiClient.clearToken();
    }
  }

  // Récupérer l'utilisateur courant
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    final token = prefs.getString('auth_token');

    if (userData != null && token != null && token.isNotEmpty) {
      try {
        final user = UserModel.fromJson(jsonDecode(userData));
        // Restaurer le token dans l'API client
        await _apiClient.setToken(token);
        return user;
      } catch (_) {
        await _clearUserData();
        return null;
      }
    }
    return null;
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Sauvegarder les données utilisateur
  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    await prefs.setString('auth_token', user.token);
  }

  // Effacer les données utilisateur
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('auth_token');
  }

  // Récupérer le token JWT
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Token non trouvé, utilisateur non connecté');
    }

    return token;
  }
}
