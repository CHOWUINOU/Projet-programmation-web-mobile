import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/shared/models/produit_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/api_constants.dart';

class VendeurService {
  Future<void> updateBoutique({
    required String token,
    required String nomBoutique,
    required String description,
    required String telephone,
    required String email,
    required String adresse,
    dynamic photo, // XFile (web) ou File (mobile)
  }) async {
    var uri = Uri.parse(ApiConstants.boutiqueMaj);

    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nomBoutique'] = nomBoutique;
    request.fields['description'] = description;
    request.fields['telephone'] = telephone;
    request.fields['email'] = email;
    request.fields['adresse'] = adresse;

    // Ajouter la photo si disponible
    if (photo != null) {
      if (kIsWeb && photo is XFile) {
        var bytes = await photo.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('photo', bytes, filename: photo.name),
        );
      } else if (!kIsWeb && photo is File) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photo.path),
        );
      }
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception("Erreur mise à jour boutique : ${response.body}");
    }
  }

  Future<VendeurModel> getMaBoutique(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/vendeur/boutique'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return VendeurModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur chargement boutique');
    }
  }
}
