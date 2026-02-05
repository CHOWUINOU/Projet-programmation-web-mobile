import 'package:flutter/material.dart';
import '../models/commande_model.dart';
import '../models/cart_model.dart';
import '../services/commande_service.dart';
import '../services/api_client.dart';

class CommandeProvider extends ChangeNotifier {
  final CommandeService _commandeService = CommandeService();

  List<CommandeModel> _commandes = [];
  CommandeModel? _selectedCommande;
  bool _isLoading = false;
  String? _error;

  List<CommandeModel> get commandes => _commandes;
  CommandeModel? get selectedCommande => _selectedCommande;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Commandes en cours
  List<CommandeModel> get commandesEnCours => _commandes
      .where(
        (c) =>
            c.statut == 'EN_ATTENTE' ||
            c.statut == 'CONFIRMEE' ||
            c.statut == 'EN_PREPARATION' ||
            c.statut == 'PRETE' ||
            c.statut == 'EN_LIVRAISON',
      )
      .toList();

  // Commandes livrées
  List<CommandeModel> get commandesLivrees =>
      _commandes.where((c) => c.statut == 'LIVREE').toList();

  // ========== CLIENT ==========

  // Charger mes commandes
  Future<void> loadMesCommandes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _commandes = await _commandeService.getMesCommandes();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer une commande
  Future<CommandeModel?> createCommande({
    required String adresseLivraison,
    required Cart cart,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final commande = await _commandeService.createCommande(
        adresseLivraison: adresseLivraison,
        lignesCommande: cart.toCommandeRequest(),
      );
      _commandes.insert(0, commande);
      notifyListeners();
      return commande;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      _error = 'Erreur: $e';
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Annuler une commande
  Future<bool> cancelCommande(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _commandeService.cancelCommande(id);
      final index = _commandes.indexWhere((c) => c.id == id);
      if (index >= 0) {
        _commandes[index] = _commandes[index].copyWith(statut: 'ANNULEE');
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

  // ========== VENDEUR ==========

  // Charger les commandes reçues
  Future<void> loadCommandesRecues() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _commandes = await _commandeService.getCommandesRecues();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour le statut d'une commande
  Future<bool> updateStatutCommande(int id, String statut) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCommande = await _commandeService.updateStatutCommande(
        id,
        statut,
      );
      final index = _commandes.indexWhere((c) => c.id == id);
      if (index >= 0) {
        _commandes[index] = updatedCommande;
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

  // Accepter une commande (passer à CONFIRMEE)
  Future<bool> accepterCommande(int id) async {
    return updateStatutCommande(id, 'CONFIRMEE');
  }

  // Marquer comme prête (passer à PRETE)
  Future<bool> marquerPrete(int id) async {
    return updateStatutCommande(id, 'PRETE');
  }

  // ========== LIVREUR ==========

  // Charger les livraisons assignées
  Future<void> loadLivraisonsAssignees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _commandes = await _commandeService.getLivraisonsAssignees();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Erreur: $e';
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
      final updatedCommande = await _commandeService.demarrerLivraison(
        livraisonId,
      );
      final index = _commandes.indexWhere(
        (c) => c.livraison?.id == livraisonId,
      );
      if (index >= 0) {
        _commandes[index] = updatedCommande;
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
      final updatedCommande = await _commandeService.terminerLivraison(
        livraisonId,
      );
      final index = _commandes.indexWhere(
        (c) => c.livraison?.id == livraisonId,
      );
      if (index >= 0) {
        _commandes[index] = updatedCommande;
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

  void setSelectedCommande(CommandeModel? commande) {
    _selectedCommande = commande;
    notifyListeners();
  }
}

// Extension pour copyWith
extension CommandeModelExtension on CommandeModel {
  CommandeModel copyWith({
    int? id,
    String? reference,
    DateTime? dateCommande,
    double? montantTotal,
    String? statut,
    String? adresseLivraison,
    List<LigneCommande>? lignes,
    LivraisonModel? livraison,
    String? clientNom,
  }) {
    return CommandeModel(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      dateCommande: dateCommande ?? this.dateCommande,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut ?? this.statut,
      adresseLivraison: adresseLivraison ?? this.adresseLivraison,
      lignes: lignes ?? this.lignes,
      livraison: livraison ?? this.livraison,
      clientNom: clientNom ?? this.clientNom,
    );
  }
}
