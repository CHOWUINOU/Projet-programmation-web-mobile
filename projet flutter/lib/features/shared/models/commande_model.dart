import 'produit_model.dart';

class LigneCommande {
  final int id;
  final int quantite;
  final double sousTotal;
  final double prixUnitaire;
  final ProduitModel? produit;
  final OffreModel? offre;

  LigneCommande({
    required this.id,
    required this.quantite,
    required this.sousTotal,
    required this.prixUnitaire,
    this.produit,
    this.offre,
  });

  factory LigneCommande.fromJson(Map<String, dynamic> json) {
    return LigneCommande(
      id: json['id'] ?? 0,
      quantite: json['quantite'] ?? 0,
      sousTotal: (json['sousTotal'] ?? 0).toDouble(),
      prixUnitaire: (json['prixCommande'] ?? 0).toDouble(),
      produit: json['offreProduit']?['produit'] != null
          ? ProduitModel.fromJson(json['offreProduit']['produit'])
          : null,
      offre: json['offreProduit'] != null
          ? OffreModel.fromJson(json['offreProduit'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'sousTotal': sousTotal,
      'prixCommande': prixUnitaire,
    };
  }
}

class LivraisonModel {
  final int id;
  final String statut;
  final DateTime? dateLivraison;
  final String? fraisLivraison;
  final double? latitude;
  final double? longitude;
  final String? livreurNom;

  LivraisonModel({
    required this.id,
    required this.statut,
    this.dateLivraison,
    this.fraisLivraison,
    this.latitude,
    this.longitude,
    this.livreurNom,
  });

  factory LivraisonModel.fromJson(Map<String, dynamic> json) {
    return LivraisonModel(
      id: json['id'] ?? 0,
      statut: json['statut'] ?? 'EN_ATTENTE',
      dateLivraison: json['dateLivraison'] != null
          ? DateTime.parse(json['dateLivraison'])
          : null,
      fraisLivraison: json['fraisLivraison'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      livreurNom: json['livreur']?['nom'],
    );
  }

  String get statutDisplay {
    switch (statut) {
      case 'EN_ATTENTE':
        return 'En attente';
      case 'ASSIGNEE':
        return 'Assignée';
      case 'EN_COURS':
        return 'En cours';
      case 'LIVREE':
        return 'Livrée';
      case 'ECHEC':
        return 'Échec';
      default:
        return statut;
    }
  }

  String get statutColor {
    switch (statut) {
      case 'EN_ATTENTE':
        return '#FFA726';
      case 'ASSIGNEE':
        return '#42A5F5';
      case 'EN_COURS':
        return '#7E57C2';
      case 'LIVREE':
        return '#66BB6A';
      case 'ECHEC':
        return '#EF5350';
      default:
        return '#757575';
    }
  }
}

class CommandeModel {
  final int id;
  final String reference;
  final DateTime dateCommande;
  final double montantTotal;
  final String statut;
  final String adresseLivraison;
  final List<LigneCommande> lignes;
  final LivraisonModel? livraison;
  final String? clientNom;

  CommandeModel({
    required this.id,
    required this.reference,
    required this.dateCommande,
    required this.montantTotal,
    required this.statut,
    required this.adresseLivraison,
    required this.lignes,
    this.livraison,
    this.clientNom,
  });

  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    return CommandeModel(
      id: json['id'] ?? 0,
      reference: json['reference'] ?? '',
      dateCommande: json['dateCommande'] != null
          ? DateTime.parse(json['dateCommande'])
          : DateTime.now(),
      montantTotal: (json['montantTotal'] ?? 0).toDouble(),
      statut: json['statut'] ?? 'EN_ATTENTE',
      adresseLivraison: json['adresseLivraison'] ?? '',
      lignes:
          (json['lignesCommande'] as List<dynamic>?)
              ?.map((l) => LigneCommande.fromJson(l))
              .toList() ??
          [],
      livraison: json['livraison'] != null
          ? LivraisonModel.fromJson(json['livraison'])
          : null,
      clientNom: json['client']?['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'dateCommande': dateCommande.toIso8601String(),
      'montantTotal': montantTotal,
      'statut': statut,
      'adresseLivraison': adresseLivraison,
      'lignesCommande': lignes.map((l) => l.toJson()).toList(),
    };
  }

  String get statutDisplay {
    switch (statut) {
      case 'EN_ATTENTE':
        return 'En attente';
      case 'CONFIRMEE':
        return 'Confirmée';
      case 'EN_PREPARATION':
        return 'En préparation';
      case 'PRETE':
        return 'Prête';
      case 'EN_LIVRAISON':
        return 'En livraison';
      case 'LIVREE':
        return 'Livrée';
      case 'ANNULEE':
        return 'Annulée';
      default:
        return statut;
    }
  }

  String get statutColor {
    switch (statut) {
      case 'EN_ATTENTE':
        return '#FFA726';
      case 'CONFIRMEE':
        return '#42A5F5';
      case 'EN_PREPARATION':
        return '#7E57C2';
      case 'PRETE':
        return '#26A69A';
      case 'EN_LIVRAISON':
        return '#29B6F6';
      case 'LIVREE':
        return '#66BB6A';
      case 'ANNULEE':
        return '#EF5350';
      default:
        return '#757575';
    }
  }

  bool get canBeCancelled => statut == 'EN_ATTENTE' || statut == 'CONFIRMEE';

  bool get isDelivered => statut == 'LIVREE';

  bool get isInProgress =>
      statut == 'EN_PREPARATION' ||
      statut == 'PRETE' ||
      statut == 'EN_LIVRAISON';

  int get totalItems {
    return lignes.fold(0, (sum, l) => sum + l.quantite);
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(dateCommande);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return 'Il y a ${diff.inMinutes} min';
      }
      return 'Il y a ${diff.inHours} h';
    } else if (diff.inDays == 1) {
      return 'Hier';
    }
    return '${diff.inDays} jours';
  }
}

// Request model
class CommandeRequest {
  final String adresseLivraison;
  final List<LigneCommandeRequest> lignesCommande;

  CommandeRequest({
    required this.adresseLivraison,
    required this.lignesCommande,
  });

  Map<String, dynamic> toJson() {
    return {
      'adresseLivraison': adresseLivraison,
      'lignesCommande': lignesCommande.map((l) => l.toJson()).toList(),
    };
  }
}

class LigneCommandeRequest {
  final int offreProduitId;
  final int quantite;

  LigneCommandeRequest({required this.offreProduitId, required this.quantite});

  Map<String, dynamic> toJson() {
    return {'offreProduitId': offreProduitId, 'quantite': quantite};
  }
}
