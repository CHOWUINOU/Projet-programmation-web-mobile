import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/providers/commande_provider.dart';
import '../../shared/models/commande_model.dart';

class VendorOrders extends StatefulWidget {
  const VendorOrders({super.key});

  @override
  State<VendorOrders> createState() => _VendorOrdersState();
}

class _VendorOrdersState extends State<VendorOrders> {
  String filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommandeProvider>().loadCommandesRecues();
    });
  }

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'EN_ATTENTE':
        return Colors.orange;
      case 'CONFIRMEE':
        return Colors.blue;
      case 'EN_PREPARATION':
        return Colors.purple;
      case 'PRETE':
        return Colors.teal;
      case 'EN_LIVRAISON':
        return Colors.indigo;
      case 'LIVREE':
        return AppTheme.accentColor;
      case 'ANNULEE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commandeProvider = context.watch<CommandeProvider>();

    final filteredOrders = filterStatus == 'all'
        ? commandeProvider.commandes
        : commandeProvider.commandes
              .where((o) => o.statut == filterStatus)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commandes reçues'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Toutes', 'all'),
                  _buildFilterChip('Nouvelles', 'EN_ATTENTE'),
                  _buildFilterChip('Confirmées', 'CONFIRMEE'),
                  _buildFilterChip('En cours', 'EN_PREPARATION'),
                  _buildFilterChip('Livrées', 'LIVREE'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: commandeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : commandeProvider.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(commandeProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => commandeProvider.loadCommandesRecues(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            )
          : filteredOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune commande',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(context, order);
              },
            ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = filterStatus == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => setState(() => filterStatus = value),
        selectedColor: AppTheme.primaryColor,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, CommandeModel order) {
    final statusColor = _getStatusColor(order.statut);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt, color: statusColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      order.reference,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statutDisplay,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.secondaryColor,
                      child: Icon(Icons.person, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.clientNom ?? 'Client',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            order.formattedDate,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                ...order.lignes.map<Widget>(
                  (ligne) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ligne.produit?.typeOeuf ?? 'M',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${ligne.quantite} x ${ligne.produit?.nom ?? 'Produit'}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.adresseLivraison,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${order.montantTotal.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (order.statut == 'EN_ATTENTE')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Refuser'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () =>
                          _showAssignDeliveryDialog(context, order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                      ),
                      child: const Text('Accepter & Assigner'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showAssignDeliveryDialog(BuildContext context, CommandeModel order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigner un livreur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.secondaryColor,
                child: Icon(Icons.person, color: AppTheme.primaryColor),
              ),
              title: const Text('Kouassi Jean'),
              subtitle: const Text('3 livraisons aujourd\'hui'),
              trailing: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<CommandeProvider>().accepterCommande(
                    order.id,
                  );
                },
                child: const Text('Assigner'),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.secondaryColor,
                child: Icon(Icons.person, color: AppTheme.primaryColor),
              ),
              title: const Text('Yao Emmanuel'),
              subtitle: const Text('Disponible'),
              trailing: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<CommandeProvider>().accepterCommande(
                    order.id,
                  );
                },
                child: const Text('Assigner'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
