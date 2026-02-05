import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/auth_wrapper.dart';
import 'features/shared/providers/auth_providers.dart';
import 'features/shared/providers/produit_provider.dart';
import 'features/shared/providers/commande_provider.dart';
import 'features/shared/providers/cart_provider.dart';
import 'features/shared/providers/livraison_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthProvider _authProvider;
  late final ProduitProvider _produitProvider;
  late final CommandeProvider _commandeProvider;
  late final CartProvider _cartProvider;
  late final LivraisonProvider _livraisonProvider;

  @override
  void initState() {
    super.initState();
    // Initialiser les providers
    _authProvider = AuthProvider();
    _produitProvider = ProduitProvider();
    _commandeProvider = CommandeProvider();
    _cartProvider = CartProvider();
    _livraisonProvider = LivraisonProvider();

    // Initialiser l'auth au démarrage (vérifier si déjà connecté)
    _authProvider.initializeAuth();
  }

  @override
  void dispose() {
    // Nettoyer les providers
    _authProvider.dispose();
    _produitProvider.dispose();
    _commandeProvider.dispose();
    _cartProvider.dispose();
    _livraisonProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),
        ChangeNotifierProvider<ProduitProvider>.value(value: _produitProvider),
        ChangeNotifierProvider<CommandeProvider>.value(
          value: _commandeProvider,
        ),
        ChangeNotifierProvider<CartProvider>.value(value: _cartProvider),
        ChangeNotifierProvider<LivraisonProvider>.value(
          value: _livraisonProvider,
        ),
      ],
      child: MaterialApp(
        title: 'EggDelivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
