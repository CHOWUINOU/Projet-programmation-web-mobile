// lib/core/widgets/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/screens/splash_screens.dart';
import '../../features/client/screens/home_screen.dart';
import '../../features/vendor/screens/vendor_dashboard.dart';
import '../../features/delivery/screens/delivery_list.dart';
import '../../features/shared/providers/auth_providers.dart';
import '../../features/shared/models/user_model.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Afficher un écran de chargement pendant l'initialisation
        if (authProvider.isInitializing) {
          return const SplashScreen();
        }

        // Si l'utilisateur est authentifié, rediriger selon le rôle
        if (authProvider.isAuthenticated) {
          final userRole = authProvider.userRole;

          switch (userRole) {
            case UserRole.vendor:
              return const VendorDashboard();
            case UserRole.delivery:
              return const DeliveryList();
            case UserRole.client:
            case UserRole.admin:
            default:
              return const HomeScreen();
          }
        }

        // PAR DÉFAUT : Toujours afficher le HomeScreen (parcours libre)
        // L'authentification sera demandée uniquement au moment du paiement
        return const HomeScreen();
      },
    );
  }
}
