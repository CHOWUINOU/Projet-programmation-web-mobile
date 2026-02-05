class AppConstants {
  static const String appName = "EggDelivery";
  static const String apiBaseUrl = "http://localhost:8080/api";

  // Routes
  static const String splash = '/';
  static const String home = '/home';
  static const String shopDetails = '/shop-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String auth = '/auth';
  static const String orders = '/orders';
  static const String vendorDashboard = '/vendor-dashboard';
  static const String deliveryList = '/delivery-list';

  // Asset paths
  static const String logo = 'assets/images/logo.png';
  static const String placeholderEgg = 'assets/images/egg_placeholder.png';
}

enum UserRole { client, vendor, delivery, admin }

enum OrderStatus { pending, confirmed, inProgress, delivered, cancelled }
