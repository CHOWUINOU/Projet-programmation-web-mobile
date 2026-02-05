// lib/features/client/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/auth_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/routes/app_router.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/providers/commande_provider.dart';
import '../../shared/providers/auth_providers.dart'; // AJOUT

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'orange';
  final _addressController = TextEditingController(text: 'Douala, Logpom');
  final _phoneController = TextEditingController(text: '679 89 87 65');
  bool _isProcessing = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'orange',
      'name': 'Orange Money',
      'icon': 'OM',
      'color': Color(0xFFFF6600),
    },
    {
      'id': 'mtn',
      'name': 'Mobile Money',
      'icon': 'MOMO',
      'color': Color(0xFFFFC107),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Vérifier auth au chargement - rediriger vers auth si nécessaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  void _checkAuth() {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      // Si pas authentifié, montrer le sheet (ne devrait pas arriver si on vient du cart)
      AuthBottomSheet.show(
        context,
        onSuccess: () {
          // Continuer sur cette page après auth
          setState(() {});
        },
      );
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final commandeProvider = context.watch<CommandeProvider>();
    final authProvider = context.watch<AuthProvider>();

    // Si pas authentifié, afficher un message (ne devrait pas arriver normalement)
    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Paiement')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Connexion requise',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Veuillez vous connecter pour continuer'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => AuthBottomSheet.show(context),
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement'), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Récapitulatif commande
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Récapitulatif',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          'Sous-total',
                          cartProvider.displaySousTotal,
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          'Livraison',
                          cartProvider.displayFraisLivraison,
                        ),
                        const Divider(height: 24),
                        _buildSummaryRow(
                          'Total',
                          cartProvider.displayTotal,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Adresse de livraison
                  const Text(
                    'Adresse de livraison',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Adresse',
                            prefixIcon: Icon(Icons.location_on),
                            border: InputBorder.none,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Méthodes de paiement
                  const Text(
                    'Moyen de paiement',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...paymentMethods.map(
                    (method) => _buildPaymentMethod(method),
                  ),

                  const SizedBox(height: 24),

                  // Numéro de téléphone pour paiement
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Numéro pour le paiement',
                      hintText: '67 XX XX XX XX',
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bouton de confirmation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  if (commandeProvider.error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              commandeProvider.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total à payer'),
                            Text(
                              cartProvider.displayTotal,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          text: 'Payer maintenant',
                          isLoading:
                              _isProcessing || commandeProvider.isLoading,
                          onPressed: () => _showPaymentConfirmation(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : AppTheme.textSecondary,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppTheme.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(Map<String, dynamic> method) {
    final isSelected = selectedPayment == method['id'];
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = method['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? method['color'].withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? method['color'] : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: method['color'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  method['icon'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSelected ? 'Sélectionné' : 'Appuyez pour sélectionner',
                    style: TextStyle(
                      color: isSelected ? method['color'] : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: method['color']),
          ],
        ),
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Paiement réussi !'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: AppTheme.accentColor, size: 64),
            SizedBox(height: 16),
            Text('Votre commande a été confirmée.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.orders);
            },
            child: const Text('Voir mes commandes'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    final commandeProvider = context.read<CommandeProvider>();

    setState(() => _isProcessing = true);

    // Simuler le traitement du paiement
    await Future.delayed(const Duration(seconds: 2));

    // Créer la commande
    final commande = await commandeProvider.createCommande(
      adresseLivraison: _addressController.text,
      cart: cartProvider.cart,
    );

    setState(() => _isProcessing = false);

    if (commande != null && mounted) {
      // Vider le panier
      cartProvider.clearCart();

      // Afficher le succès
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Paiement réussi !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppTheme.accentColor,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text('Votre commande ${commande.reference} a été confirmée.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.orders);
              },
              child: const Text('Voir mes commandes'),
            ),
          ],
        ),
      );
    }
  }
}
