enum UserRole { client, vendor, delivery, admin }

extension UserRoleExtension on UserRole {
  String get apiValue {
    switch (this) {
      case UserRole.client:
        return 'CLIENT';
      case UserRole.vendor:
        return 'VENDEUR';
      case UserRole.delivery:
        return 'LIVREUR';
      case UserRole.admin:
        return 'ADMIN';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.client:
        return 'Client';
      case UserRole.vendor:
        return 'Vendeur';
      case UserRole.delivery:
        return 'Livreur';
      case UserRole.admin:
        return 'Admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ROLE_CLIENT':
      case 'CLIENT':
        return UserRole.client;
      case 'ROLE_VENDEUR':
      case 'VENDEUR':
        return UserRole.vendor;
      case 'ROLE_LIVREUR':
      case 'LIVREUR':
        return UserRole.delivery;
      case 'ROLE_ADMIN':
      case 'ADMIN':
        return UserRole.admin;
      default:
        return UserRole.client;
    }
  }
}

class UserModel {
  final int id;
  final String nom;
  final String email;
  final String? telephone;
  final String? adresse;
  final List<UserRole> roles;
  final String token;
  final String tokenType;

  UserModel({
    required this.id,
    required this.nom,
    required this.email,
    this.telephone,
    this.adresse,
    required this.roles,
    required this.token,
    this.tokenType = 'Bearer',
  });

  // Parse JwtResponse du backend
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rolesList =
        (json['roles'] as List<dynamic>?)
            ?.map((role) => UserRoleExtension.fromString(role.toString()))
            .toList() ??
        [UserRole.client];

    return UserModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'],
      adresse: json['adresse'],
      token: json['token'] ?? '',
      tokenType: json['type'] ?? 'Bearer',
      roles: rolesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'token': token,
      'type': tokenType,
      'roles': roles.map((r) => r.apiValue).toList(),
    };
  }

  UserRole get primaryRole => roles.isNotEmpty ? roles.first : UserRole.client;

  bool get isClient => roles.contains(UserRole.client);
  bool get isVendor => roles.contains(UserRole.vendor);
  bool get isDelivery => roles.contains(UserRole.delivery);
  bool get isAdmin => roles.contains(UserRole.admin);

  String get authHeader => '$tokenType $token';

  UserModel copyWith({
    int? id,
    String? nom,
    String? email,
    String? telephone,
    String? adresse,
    List<UserRole>? roles,
    String? token,
    String? tokenType,
  }) {
    return UserModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      adresse: adresse ?? this.adresse,
      roles: roles ?? this.roles,
      token: token ?? this.token,
      tokenType: tokenType ?? this.tokenType,
    );
  }
}
