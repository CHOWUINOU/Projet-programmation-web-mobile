import '../../../core/constants/api_constants.dart';
import '../models/livraison_model.dart';
import '../models/commande_model.dart';
import 'api_client.dart';

class LivraisonService {
  static final LivraisonService _instance = LivraisonService._internal();
  factory LivraisonService() => _instance;
  LivraisonService._internal();

  final ApiClient _apiClient = ApiClient();

  // Récupérer les livraisons disponibles
  Future<List<CommandeModel>> getLivraisonsDisponibles() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.livreurLivraisonsDisponibles,
      );

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

  // Récupérer mes livraisons (Livreur)
  Future<List<CommandeModel>> getMesLivraisons(int livreurId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.livreurLivraisons}?livreurId=$livreurId',
      );

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

  // Récupérer une livraison par ID
  Future<CommandeModel> getLivraisonById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.livreurLivraisons}/$id',
      );
      return CommandeModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement de la livraison: $e');
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
      throw ApiException('Erreur lors de l\'acceptation: $e');
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
      throw ApiException('Erreur lors du démarrage: $e');
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
      throw ApiException('Erreur lors de la finalisation: $e');
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

  // Récupérer les statistiques du livreur
  Future<LivreurStats> getStats(int livreurId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.baseUrl}/api/livreur/stats?livreurId=$livreurId',
      );
      return LivreurStats.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des statistiques: $e');
    }
  }
}
