class PanierItem {
  final int offreId;
  final String nom;
  final String vendeur;
  final double prixUnitaire;
  final String unite;
  final int quantite;
  final int stock;

  PanierItem({
    required this.offreId,
    required this.nom,
    required this.vendeur,
    required this.prixUnitaire,
    required this.unite,
    required this.quantite,
    required this.stock,
  });

  PanierItem copyWith({
    int? offreId,
    String? nom,
    String? vendeur,
    double? prixUnitaire,
    String? unite,
    int? quantite,
    int? stock,
  }) {
    return PanierItem(
      offreId: offreId ?? this.offreId,
      nom: nom ?? this.nom,
      vendeur: vendeur ?? this.vendeur,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      unite: unite ?? this.unite,
      quantite: quantite ?? this.quantite,
      stock: stock ?? this.stock,
    );
  }

  double get sousTotal => prixUnitaire * quantite;
}
