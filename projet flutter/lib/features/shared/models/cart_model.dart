import 'produit_model.dart';

class CartItem {
  final int offreId;
  final ProduitModel produit;
  final OffreModel offre;
  int quantite;

  CartItem({
    required this.offreId,
    required this.produit,
    required this.offre,
    this.quantite = 1,
  });

  double get sousTotal => offre.prixUnitaire * quantite;

  String get displaySousTotal => '${sousTotal.toStringAsFixed(0)} FCFA';

  Map<String, dynamic> toJson() {
    return {'offreProduitId': offreId, 'quantite': quantite};
  }

  CartItem copyWith({
    int? offreId,
    ProduitModel? produit,
    OffreModel? offre,
    int? quantite,
  }) {
    return CartItem(
      offreId: offreId ?? this.offreId,
      produit: produit ?? this.produit,
      offre: offre ?? this.offre,
      quantite: quantite ?? this.quantite,
    );
  }
}

class Cart {
  final List<CartItem> items;
  final double fraisLivraison;

  Cart({this.items = const [], this.fraisLivraison = 500.0});

  double get sousTotal {
    return items.fold(0, (sum, item) => sum + item.sousTotal);
  }

  double get total {
    return sousTotal + fraisLivraison;
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantite);
  }

  bool get isEmpty => items.isEmpty;

  String get displaySousTotal => '${sousTotal.toStringAsFixed(0)} FCFA';
  String get displayFraisLivraison =>
      '${fraisLivraison.toStringAsFixed(0)} FCFA';
  String get displayTotal => '${total.toStringAsFixed(0)} FCFA';

  Cart addItem(CartItem newItem) {
    final existingIndex = items.indexWhere(
      (item) => item.offreId == newItem.offreId,
    );

    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantite: updatedItems[existingIndex].quantite + newItem.quantite,
      );
      return Cart(items: updatedItems, fraisLivraison: fraisLivraison);
    }

    return Cart(items: [...items, newItem], fraisLivraison: fraisLivraison);
  }

  Cart updateQuantity(int offreId, int quantite) {
    if (quantite <= 0) {
      return removeItem(offreId);
    }

    final updatedItems = items.map((item) {
      if (item.offreId == offreId) {
        return item.copyWith(quantite: quantite);
      }
      return item;
    }).toList();

    return Cart(items: updatedItems, fraisLivraison: fraisLivraison);
  }

  Cart removeItem(int offreId) {
    return Cart(
      items: items.where((item) => item.offreId != offreId).toList(),
      fraisLivraison: fraisLivraison,
    );
  }

  Cart clear() {
    return Cart(items: const [], fraisLivraison: fraisLivraison);
  }

  List<Map<String, dynamic>> toCommandeRequest() {
    return items.map((item) => item.toJson()).toList();
  }
}
