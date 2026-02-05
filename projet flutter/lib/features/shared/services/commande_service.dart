import '../../../core/constants/api_constants.dart';
import '../models/commande_model.dart';
import 'api_client.dart';

class CommandeService {
  static final CommandeService _instance = CommandeService._internal();
  factory CommandeService() => _instance;
  CommandeService._internal();

  final ApiClient _apiClient = ApiClient();

  // ========== CLIENT ==========

  // Récupérer mes commandes (Client)
  Future<List<CommandeModel>> getMesCommandes() async {
    try {
      final response = await _apiClient.get(ApiConstants.clientCommandes);

      if (response is List) {
        return response.map((json) => CommandeModel.fromJson(json)).toList();
      }
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des commandes: $e');
    }
  }

  // Créer une commande (Client)
  Future<CommandeModel> createCommande({
    required String adresseLivraison,
    required List<Map<String, dynamic>> lignesCommande,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.clientCreateCommande,
        body: {
          'adresseLivraison': adresseLivraison,
          'lignesCommande': lignesCommande,
        },
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la création de la commande: $e');
    }
  }

  // Récupérer une commande par ID
  Future<CommandeModel> getCommandeById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.clientCommandes}/$id',
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement de la commande: $e');
    }
  }

  // Annuler une commande (Client)
  Future<void> cancelCommande(int id) async {
    try {
      await _apiClient.put('${ApiConstants.clientCommandes}/$id/annuler');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de l\'annulation de la commande: $e');
    }
  }

  // ========== VENDEUR ==========

  // Récupérer les commandes reçues (Vendeur)
  Future<List<CommandeModel>> getCommandesRecues() async {
    try {
      final response = await _apiClient.get(ApiConstants.vendeurCommandes);

      if (response is List) {
        return response.map((json) => CommandeModel.fromJson(json)).toList();
      }
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des commandes: $e');
    }
  }

  // Mettre à jour le statut d'une commande (Vendeur)
  Future<CommandeModel> updateStatutCommande(int id, String statut) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.vendeurCommandes}/$id/statut?statut=$statut',
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la mise à jour du statut: $e');
    }
  }

  // ========== LIVREUR ==========

  // Récupérer les livraisons assignées (Livreur)
  Future<List<CommandeModel>> getLivraisonsAssignees() async {
    try {
      final response = await _apiClient.get(ApiConstants.livreurLivraisons);

      if (response is List) {
        return response.map((json) => CommandeModel.fromJson(json)).toList();
      }
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des livraisons: $e');
    }
  }

  // Accepter une livraison
  Future<CommandeModel> accepterLivraison(
    int livraisonId,
    int livreurId,
  ) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.livreurLivraisons}/$livraisonId/accepter?livreurId=$livreurId',
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de l\'acceptation de la livraison: $e');
    }
  }

  // Démarrer une livraison
  Future<CommandeModel> demarrerLivraison(int livraisonId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.livreurLivraisons}/$livraisonId/demarrer',
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du démarrage de la livraison: $e');
    }
  }

  // Terminer une livraison
  Future<CommandeModel> terminerLivraison(int livraisonId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.livreurLivraisons}/$livraisonId/terminer',
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la fin de la livraison: $e');
    }
  }

  // Mettre à jour la position
  Future<CommandeModel> updatePosition(
    int livraisonId,
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.livreurLivraisons}/$livraisonId/position?latitude=$latitude&longitude=$longitude',
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la mise à jour de la position: $e');
    }
  }
}
