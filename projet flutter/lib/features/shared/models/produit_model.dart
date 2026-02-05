class VendeurModel {
  final int id;
  final String nom;
  final String? nomBoutique;
  final String? description;
  final String email;
  final String telephone;
  final String? adresse;

  VendeurModel({
    required this.id,
    required this.nom,
    this.nomBoutique,
    this.description,
    required this.email,
    required this.telephone,
    this.adresse,
  });

  factory VendeurModel.fromJson(Map<String, dynamic> json) {
    return VendeurModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      nomBoutique: json['nomBoutique'],
      description: json['description'],
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      adresse: json['adresse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'nomBoutique': nomBoutique,
      'description': description,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
    };
  }

  String get displayName => nomBoutique ?? nom;
}

class OffreModel {
  final int id;
  final double prixUnitaire;
  final int stock;
  final String? uniteDeVente;
  final String disponibilite;
  final int? produitId;

  OffreModel({
    required this.id,
    required this.prixUnitaire,
    required this.stock,
    this.uniteDeVente,
    required this.disponibilite,
    this.produitId,
  });

  factory OffreModel.fromJson(Map<String, dynamic> json) {
    return OffreModel(
      id: json['id'] ?? 0,
      prixUnitaire: (json['prixUnitaire'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      uniteDeVente: json['uniteDeVente'],
      disponibilite: json['disponibilite'] ?? 'DISPONIBLE',
      produitId: json['produit']?['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prixUnitaire': prixUnitaire,
      'stock': stock,
      'uniteDeVente': uniteDeVente,
      'disponibilite': disponibilite,
    };
  }

  bool get isDisponible => disponibilite == 'DISPONIBLE' && stock > 0;

  String get displayPrice => '${prixUnitaire.toStringAsFixed(0)} FCFA';
}

class ProduitModel {
  final int id;
  final String nom;
  final String? description;
  final String? typeOeuf;
  final String disponibilite;
  final VendeurModel? vendeur;
  final List<OffreModel> offres;
  final DateTime? dateCreation;

  ProduitModel({
    required this.id,
    required this.nom,
    this.description,
    this.typeOeuf,
    required this.disponibilite,
    this.vendeur,
    required this.offres,
    this.dateCreation,
  });

  factory ProduitModel.fromJson(Map<String, dynamic> json) {
    return ProduitModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'],
      typeOeuf: json['typeOeuf'],
      disponibilite: json['disponibilite'] ?? 'DISPONIBLE',
      vendeur: json['vendeur'] != null
          ? VendeurModel.fromJson(json['vendeur'])
          : null,
      offres:
          (json['offres'] as List<dynamic>?)
              ?.map((o) => OffreModel.fromJson(o))
              .toList() ??
          [],
      dateCreation: json['datecreation'] != null
          ? DateTime.parse(json['datecreation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'typeOeuf': typeOeuf,
      'disponibilite': disponibilite,
      'vendeur': vendeur?.toJson(),
      'offres': offres.map((o) => o.toJson()).toList(),
    };
  }

  bool get isDisponible => disponibilite == 'DISPONIBLE';

  double? get minPrice {
    if (offres.isEmpty) return null;
    return offres.map((o) => o.prixUnitaire).reduce((a, b) => a < b ? a : b);
  }

  double? get maxPrice {
    if (offres.isEmpty) return null;
    return offres.map((o) => o.prixUnitaire).reduce((a, b) => a > b ? a : b);
  }

  String get displayPrice {
    if (offres.isEmpty) return 'Prix non disponible';
    if (minPrice == maxPrice) {
      return '${minPrice?.toStringAsFixed(0)} FCFA';
    }
    return 'À partir de ${minPrice?.toStringAsFixed(0)} FCFA';
  }

  int get totalStock {
    return offres.fold(0, (sum, o) => sum + o.stock);
  }
}

// Request models
class ProduitRequest {
  final String nom;
  final String? description;
  final String? typeOeuf;

  ProduitRequest({required this.nom, this.description, this.typeOeuf});

  Map<String, dynamic> toJson() {
    return {'nom': nom, 'description': description, 'typeOeuf': typeOeuf};
  }
}

class OffreProduitRequest {
  final int produitId;
  final double prixUnitaire;
  final int stock;
  final String? uniteDeVente;

  OffreProduitRequest({
    required this.produitId,
    required this.prixUnitaire,
    required this.stock,
    this.uniteDeVente,
  });

  Map<String, dynamic> toJson() {
    return {
      'produitId': produitId,
      'prixUnitaire': prixUnitaire,
      'stock': stock,
      'uniteDeVente': uniteDeVente,
    };
  }
}
