import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitializing = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitializing => _isInitializing;
  UserRole? get userRole => _user?.primaryRole;

  // Initialisation au démarrage
  Future<void> initializeAuth() async {
    _isInitializing = true;
    notifyListeners();

    try {
      final currentUser = await _authService.getCurrentUser();
      _user = currentUser;
      _error = null;
    } catch (e) {
      _error = null;
      _user = null;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  // Connexion
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      _user = user;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erreur de connexion: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Inscription
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? phone,
    String? address,
    String? nomBoutique,
    String? description,
    String? moyenTransport,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.register(
        nom: name,
        email: email,
        password: password,
        role: role,
        telephone: phone,
        adresse: address,
        nomBoutique: nomBoutique,
        description: description,
        moyenTransport: moyenTransport,
      );
      _user = user;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erreur d\'inscription: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Déconnexion
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
    } catch (_) {
      // Ignorer les erreurs
    } finally {
      _user = null;
      _error = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
