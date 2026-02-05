class ApiConstants {
  // Base URL - Changez cette URL selon votre environnement
  //static const String baseUrl =
  //   'http://10.0.2.2:8080'; // Pour émulateur Android
  static const String baseUrl = 'http://localhost:8080'; // Pour iOS simulateur
  // static const String baseUrl = 'http://192.168.1.x:8080'; // Pour appareil physique

  // API Version
  static const String apiVersion = '/api';

  // Auth endpoints
  static const String login = '$baseUrl$apiVersion/auth/login';
  static const String register = '$baseUrl$apiVersion/auth/register';
  static const String logout = '$baseUrl$apiVersion/auth/logout';

  // Client endpoints
  static const String clientProduits = '$baseUrl$apiVersion/client/produits';
  static const String clientCommandes = '$baseUrl$apiVersion/client/commandes';
  static const String clientCreateCommande =
      '$baseUrl$apiVersion/client/commandes';

  // Vendeur endpoints
  static const String vendeurProduits = '$baseUrl$apiVersion/vendeur/produits';
  static const String vendeurOffres = '$baseUrl$apiVersion/vendeur/offres';
  static const String boutiqueMaj = '$baseUrl$apiVersion/vendeur/boutique';
  static const String vendeurCommandes =
      '$baseUrl$apiVersion/vendeur/commandes';

  // Livreur endpoints
  static const String livreurLivraisons =
      '$baseUrl$apiVersion/livreur/livraisons';
  static const String livreurLivraisonsDisponibles =
      '$baseUrl$apiVersion/livreur/livraisons/disponibles';

  // Admin endpoints
  static const String adminUtilisateurs =
      '$baseUrl$apiVersion/admin/utilisateurs';
  static const String adminCommandes = '$baseUrl$apiVersion/admin/commandes';
  static const String adminLivraisons = '$baseUrl$apiVersion/admin/livraisons';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 secondes
  static const int receiveTimeout = 30000; // 30 secondes
}
