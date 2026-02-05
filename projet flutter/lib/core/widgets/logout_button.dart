import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/shared/providers/auth_providers.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Déconnexion'),
            content: const Text('Voulez-vous vraiment vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Déconnecter'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await Provider.of<AuthProvider>(context, listen: false).logout();
          // AuthWrapper redirigera automatiquement vers HomeScreen
        }
      },
    );
  }
}
