import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/produit_model.dart';

class CartProvider extends ChangeNotifier {
  Cart _cart = Cart();

  Cart get cart => _cart;

  // Getters
  List<CartItem> get items => _cart.items;
  double get sousTotal => _cart.sousTotal;
  double get total => _cart.total;
  double get fraisLivraison => _cart.fraisLivraison;
  int get itemCount => _cart.itemCount;
  bool get isEmpty => _cart.isEmpty;
  String get displayTotal => _cart.displayTotal;
  String get displaySousTotal => _cart.displaySousTotal;
  String get displayFraisLivraison => _cart.displayFraisLivraison;

  // Ajouter un article au panier
  void addToCart(ProduitModel produit, OffreModel offre, {int quantite = 1}) {
    final newItem = CartItem(
      offreId: offre.id,
      produit: produit,
      offre: offre,
      quantite: quantite,
    );
    _cart = _cart.addItem(newItem);
    notifyListeners();
  }

  // Mettre à jour la quantité
  void updateQuantity(int offreId, int quantite) {
    _cart = _cart.updateQuantity(offreId, quantite);
    notifyListeners();
  }

  // Augmenter la quantité
  void incrementQuantity(int offreId) {
    final item = _cart.items.firstWhere((i) => i.offreId == offreId);
    updateQuantity(offreId, item.quantite + 1);
  }

  // Diminuer la quantité
  void decrementQuantity(int offreId) {
    final item = _cart.items.firstWhere((i) => i.offreId == offreId);
    if (item.quantite > 1) {
      updateQuantity(offreId, item.quantite - 1);
    } else {
      removeFromCart(offreId);
    }
  }

  // Retirer un article
  void removeFromCart(int offreId) {
    _cart = _cart.removeItem(offreId);
    notifyListeners();
  }

  // Vider le panier
  void clearCart() {
    _cart = _cart.clear();
    notifyListeners();
  }

  // Vérifier si un produit est dans le panier
  bool isInCart(int offreId) {
    return _cart.items.any((item) => item.offreId == offreId);
  }

  // Obtenir la quantité d'un article
  int getQuantity(int offreId) {
    final item = _cart.items.firstWhere(
      (i) => i.offreId == offreId,
      orElse: () => CartItem(
        offreId: offreId,
        produit: ProduitModel(id: 0, nom: '', disponibilite: '', offres: []),
        offre: OffreModel(id: 0, prixUnitaire: 0, stock: 0, disponibilite: ''),
        quantite: 0,
      ),
    );
    return item.quantite;
  }

  // Mettre à jour les frais de livraison
  void updateFraisLivraison(double frais) {
    _cart = Cart(items: _cart.items, fraisLivraison: frais);
    notifyListeners();
  }
}
