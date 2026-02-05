// offre_model.dart
import 'package:frontend/features/shared/models/produit_model.dart';

class OffreModel {
  final int id;
  final double prixUnitaire;
  final int stock;
  final String? uniteDeVente;
  final String disponibilite;
  final ProduitModel? produit;

  OffreModel({
    required this.id,
    required this.prixUnitaire,
    required this.stock,
    this.uniteDeVente,
    required this.disponibilite,
    this.produit,
  });

  factory OffreModel.fromJson(Map<String, dynamic> json) {
    return OffreModel(
      id: json['id'] ?? 0,
      prixUnitaire: (json['prixUnitaire'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      uniteDeVente: json['uniteDeVente'],
      disponibilite: json['disponibilite'] ?? 'DISPONIBLE',
      produit: json['produit'] != null
          ? ProduitModel.fromJson(json['produit'])
          : null,
    );
  }

  bool get isDisponible => disponibilite == 'DISPONIBLE' && stock > 0;
}
