// lib/features/client/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/auth_bottom_sheet.dart';
import 'package:frontend/core/widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/routes/app_router.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/produit_provider.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/produit_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCalibre = 'Tous';
  String selectedZone = 'Toutes zones';
  final List<String> calibres = ['Tous', 'M', 'L', 'XL', 'XXL'];
  final List<String> zones = [
    'Toutes zones',
    'Douala',
    'Yaounde',
    'Banapriso',
    'Akwa',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProduitProvider>().loadProduits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final produitProvider = context.watch<ProduitProvider>();
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();

    // Filtrer les produits
    final produits = produitProvider.produits.where((p) {
      if (selectedCalibre != 'Tous' && p.typeOeuf != selectedCalibre) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header moderne avec dégradé
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFFFF8F00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authProvider.isAuthenticated
                                    ? 'Bonjour ${authProvider.user?.nom ?? ''} ! 👋'
                                    : 'EggDelivery 🥚',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                authProvider.isAuthenticated
                                    ? 'Ravi de vous revoir'
                                    : 'Commandez vos œufs frais',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icône utilisateur dynamique
                        _buildUserAvatar(authProvider),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Barre de recherche
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un vendeur...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filtres horizontaux
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtre Calibres
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: calibres.length,
                      itemBuilder: (context, index) {
                        final isSelected = calibres[index] == selectedCalibre;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(calibres[index]),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCalibre = calibres[index];
                              });
                            },
                            selectedColor: AppTheme.primaryColor,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Filtre Zones
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: zones.length,
                      itemBuilder: (context, index) {
                        final isSelected = zones[index] == selectedZone;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(zones[index]),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedZone = zones[index];
                              });
                            },
                            selectedColor: AppTheme.accentColor.withOpacity(
                              0.2,
                            ),
                            checkmarkColor: AppTheme.accentColor,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppTheme.accentColor
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Titre section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vendeurs disponibles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading ou Error
            if (produitProvider.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (produitProvider.error != null)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          produitProvider.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => produitProvider.loadProduits(),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (produits.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.storefront,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun vendeur disponible',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Grille de produits
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final produit = produits[index];
                    final offre = produit.offres.isNotEmpty
                        ? produit.offres.first
                        : null;
                    return ProductCard(
                      vendorName: produit.vendeur?.displayName ?? produit.nom,
                      calibre: produit.typeOeuf ?? 'M',
                      price: offre?.prixUnitaire.toInt() ?? 0,
                      unit: offre?.uniteDeVente ?? 'plateau',
                      stock: produit.totalStock,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.shopDetails,
                        arguments: {'vendorId': produit.id},
                      ),
                      onAddToCart: () {
                        if (offre != null) {
                          cartProvider.addToCart(produit, offre);
                          _showAddedToCartSnackBar(context);
                        }
                      },
                    );
                  }, childCount: produits.length),
                ),
              ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),

      // Floating Cart Button
      floatingActionButton: cartProvider.itemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              backgroundColor: AppTheme.primaryColor,
              icon: const Icon(Icons.shopping_basket),
              label: Text('Panier (${cartProvider.itemCount})'),
            )
          : null,
    );
  }

  // Widget pour l'avatar utilisateur dynamique
  Widget _buildUserAvatar(AuthProvider authProvider) {
    if (authProvider.isAuthenticated && authProvider.user != null) {
      // Utilisateur connecté : afficher l'initiale
      final String initial = authProvider.user!.nom.isNotEmpty
          ? authProvider.user!.nom[0].toUpperCase()
          : '?';

      return PopupMenuButton<String>(
        offset: const Offset(0, 40),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                const Icon(Icons.person, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(authProvider.user!.nom),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'orders',
            child: Row(
              children: [
                Icon(Icons.receipt_long),
                SizedBox(width: 8),
                Text('Mes commandes'),
              ],
            ),
          ),
          // Option spécifique selon le rôle
          if (authProvider.userRole == UserRole.vendor)
            const PopupMenuItem(
              value: 'dashboard',
              child: Row(
                children: [
                  Icon(Icons.dashboard),
                  SizedBox(width: 8),
                  Text('Tableau de bord vendeur'),
                ],
              ),
            ),
          if (authProvider.userRole == UserRole.delivery)
            const PopupMenuItem(
              value: 'deliveries',
              child: Row(
                children: [
                  Icon(Icons.delivery_dining),
                  SizedBox(width: 8),
                  Text('Mes livraisons'),
                ],
              ),
            ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                const Icon(Icons.logout, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'orders':
              Navigator.pushNamed(context, AppRoutes.orders);
              break;
            case 'dashboard':
              Navigator.pushNamed(context, AppRoutes.vendorDashboard);
              break;
            case 'deliveries':
              Navigator.pushNamed(context, AppRoutes.deliveryList);
              break;
            case 'logout':
              _showLogoutConfirmation(context, authProvider);
              break;
          }
        },
      );
    } else {
      // Utilisateur non connecté : afficher icône générique avec option connexion
      return PopupMenuButton<String>(
        offset: const Offset(0, 40),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person_outline, color: Colors.white),
        ),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'login',
            child: Row(
              children: [
                Icon(Icons.login, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text('Se connecter'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'become_vendor',
            child: Row(
              children: [
                Icon(Icons.store, color: AppTheme.accentColor),
                SizedBox(width: 8),
                Text('Devenir vendeur'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'help',
            child: Row(
              children: [
                Icon(Icons.help_outline),
                SizedBox(width: 8),
                Text('Aide'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'login') {
            AuthBottomSheet.show(context);
          } else if (value == 'become_vendor') {
            AuthBottomSheet.show(context);
          }
        },
      );
    }
  }

  void _showLogoutConfirmation(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              authProvider.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Déconnecté avec succès'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  void _showAddedToCartSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ajouté au panier !'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'VOIR',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        ),
      ),
    );
  }
}
