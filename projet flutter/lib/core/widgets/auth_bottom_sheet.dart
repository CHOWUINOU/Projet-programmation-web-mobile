// lib/features/auth/widgets/auth_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/shared/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../features/shared/models/user_model.dart';

class AuthBottomSheet extends StatefulWidget {
  final VoidCallback? onAuthSuccess;

  const AuthBottomSheet({super.key, this.onAuthSuccess});

  static Future<void> show(BuildContext context, {VoidCallback? onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AuthBottomSheet(onAuthSuccess: onSuccess),
    );
  }

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  // Controllers pour connexion
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Controllers pour inscription (exactement comme dans AuthScreen)
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _nomBoutiqueController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _moyenTransportController = TextEditingController();

  // Sélection de rôle uniquement pour l'inscription
  UserRole selectedRole = UserRole.client;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _nomBoutiqueController.dispose();
    _descriptionController.dispose();
    _moyenTransportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLogin ? 'Connexion' : 'Créer un compte',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isLogin
                                    ? 'Connectez-vous pour accéder à votre compte'
                                    : 'Inscrivez-vous pour rejoindre notre marketplace d\'œufs',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Toggle Login/Register
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildToggleButton('Connexion', isLogin),
                            _buildToggleButton('Inscription', !isLogin),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Error message
                    if (authProvider.error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Form
                    Form(
                      key: _formKey,
                      child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    CustomButton(
                      text: isLogin ? 'Se connecter' : 'Créer mon compte',
                      isLoading: authProvider.isLoading,
                      onPressed: () => _handleSubmit(authProvider),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() => isLogin = text == 'Connexion');
        context.read<AuthProvider>().clearError();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? AppTheme.primaryColor : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _loginEmailController,
          label: 'Email',
          icon: Icons.email_outlined,
          hint: 'jean@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Champ requis';
            if (!v!.contains('@')) return 'Email invalide';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _loginPasswordController,
          label: 'Mot de passe',
          icon: Icons.lock_outline,
          hint: '••••••••',
          isPassword: true,
          validator: (v) =>
              (v?.length ?? 0) < 6 ? 'Mot de passe trop court (min 6)' : null,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text('Mot de passe oublié ?'),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Champs communs
        _buildTextField(
          controller: _nameController,
          label: 'Nom complet',
          icon: Icons.person_outline,
          hint: 'Jean Dupont',
          validator: (v) => v?.isEmpty ?? true ? 'Champ requis' : null,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          hint: 'jean@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Champ requis';
            if (!v!.contains('@')) return 'Email invalide';
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _phoneController,
          label: 'Téléphone',
          icon: Icons.phone_outlined,
          hint: '07 XX XX XX XX',
          keyboardType: TextInputType.phone,
          validator: (v) => (v?.length ?? 0) < 8 ? 'Numéro invalide' : null,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _addressController,
          label: 'Adresse',
          icon: Icons.home_outlined,
          hint: 'Cocody, Riviera',
          validator: (v) => v?.isEmpty ?? true ? 'Champ requis' : null,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _passwordController,
          label: 'Mot de passe',
          icon: Icons.lock_outline,
          hint: '••••••••',
          isPassword: true,
          validator: (v) =>
              (v?.length ?? 0) < 6 ? 'Mot de passe trop court (min 6)' : null,
        ),

        const SizedBox(height: 24),

        // SÉLECTION DU RÔLE
        const Text(
          'Je suis :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildRoleSelector(),
        const SizedBox(height: 8),
        Text(
          'Cette information déterminera votre tableau de bord',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),

        // Champs spécifiques selon le rôle
        if (selectedRole == UserRole.vendor) ...[
          const SizedBox(height: 16),
          _buildTextField(
            controller: _nomBoutiqueController,
            label: 'Nom de la boutique',
            icon: Icons.store_outlined,
            hint: 'Ma Ferme',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            icon: Icons.description_outlined,
            hint: 'Description de votre ferme...',
            maxLines: 3,
          ),
        ],

        if (selectedRole == UserRole.delivery) ...[
          const SizedBox(height: 16),
          _buildTextField(
            controller: _moyenTransportController,
            label: 'Moyen de transport',
            icon: Icons.delivery_dining_outlined,
            hint: 'Moto, Vélo, etc.',
          ),
        ],
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildRoleOption(
            UserRole.client,
            'Client',
            'Je veux acheter des œufs',
            Icons.shopping_basket_outlined,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildRoleOption(
            UserRole.vendor,
            'Vendeur',
            'Je veux vendre mes œufs',
            Icons.store_outlined,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildRoleOption(
            UserRole.delivery,
            'Livreur',
            'Je veux livrer des commandes',
            Icons.delivery_dining_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption(
    UserRole role,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = selectedRole == role;
    return InkWell(
      onTap: () => setState(() => selectedRole = role),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
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
                      fontSize: 16,
                      color: isSelected ? AppTheme.primaryColor : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    bool success;

    if (isLogin) {
      // CONNEXION
      success = await authProvider.login(
        _loginEmailController.text.trim(),
        _loginPasswordController.text,
      );
    } else {
      // INSCRIPTION avec tous les champs
      success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: selectedRole,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        nomBoutique: selectedRole == UserRole.vendor
            ? _nomBoutiqueController.text.trim()
            : null,
        description: selectedRole == UserRole.vendor
            ? _descriptionController.text.trim()
            : null,
        moyenTransport: selectedRole == UserRole.delivery
            ? _moyenTransportController.text.trim()
            : null,
      );
    }

    if (success && mounted) {
      // La redirection est gérée automatiquement par AuthWrapper
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isLogin ? 'Connexion réussie !' : 'Inscription réussie !',
          ),
          backgroundColor: AppTheme.accentColor,
        ),
      );
      Navigator.pop(context);
      widget.onAuthSuccess?.call();
    }
  }
}
