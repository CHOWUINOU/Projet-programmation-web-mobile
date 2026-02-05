import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../shared/providers/livraison_provider.dart';
import '../../shared/models/commande_model.dart';

class DeliveryDetails extends StatefulWidget {
  final Map<String, dynamic> delivery;

  const DeliveryDetails({super.key, required this.delivery});

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  @override
  Widget build(BuildContext context) {
    final livraison = widget.delivery['delivery'] as CommandeModel?;
    if (livraison == null) {
      return const Scaffold(body: Center(child: Text('Livraison non trouvée')));
    }

    final statut = livraison.livraison?.statut ?? 'ASSIGNEE';

    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la livraison')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline de progression
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
                      children: [
                        _buildTimelineStep(
                          'Commande acceptée',
                          '13:30',
                          true,
                          true,
                        ),
                        _buildTimelineStep(
                          'Retrait chez le vendeur',
                          statut != 'ASSIGNEE' ? 'Effectué' : 'En attente',
                          statut != 'ASSIGNEE',
                          statut != 'ASSIGNEE',
                        ),
                        _buildTimelineStep(
                          'En cours de livraison',
                          statut == 'EN_COURS' ? 'En cours' : 'En attente',
                          statut == 'EN_COURS',
                          statut == 'EN_COURS',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informations client
                  const Text(
                    'Client',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppTheme.secondaryColor,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                livraison.clientNom ?? 'Client',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '6 78 55 64 33',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.phone,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.message,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Adresse
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
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            livraison.adresseLivraison,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.navigation,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Détails commande
                  const Text(
                    'Détails de la commande',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Commande', livraison.reference),
                        const Divider(),
                        _buildDetailRow(
                          'Articles',
                          '${livraison.totalItems} plateaux',
                        ),
                        const Divider(),
                        _buildDetailRow(
                          'Total',
                          '${livraison.montantTotal.toStringAsFixed(0)} FCFA',
                          valueColor: AppTheme.primaryColor,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bouton d'action principal
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
            child: SafeArea(child: _buildActionButton(statut, livraison)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    String title,
    String subtitle,
    bool isCompleted,
    bool isActive, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.accentColor
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: isActive && !isCompleted
                    ? Border.all(color: AppTheme.accentColor, width: 3)
                    : null,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? AppTheme.accentColor
                    : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: isActive ? AppTheme.accentColor : Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String statut, CommandeModel livraison) {
    final livraisonProvider = context.watch<LivraisonProvider>();

    if (statut == 'ASSIGNEE') {
      return CustomButton(
        text: 'Confirmer le retrait',
        icon: Icons.store,
        onPressed: () async {
          await livraisonProvider.demarrerLivraison(livraison.livraison!.id);
          if (mounted) {
            Navigator.pop(context);
          }
        },
      );
    } else if (statut == 'EN_COURS') {
      return CustomButton(
        text: 'Confirmer la livraison',
        icon: Icons.check_circle,
        backgroundColor: AppTheme.accentColor,
        onPressed: () => _showDeliveryConfirmation(livraison),
      );
    }
    return const SizedBox.shrink();
  }

  void _showDeliveryConfirmation(CommandeModel livraison) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la livraison'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppTheme.accentColor,
            ),
            SizedBox(height: 16),
            Text('Avez-vous bien livré la commande au client ?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<LivraisonProvider>();
              await provider.terminerLivraison(livraison.livraison!.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Livraison confirmée ! Gains ajoutés.'),
                    backgroundColor: AppTheme.accentColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
