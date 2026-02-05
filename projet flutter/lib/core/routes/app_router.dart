import 'package:flutter/material.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/auth/screens/splash_screens.dart';
import '../../features/client/screens/home_screen.dart';
import '../../features/client/screens/shop_detail_screen.dart';
import '../../features/client/screens/cart_screen.dart';
import '../../features/client/screens/checkout_screen.dart';
import '../../features/client/screens/orders_screen.dart';
import '../../features/vendor/screens/vendor_dashboard.dart';
import '../../features/vendor/screens/shop_form.dart';
import '../../features/vendor/screens/product_form.dart';
import '../../features/vendor/screens/offer_form.dart';
import '../../features/vendor/screens/vendor_orders.dart';
import '../../features/delivery/screens/delivery_list.dart';
import '../../features/delivery/screens/delivery_details.dart';
import '../../features/shared/models/user_model.dart';

class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String auth = '/auth';

  // Client
  static const String home = '/home';
  static const String shopDetails = '/shop-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';

  // Vendor
  static const String vendorDashboard = '/vendor-dashboard';
  static const String shopForm = '/shop-form';
  static const String productForm = '/product-form';
  static const String offerForm = '/offer-form';
  static const String vendorOrders = '/vendor-orders';

  // Delivery
  static const String deliveryList = '/delivery-list';
  static const String deliveryDetails = '/delivery-details';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth routes
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());

      // Client routes
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.shopDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ShopDetailsScreen(vendorId: args?['vendorId'] ?? 0),
        );
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case AppRoutes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());

      // Vendor routes
      case AppRoutes.vendorDashboard:
        return MaterialPageRoute(builder: (_) => const VendorDashboard());
      case AppRoutes.shopForm:
        return MaterialPageRoute(builder: (_) => const ShopForm());
      case AppRoutes.productForm:
        return MaterialPageRoute(builder: (_) => const ProductForm());
      case AppRoutes.offerForm:
        return MaterialPageRoute(builder: (_) => const OfferForm());
      case AppRoutes.vendorOrders:
        return MaterialPageRoute(builder: (_) => const VendorOrders());

      // Delivery routes
      case AppRoutes.deliveryList:
        return MaterialPageRoute(builder: (_) => const DeliveryList());
      case AppRoutes.deliveryDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DeliveryDetails(delivery: args ?? {}),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route non trouvée: ${settings.name}')),
          ),
        );
    }
  }

  // Navigation helper basé sur le rôle
  static String getHomeRoute(UserRole? role) {
    switch (role) {
      case UserRole.vendor:
        return AppRoutes.vendorDashboard;
      case UserRole.delivery:
        return AppRoutes.deliveryList;
      case UserRole.client:
      default:
        return AppRoutes.home;
    }
  }
}
