# Application de Commande et Livraison d'Œufs

## Description
Application Spring Boot complète pour la gestion d'un système de commande et livraison d'œufs. L'application permet aux clients de commander des œufs auprès de différents vendeurs, avec un système de livraison intégré.

## Technologies Utilisées
- **Spring Boot 3.2.1**
- **Spring Security** (avec JWT)
- **Spring Data JPA**
- **MySQL** (base de données principale)
- **H2** (base de données de test)
- **Lombok** (réduction du code boilerplate)
- **Swagger/OpenAPI** (documentation API)
- **Maven** (gestion des dépendances)

## Architecture

### Modèle de Données
L'application suit le diagramme de classes fourni avec les entités suivantes :

1. **Utilisateurs** (avec héritage) :
   - `Utilisateur` (classe parent)
   - `Client`
   - `Admin`
   - `Vendeur`
   - `Livreur`

2. **Produits et Offres** :
   - `Produit`
   - `OffreProduit`
   - `ZoneLivraison`

3. **Commandes** :
   - `Commande`
   - `LigneCommande`
   - `Livraison`
   - `Paiement`

### Structure du Projet
```
egg-delivery-app/
├── src/
│   ├── main/
│   │   ├── java/com/eggdelivery/
│   │   │   ├── config/              # Configuration (Security, OpenAPI)
│   │   │   ├── controller/          # Contrôleurs REST
│   │   │   ├── dto/                 # Data Transfer Objects
│   │   │   ├── exception/           # Gestion des exceptions
│   │   │   ├── model/               # Entités JPA
│   │   │   ├── repository/          # Repositories JPA
│   │   │   ├── security/            # Configuration de sécurité JWT
│   │   │   ├── service/             # Services métier
│   │   │   └── EggDeliveryApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/                        # Tests unitaires et d'intégration
└── pom.xml
```

## Installation et Configuration

### Prérequis
- Java 17 ou supérieur
- Maven 3.6+
- MySQL 8.0+ (ou utiliser H2 pour les tests)

### Configuration de la Base de Données

1. Créer une base de données MySQL :
```sql
CREATE DATABASE egg_delivery_db;
```

2. Modifier `application.properties` si nécessaire :
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/egg_delivery_db
spring.datasource.username=votre_username
spring.datasource.password=votre_password
```

### Compilation et Exécution

1. Compiler le projet :
```bash
mvn clean install
```

2. Lancer l'application :
```bash
mvn spring-boot:run
```

L'application sera accessible sur : `http://localhost:8080`

## Documentation API

### Swagger UI
Une fois l'application lancée, accédez à la documentation interactive Swagger :
- **URL** : `http://localhost:8080/swagger-ui.html`

### Endpoints Principaux

#### Authentification
- `POST /api/auth/register` - Inscription d'un nouvel utilisateur
- `POST /api/auth/login` - Connexion et obtention du token JWT

#### Produits
- `GET /api/produits` - Liste tous les produits
- `GET /api/produits/{id}` - Détails d'un produit
- `POST /api/produits/vendeur/{vendeurId}` - Créer un produit (VENDEUR)
- `PUT /api/produits/{id}` - Mettre à jour un produit (VENDEUR)
- `DELETE /api/produits/{id}` - Supprimer un produit (VENDEUR)

#### Offres Produits
- `GET /api/offres` - Liste toutes les offres
- `GET /api/offres/{id}` - Détails d'une offre
- `POST /api/offres` - Créer une offre (VENDEUR)
- `PUT /api/offres/{id}` - Mettre à jour une offre (VENDEUR)
- `PUT /api/offres/{id}/stock` - Mettre à jour le stock (VENDEUR)

#### Commandes
- `GET /api/commandes` - Liste toutes les commandes (ADMIN)
- `GET /api/commandes/{id}` - Détails d'une commande
- `GET /api/commandes/client/{clientId}` - Commandes d'un client
- `POST /api/commandes/client/{clientId}` - Créer une commande (CLIENT)
- `PUT /api/commandes/{id}/statut` - Mettre à jour le statut (ADMIN/VENDEUR)
- `DELETE /api/commandes/{id}` - Annuler une commande (CLIENT)

#### Livraisons
- `GET /api/livraisons` - Liste toutes les livraisons (ADMIN)
- `GET /api/livraisons/{id}` - Détails d'une livraison
- `GET /api/livraisons/livreur/{livreurId}` - Livraisons d'un livreur
- `PUT /api/livraisons/{id}/assigner` - Assigner un livreur (ADMIN)
- `PUT /api/livraisons/{id}/demarrer` - Démarrer une livraison (LIVREUR)
- `PUT /api/livraisons/{id}/terminer` - Terminer une livraison (LIVREUR)
- `PUT /api/livraisons/{id}/position` - Mettre à jour la position (LIVREUR)

## Authentification JWT

### Inscription
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nom": "John Doe",
    "email": "john@example.com",
    "motdepasse": "password123",
    "telephone": "+237600000000",
    "adresse": "Yaoundé, Cameroun",
    "typeUtilisateur": "CLIENT"
  }'
```

### Connexion
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "motdepasse": "password123"
  }'
```

Réponse :
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": 1,
  "nom": "John Doe",
  "email": "john@example.com",
  "roles": ["ROLE_CLIENT"]
}
```

### Utilisation du Token
Incluez le token dans l'en-tête `Authorization` :
```bash
curl -X GET http://localhost:8080/api/produits \
  -H "Authorization: Bearer votre_token_jwt"
```

## Rôles et Permissions

### ROLE_CLIENT
- Créer des commandes
- Consulter ses propres commandes
- Annuler ses commandes
- Consulter les produits et offres

### ROLE_VENDEUR
- Gérer ses produits
- Gérer ses offres
- Consulter les commandes de ses produits
- Mettre à jour le statut des commandes

### ROLE_LIVREUR
- Consulter ses livraisons assignées
- Démarrer/terminer les livraisons
- Mettre à jour sa position GPS

### ROLE_ADMIN
- Accès complet à toutes les fonctionnalités
- Gestion des utilisateurs
- Assigner les livreurs
- Consulter toutes les statistiques

## Flux de Travail Typique

### 1. Client Passe une Commande
1. Le client s'inscrit et se connecte
2. Consulte les produits disponibles
3. Crée une commande avec plusieurs produits
4. Le système génère automatiquement une livraison

### 2. Traitement de la Commande
1. Le vendeur reçoit la commande
2. Change le statut : EN_ATTENTE → CONFIRMEE → EN_PREPARATION → PRETE

### 3. Livraison
1. L'admin assigne un livreur disponible
2. Le livreur démarre la livraison
3. Met à jour sa position en temps réel
4. Termine la livraison

### 4. Paiement
Le paiement est créé automatiquement avec la commande et peut être mis à jour selon le statut.

## Tests

Exécuter les tests :
```bash
mvn test
```

## Sécurité

- **Mots de passe** : Hashés avec BCrypt
- **JWT** : Tokens avec expiration de 24 heures
- **CORS** : Configuré pour accepter les requêtes depuis localhost
- **HTTPS** : Recommandé en production

## Améliorations Futures

- [ ] Système de notifications (email/SMS)
- [ ] Calcul automatique des frais de livraison
- [ ] Historique des commandes avec statistiques
- [ ] Système de notation des vendeurs et livreurs
- [ ] Chat en temps réel entre client et livreur
- [ ] Intégration de paiement mobile (Mobile Money)
- [ ] Application mobile (Android/iOS)
- [ ] Tableau de bord analytique

## Support

Pour toute question ou problème :
- Email : support@eggdelivery.com
- Documentation : http://localhost:8080/swagger-ui.html

## Licence

Ce projet est sous licence Apache 2.0
