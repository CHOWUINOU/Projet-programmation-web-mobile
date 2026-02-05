import 'package:flutter/material.dart';
import '../models/produit_model.dart';
import '../services/produit_service.dart';
import '../services/api_client.dart';

class ProduitProvider extends ChangeNotifier {
  final ProduitService _produitService = ProduitService();

  List<ProduitModel> _produits = [];
  List<OffreModel> _offres = [];
  ProduitModel? _selectedProduit;
  bool _isLoading = false;
  String? _error;

  List<ProduitModel> get produits => _produits;
  List<OffreModel> get offres => _offres;
  ProduitModel? get selectedProduit => _selectedProduit;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Charger tous les produits
  Future<void> loadProduits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _produits = await _produitService.getAllProduits();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger les produits du vendeur
  Future<void> loadMesProduits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _produits = await _produitService.getMesProduits();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger un produit par ID
  Future<void> loadProduitById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProduit = await _produitService.getProduitById(id);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer un produit
  Future<bool> createProduit(ProduitRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final produit = await _produitService.createProduit(request);
      _produits.add(produit);
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

  // Modifier un produit
  Future<bool> updateProduit(int id, ProduitRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProduit = await _produitService.updateProduit(id, request);
      final index = _produits.indexWhere((p) => p.id == id);
      if (index >= 0) {
        _produits[index] = updatedProduit;
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

  // Supprimer un produit
  Future<bool> deleteProduit(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _produitService.deleteProduit(id);
      _produits.removeWhere((p) => p.id == id);
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

  // ========== OFFRES ==========

  // Charger les offres d'un produit
  Future<void> loadOffresByProduit(int produitId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _offres = await _produitService.getOffresByProduit(produitId);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer une offre
  Future<bool> createOffre(OffreProduitRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final offre = await _produitService.createOffre(request);
      _offres.add(offre);
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

  // Modifier une offre
  Future<bool> updateOffre(int id, OffreProduitRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedOffre = await _produitService.updateOffre(id, request);
      final index = _offres.indexWhere((o) => o.id == id);
      if (index >= 0) {
        _offres[index] = updatedOffre;
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

  // Supprimer une offre
  Future<bool> deleteOffre(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _produitService.deleteOffre(id);
      _offres.removeWhere((o) => o.id == id);
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

  // Mettre à jour le stock
  Future<bool> updateStock(int id, int nouveauStock) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedOffre = await _produitService.updateStock(id, nouveauStock);
      final index = _offres.indexWhere((o) => o.id == id);
      if (index >= 0) {
        _offres[index] = updatedOffre;
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedProduit() {
    _selectedProduit = null;
    notifyListeners();
  }
}
