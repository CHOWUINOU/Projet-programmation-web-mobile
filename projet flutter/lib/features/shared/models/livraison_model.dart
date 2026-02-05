class LivraisonDetailModel {
  final int id;
  final String reference;
  final String statut;
  final String vendorName;
  final String clientName;
  final String clientPhone;
  final String address;
  final String distance;
  final double price;
  final int items;
  final String? urgency;
  final DateTime? dateCreation;
  final DateTime? dateLivraison;
  final double? latitude;
  final double? longitude;

  LivraisonDetailModel({
    required this.id,
    required this.reference,
    required this.statut,
    required this.vendorName,
    required this.clientName,
    required this.clientPhone,
    required this.address,
    required this.distance,
    required this.price,
    required this.items,
    this.urgency,
    this.dateCreation,
    this.dateLivraison,
    this.latitude,
    this.longitude,
  });

  factory LivraisonDetailModel.fromJson(Map<String, dynamic> json) {
    return LivraisonDetailModel(
      id: json['id'] ?? 0,
      reference: json['reference'] ?? '',
      statut: json['statut'] ?? 'EN_ATTENTE',
      vendorName:
          json['vendorName'] ?? json['commande']?['client']?['nom'] ?? '',
      clientName:
          json['clientName'] ?? json['commande']?['client']?['nom'] ?? '',
      clientPhone:
          json['clientPhone'] ??
          json['commande']?['client']?['telephone'] ??
          '',
      address: json['address'] ?? json['commande']?['adresseLivraison'] ?? '',
      distance: json['distance'] ?? '0 km',
      price: (json['price'] ?? json['fraisLivraison'] ?? 0).toDouble(),
      items: json['items'] ?? 0,
      urgency: json['urgency'],
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'])
          : null,
      dateLivraison: json['dateLivraison'] != null
          ? DateTime.parse(json['dateLivraison'])
          : null,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  String get statutDisplay {
    switch (statut) {
      case 'EN_ATTENTE':
        return 'Disponible';
      case 'ASSIGNEE':
        return 'Acceptée';
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
        return '#4CAF50';
      case 'ASSIGNEE':
        return '#2196F3';
      case 'EN_COURS':
        return '#FF9800';
      case 'LIVREE':
        return '#4CAF50';
      case 'ECHEC':
        return '#F44336';
      default:
        return '#757575';
    }
  }

  bool get isAvailable => statut == 'EN_ATTENTE';
  bool get isAssigned => statut == 'ASSIGNEE';
  bool get isInProgress => statut == 'EN_COURS';
  bool get isCompleted => statut == 'LIVREE';
}

class LivreurStats {
  final double totalGains;
  final int totalDeliveries;
  final int currentDeliveries;
  final double rating;

  LivreurStats({
    required this.totalGains,
    required this.totalDeliveries,
    required this.currentDeliveries,
    required this.rating,
  });

  factory LivreurStats.fromJson(Map<String, dynamic> json) {
    return LivreurStats(
      totalGains: (json['totalGains'] ?? 0).toDouble(),
      totalDeliveries: json['totalDeliveries'] ?? 0,
      currentDeliveries: json['currentDeliveries'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  String get formattedGains => '${totalGains.toStringAsFixed(0)} FCFA';
}
