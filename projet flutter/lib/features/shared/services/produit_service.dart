import '../../../core/constants/api_constants.dart';
import '../models/produit_model.dart';
import 'api_client.dart';

class ProduitService {
  static final ProduitService _instance = ProduitService._internal();
  factory ProduitService() => _instance;
  ProduitService._internal();

  final ApiClient _apiClient = ApiClient();

  // Récupérer tous les produits (Client)
  Future<List<ProduitModel>> getAllProduits() async {
    try {
      final response = await _apiClient.get(ApiConstants.clientProduits);

      if (response is List) {
        return response.map((json) => ProduitModel.fromJson(json)).toList();
      }
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des produits: $e');
    }
  }

  // Récupérer un produit par ID
  Future<ProduitModel> getProduitById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.clientProduits}/$id',
      );
      return ProduitModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement du produit: $e');
    }
  }

  // Récupérer les produits du vendeur
  Future<List<ProduitModel>> getMesProduits() async {
    try {
      final response = await _apiClient.get(ApiConstants.vendeurProduits);

      if (response is List) {
        return response.map((json) => ProduitModel.fromJson(json)).toList();
      }
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des produits: $e');
    }
  }

  // Créer un produit (Vendeur)
  Future<ProduitModel> createProduit(ProduitRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.vendeurProduits,
        body: request.toJson(),
      );
      return ProduitModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la création du produit: $e');
    }
  }

  // Modifier un produit (Vendeur)
  Future<ProduitModel> updateProduit(int id, ProduitRequest request) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.vendeurProduits}/$id',
        body: request.toJson(),
      );
      return ProduitModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la modification du produit: $e');
    }
  }

  // Supprimer un produit (Vendeur)
  Future<void> deleteProduit(int id) async {
    try {
      await _apiClient.delete('${ApiConstants.vendeurProduits}/$id');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la suppression du produit: $e');
    }
  }

  // ========== OFFRES ==========

  // Récupérer toutes les offres
  Future<List<OffreModel>> getAllOffres() async {
    try {
      final response = await _apiClient.get(ApiConstants.vendeurOffres);

      if (response is List) {
        return response.map((json) => OffreModel.fromJson(json)).toList();
      }
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des offres: $e');
    }
  }

  // Récupérer les offres d'un produit
  Future<List<OffreModel>> getOffresByProduit(int produitId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.vendeurProduits}/$produitId/offres',
      );

      if (response is List) {
        return response.map((json) => OffreModel.fromJson(json)).toList();
      }
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors du chargement des offres: $e');
    }
  }

  // Créer une offre
  Future<OffreModel> createOffre(OffreProduitRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.vendeurOffres,
        body: request.toJson(),
      );
      return OffreModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la création de l\'offre: $e');
    }
  }

  // Modifier une offre
  Future<OffreModel> updateOffre(int id, OffreProduitRequest request) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.vendeurOffres}/$id',
        body: request.toJson(),
      );
      return OffreModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la modification de l\'offre: $e');
    }
  }

  // Supprimer une offre
  Future<void> deleteOffre(int id) async {
    try {
      await _apiClient.delete('${ApiConstants.vendeurOffres}/$id');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la suppression de l\'offre: $e');
    }
  }

  // Mettre à jour le stock d'une offre
  Future<OffreModel> updateStock(int id, int nouveauStock) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.vendeurOffres}/$id/stock?nouveauStock=$nouveauStock',
      );
      return OffreModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erreur lors de la mise à jour du stock: $e');
    }
  }
}
