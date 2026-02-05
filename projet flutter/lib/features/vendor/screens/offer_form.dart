import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../shared/providers/produit_provider.dart';
import '../../shared/models/produit_model.dart';

class OfferForm extends StatefulWidget {
  const OfferForm({super.key});

  @override
  State<OfferForm> createState() => _OfferFormState();
}

class _OfferFormState extends State<OfferForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProduitProvider>().loadMesProduits();
    });
  }

  void _showOfferDialog({OffreModel? offer}) {
    final prixController = TextEditingController(
      text: offer?.prixUnitaire.toString() ?? '',
    );
    final stockController = TextEditingController(
      text: offer?.stock.toString() ?? '',
    );

    // Important : utiliser watch ici pour avoir les produits à jour
    final produitProvider = context.read<ProduitProvider>();
    final produits = produitProvider.produits;

    String? selectedProduitId =
        offer?.produitId?.toString() ??
        (produits.isNotEmpty ? produits.first.id.toString() : null);
    String selectedUnite = offer?.uniteDeVente ?? 'plateau';
    bool isActive = offer?.isDisponible ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        // Ajout de StatefulBuilder pour gérer l'état local
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  offer == null ? 'Nouvelle Offre' : 'Modifier l\'offre',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Dropdown produit seulement pour création
                if (offer == null && produits.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: selectedProduitId,
                    decoration: _inputDecoration('Produit'),
                    items: produits
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id.toString(),
                            child: Text(p.nom),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setModalState(() => selectedProduitId = v),
                  ),
                if (offer == null && produits.isNotEmpty)
                  const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedUnite,
                  decoration: _inputDecoration('Unité'),
                  items:
                      [
                            'plateau',
                            'carton (12 plateaux)',
                            'demi-carton (6 plateaux)',
                          ]
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                  onChanged: (v) =>
                      setModalState(() => selectedUnite = v ?? 'plateau'),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: prixController,
                  decoration: _inputDecoration('Prix (FCFA)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: stockController,
                  decoration: _inputDecoration('Stock'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                if (offer != null)
                  Row(
                    children: [
                      const Text('Activer l\'offre'),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (v) => setModalState(() => isActive = v),
                        activeColor: AppTheme.accentColor,
                      ),
                    ],
                  ),

                const Spacer(),

                CustomButton(
                  text: 'Enregistrer l\'offre',
                  onPressed: () async {
                    // Validation
                    if (selectedProduitId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez sélectionner un produit'),
                        ),
                      );
                      return;
                    }

                    if (prixController.text.isEmpty ||
                        stockController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez remplir tous les champs'),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);

                    final provider = context.read<ProduitProvider>();

                    final request = OffreProduitRequest(
                      produitId: int.parse(selectedProduitId!),
                      prixUnitaire: double.parse(prixController.text),
                      stock: int.parse(stockController.text),
                      uniteDeVente: selectedUnite,
                    );

                    if (offer == null) {
                      await provider.createOffre(request);
                    } else {
                      await provider.updateOffre(offer.id, request);
                    }

                    // ⚠️ IMPORTANT : Recharger les produits pour voir la nouvelle offre
                    await provider.loadMesProduits();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produitProvider = context.watch<ProduitProvider>();

    // ⚠️ CORRECTION : Cette liste doit être recalculée à chaque build
    final allOffres = <OffreModel>[];
    for (final produit in produitProvider.produits) {
      allOffres.addAll(produit.offres);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Offres'),
        actions: [
          IconButton(
            onPressed: () => _showOfferDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: produitProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : allOffres.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune offre',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allOffres.length,
              itemBuilder: (context, index) {
                final offer = allOffres[index];
                return Opacity(
                  opacity: offer.isDisponible ? 1.0 : 0.6,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      offer.uniteDeVente ?? 'plateau',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (!offer.isDisponible)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Inactif',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Modifier'),
                                      ),
                                      PopupMenuItem(
                                        value: 'toggle',
                                        child: Text(
                                          offer.isDisponible
                                              ? 'Désactiver'
                                              : 'Activer',
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text(
                                          'Supprimer',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        _showOfferDialog(offer: offer);
                                      } else if (value == 'toggle') {
                                        // Toggle disponibilité
                                        final provider = context
                                            .read<ProduitProvider>();
                                        // Implémentez cette méthode dans votre provider
                                        // await provider.toggleOffreStatus(offer.id);
                                        await provider
                                            .loadMesProduits(); // Recharger
                                      } else if (value == 'delete') {
                                        _showDeleteDialog(context, offer);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${offer.prixUnitaire.toStringAsFixed(0)} FCFA',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              Text(
                                'par ${offer.uniteDeVente ?? 'plateau'}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildInfoChip(
                                    Icons.inventory_2_outlined,
                                    'Stock: ${offer.stock}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (offer.isDisponible)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.accentColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Offre visible par les clients',
                                  style: TextStyle(
                                    color: AppTheme.accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showOfferDialog(),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.local_offer),
        label: const Text('Nouvelle offre'),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, OffreModel offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'offre ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<ProduitProvider>();
              await provider.deleteOffre(offer.id);
              // Recharger après suppression
              await provider.loadMesProduits();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
