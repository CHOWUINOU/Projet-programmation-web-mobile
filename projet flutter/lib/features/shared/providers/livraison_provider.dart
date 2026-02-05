import 'package:flutter/material.dart';
import '../models/commande_model.dart';
import '../models/livraison_model.dart';
import '../services/livraison_service.dart';
import '../services/api_client.dart';

class LivraisonProvider extends ChangeNotifier {
  final LivraisonService _livraisonService = LivraisonService();

  List<CommandeModel> _livraisonsDisponibles = [];
  List<CommandeModel> _mesLivraisons = [];
  CommandeModel? _selectedLivraison;
  LivreurStats? _stats;
  bool _isLoading = false;
  String? _error;

  List<CommandeModel> get livraisonsDisponibles => _livraisonsDisponibles;
  List<CommandeModel> get mesLivraisons => _mesLivraisons;
  CommandeModel? get selectedLivraison => _selectedLivraison;
  LivreurStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Livraisons en cours
  List<CommandeModel> get livraisonsEnCours => _mesLivraisons
      .where(
        (l) =>
            l.livraison?.statut == 'ASSIGNEE' ||
            l.livraison?.statut == 'EN_COURS',
      )
      .toList();

  // Livraisons terminées
  List<CommandeModel> get livraisonsTerminees =>
      _mesLivraisons.where((l) => l.livraison?.statut == 'LIVREE').toList();

  // Charger les livraisons disponibles
  Future<void> loadLivraisonsDisponibles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _livraisonsDisponibles = await _livraisonService
          .getLivraisonsDisponibles();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger mes livraisons
  Future<void> loadMesLivraisons(int livreurId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _mesLivraisons = await _livraisonService.getMesLivraisons(livreurId);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger les statistiques
  Future<void> loadStats(int livreurId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await _livraisonService.getStats(livreurId);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Accepter une livraison
  Future<bool> accepterLivraison(int livraisonId, int livreurId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final livraison = await _livraisonService.accepterLivraison(
        livraisonId,
        livreurId,
      );

      // Retirer des disponibles
      _livraisonsDisponibles.removeWhere((l) => l.livraison?.id == livraisonId);

      // Ajouter à mes livraisons
      _mesLivraisons.insert(0, livraison);

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erreur: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Démarrer une livraison
  Future<bool> demarrerLivraison(int livraisonId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final livraison = await _livraisonService.demarrerLivraison(livraisonId);

      final index = _mesLivraisons.indexWhere(
        (l) => l.livraison?.id == livraisonId,
      );
      if (index >= 0) {
        _mesLivraisons[index] = livraison;
      }

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erreur: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Terminer une livraison
  Future<bool> terminerLivraison(int livraisonId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final livraison = await _livraisonService.terminerLivraison(livraisonId);

      final index = _mesLivraisons.indexWhere(
        (l) => l.livraison?.id == livraisonId,
      );
      if (index >= 0) {
        _mesLivraisons[index] = livraison;
      }

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erreur: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour la position
  Future<bool> updatePosition(
    int livraisonId,
    double latitude,
    double longitude,
  ) async {
    try {
      await _livraisonService.updatePosition(livraisonId, latitude, longitude);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Erreur: $e';
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setSelectedLivraison(CommandeModel? livraison) {
    _selectedLivraison = livraison;
    notifyListeners();
  }
}
