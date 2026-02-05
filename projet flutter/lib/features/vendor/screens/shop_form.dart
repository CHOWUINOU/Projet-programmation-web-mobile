import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:frontend/features/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../shared/services/vendeur_service.dart';

class ShopForm extends StatefulWidget {
  const ShopForm({super.key});

  @override
  State<ShopForm> createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController(text: 'Ferme Douala premium');
  final _descriptionController = TextEditingController(
    text: 'Nous produisons des œufs frais de qualité supérieure...',
  );
  final _telephoneController = TextEditingController(text: '6 90 89 67 55');
  final _emailController = TextEditingController(text: 'contact@ferme.com');
  final _adresseController = TextEditingController(text: 'Douala, Logbessou');

  final vendeurService = VendeurService();
  final auth_service = AuthService();
  img.XFile? _selectedImageWeb;
  File? _selectedImage;
  bool isEditing = false;
  bool isLoading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBoutique();
  }

  Future<void> _pickImage() async {
    final picker = img.ImagePicker();
    final picked = await picker.pickImage(source: img.ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        // Sur web, on garde le XFile pour Image.network
        setState(() {
          _selectedImageWeb = picked;
        });
      } else {
        // Sur mobile, on utilise File
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    }
  }

  Future<void> _loadBoutique() async {
    final token = await auth_service.getToken();

    final vendeur = await vendeurService.getMaBoutique(token);

    setState(() {
      _nomController.text = vendeur.nomBoutique ?? '';
      _descriptionController.text = vendeur.description ?? '';
      _telephoneController.text = vendeur.telephone;
      _emailController.text = vendeur.email;
      _adresseController.text = vendeur.adresse ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Boutique'),
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: () => setState(() => isEditing = true),
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Photo
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.store,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: kIsWeb
                                  ? (_selectedImageWeb != null
                                        ? Image.network(
                                            _selectedImageWeb!.path,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.camera, size: 20))
                                  : (_selectedImage != null
                                        ? Image.file(
                                            _selectedImage!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.camera, size: 20)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Nom de la boutique
              _buildTextField(
                controller: _nomController,
                label: 'Nom de la boutique',
                hint: 'Ex: Ferme Cocody Premium',
                icon: Icons.store_outlined,
                enabled: isEditing,
              ),
              const SizedBox(height: 20),

              // Description
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Décrivez votre ferme et vos produits...',
                icon: Icons.description_outlined,
                maxLines: 4,
                enabled: isEditing,
              ),
              const SizedBox(height: 20),

              // Téléphone
              _buildTextField(
                controller: _telephoneController,
                label: 'Téléphone',
                hint: '67 XX XX XX XX',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                enabled: isEditing,
              ),
              const SizedBox(height: 20),

              // Email
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'contact@ferme.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: isEditing,
              ),
              const SizedBox(height: 20),

              // Adresse
              _buildTextField(
                controller: _adresseController,
                label: 'Adresse',
                hint: 'Douala, Logbessou...',
                icon: Icons.location_on_outlined,
                enabled: isEditing,
              ),
              const SizedBox(height: 32),

              // Statistiques rapides (lecture seule)
              if (!isEditing) ...[
                const Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatItem('Produits', '12', Icons.egg_alt),
                    _buildStatItem('Ventes', '48', Icons.shopping_bag),
                    _buildStatItem('Avis', '4.5', Icons.star),
                  ],
                ),
                const SizedBox(height: 32),
              ],

              if (isEditing)
                CustomButton(
                  text: 'Enregistrer les modifications',
                  isLoading: isLoading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    setState(() => isLoading = true);

                    try {
                      final token = await auth_service.getToken();

                      // Préparer le fichier pour le web ou mobile
                      dynamic photoToSend;
                      if (kIsWeb && _selectedImageWeb != null) {
                        photoToSend = _selectedImageWeb!;
                      } else if (!kIsWeb && _selectedImage != null) {
                        photoToSend = _selectedImage!;
                      }

                      await vendeurService.updateBoutique(
                        token: token,
                        nomBoutique: _nomController.text,
                        description: _descriptionController.text,
                        telephone: _telephoneController.text,
                        email: _emailController.text,
                        adresse: _adresseController.text,
                        photo: photoToSend,
                      );

                      setState(() => isEditing = false);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Boutique mise à jour')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur lors de la mise à jour : $e'),
                        ),
                      );
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool enabled = true,
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
          maxLines: maxLines,
          keyboardType: keyboardType,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: enabled ? AppTheme.primaryColor : Colors.grey,
            ),
            filled: true,
            fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
