# Structure du Projet Egg Delivery

## Vue d'ensemble de l'architecture

```
egg-delivery-app/
│
├── src/
│   ├── main/
│   │   ├── java/com/eggdelivery/
│   │   │   │
│   │   │   ├── config/                      # Configuration de l'application
│   │   │   │   ├── OpenApiConfig.java       # Configuration Swagger/OpenAPI
│   │   │   │   └── SecurityConfig.java      # Configuration Spring Security
│   │   │   │
│   │   │   ├── controller/                  # Contrôleurs REST
│   │   │   │   ├── AuthController.java      # Authentification
│   │   │   │   ├── CommandeController.java  # Gestion des commandes
│   │   │   │   ├── LivraisonController.java # Gestion des livraisons
│   │   │   │   ├── OffreProduitController.java
│   │   │   │   └── ProduitController.java   # Gestion des produits
│   │   │   │
│   │   │   ├── dto/                         # Data Transfer Objects
│   │   │   │   ├── CommandeRequest.java
│   │   │   │   ├── JwtResponse.java
│   │   │   │   ├── LoginRequest.java
│   │   │   │   ├── OffreProduitRequest.java
│   │   │   │   ├── ProduitRequest.java
│   │   │   │   └── RegisterRequest.java
│   │   │   │
│   │   │   ├── exception/                   # Gestion des exceptions
│   │   │   │   └── GlobalExceptionHandler.java
│   │   │   │
│   │   │   ├── model/                       # Entités JPA
│   │   │   │   ├── Admin.java              # Hérite de Utilisateur
│   │   │   │   ├── Client.java             # Hérite de Utilisateur
│   │   │   │   ├── Commande.java
│   │   │   │   ├── LigneCommande.java
│   │   │   │   ├── Livraison.java
│   │   │   │   ├── Livreur.java            # Hérite de Utilisateur
│   │   │   │   ├── OffreProduit.java
│   │   │   │   ├── Paiement.java
│   │   │   │   ├── Produit.java
│   │   │   │   ├── Utilisateur.java         # Classe parent
│   │   │   │   ├── Vendeur.java            # Hérite de Utilisateur
│   │   │   │   └── ZoneLivraison.java
│   │   │   │
│   │   │   ├── repository/                  # Repositories JPA
│   │   │   │   ├── ClientRepository.java
│   │   │   │   ├── CommandeRepository.java
│   │   │   │   ├── LigneCommandeRepository.java
│   │   │   │   ├── LivraisonRepository.java
│   │   │   │   ├── LivreurRepository.java
│   │   │   │   ├── OffreProduitRepository.java
│   │   │   │   ├── PaiementRepository.java
│   │   │   │   ├── ProduitRepository.java
│   │   │   │   ├── UtilisateurRepository.java
│   │   │   │   ├── VendeurRepository.java
│   │   │   │   └── ZoneLivraisonRepository.java
│   │   │   │
│   │   │   ├── security/                    # Sécurité JWT
│   │   │   │   ├── AuthEntryPointJwt.java
│   │   │   │   ├── JwtAuthenticationFilter.java
│   │   │   │   ├── JwtUtils.java
│   │   │   │   └── UserDetailsServiceImpl.java
│   │   │   │
│   │   │   ├── service/                     # Logique métier
│   │   │   │   ├── AuthService.java
│   │   │   │   ├── CommandeService.java
│   │   │   │   ├── LivraisonService.java
│   │   │   │   ├── OffreProduitService.java
│   │   │   │   └── ProduitService.java
│   │   │   │
│   │   │   ├── util/                        # Classes utilitaires
│   │   │   │   └── ReferenceGenerator.java
│   │   │   │
│   │   │   └── EggDeliveryApplication.java  # Classe principale
│   │   │
│   │   └── resources/
│   │       ├── application.properties        # Config principale
│   │       ├── application-dev.properties    # Config développement
│   │       ├── application-prod.properties   # Config production
│   │       └── data.sql                      # Données de test
│   │
│   └── test/
│       └── java/com/eggdelivery/
│           └── service/
│               └── CommandeServiceTest.java  # Tests unitaires
│
├── .gitignore                               # Fichiers à ignorer par Git
├── docker-compose.yml                       # Configuration Docker Compose
├── Dockerfile                               # Image Docker
├── pom.xml                                  # Dépendances Maven
├── postman_collection.json                  # Collection Postman
├── PROJECT_STRUCTURE.md                     # Ce fichier
├── QUICK_START.md                          # Guide de démarrage rapide
└── README.md                               # Documentation principale
```

## Description des packages

### 📦 config/
Contient toutes les classes de configuration de l'application :
- **SecurityConfig** : Configuration de Spring Security avec JWT
- **OpenApiConfig** : Configuration Swagger pour la documentation API

### 🎮 controller/
Les contrôleurs REST qui exposent les endpoints de l'API :
- Gestion de l'authentification
- CRUD des produits, commandes, livraisons
- Chaque contrôleur suit les bonnes pratiques REST

### 📋 dto/
Data Transfer Objects pour la communication client-serveur :
- Objets de requête (Request)
- Objets de réponse (Response)
- Validation des données avec Jakarta Validation

### 🗃️ model/
Entités JPA mappées à la base de données :
- **Héritage** : Utilisateur → Client, Admin, Vendeur, Livreur
- **Relations** : OneToMany, ManyToOne, ManyToMany
- **Auditing** : Dates de création/modification automatiques

### 🔍 repository/
Repositories Spring Data JPA :
- Méthodes CRUD automatiques
- Requêtes personnalisées avec naming convention
- Queries dérivées du nom de la méthode

### 🔐 security/
Composants de sécurité JWT :
- Génération et validation de tokens
- Filtres d'authentification
- Gestion des accès non autorisés

### 💼 service/
Logique métier de l'application :
- Services transactionnels
- Règles de gestion
- Orchestration entre repositories

### 🛠️ util/
Classes utilitaires :
- Génération de références uniques
- Helpers et fonctions communes

### ⚙️ exception/
Gestion centralisée des exceptions :
- GlobalExceptionHandler pour toutes les erreurs
- Réponses d'erreur personnalisées

## Flux de données

```
Client HTTP Request
      ↓
Controller (Validation)
      ↓
Service (Logique métier)
      ↓
Repository (Accès données)
      ↓
Database (Persistance)
```

## Relations entre entités principales

```
Utilisateur (abstract)
    ├── Client → Commande → LigneCommande → OffreProduit
    ├── Vendeur → Produit → OffreProduit
    ├── Livreur → Livraison
    └── Admin

Commande
    ├── LigneCommande (Many)
    ├── Livraison (One)
    └── Paiement (One)

Produit
    ├── OffreProduit (Many)
    └── Vendeur (One)

ZoneLivraison
    ├── Vendeur (One)
    └── OffreProduit (Many-to-Many)
```

## Technologies par couche

### Couche Présentation
- Spring Web MVC
- REST Controllers
- Spring Validation
- Swagger/OpenAPI

### Couche Métier
- Spring Service
- Spring Transaction
- Business Logic

### Couche Persistance
- Spring Data JPA
- Hibernate
- MySQL / H2

### Couche Sécurité
- Spring Security
- JWT (JSON Web Tokens)
- BCrypt Password Encoder

## Patterns utilisés

1. **Repository Pattern** : Abstraction de l'accès aux données
2. **Service Layer** : Encapsulation de la logique métier
3. **DTO Pattern** : Séparation entre entités et objets de transfert
4. **Dependency Injection** : Gestion des dépendances par Spring
5. **Builder Pattern** : Construction d'objets complexes (Lombok)

## Principes SOLID appliqués

- ✅ **S**ingle Responsibility : Chaque classe a une responsabilité unique
- ✅ **O**pen/Closed : Extensions possibles sans modification
- ✅ **L**iskov Substitution : Héritage cohérent (Utilisateur)
- ✅ **I**nterface Segregation : Interfaces JPA spécifiques
- ✅ **D**ependency Inversion : Injection de dépendances

## Convention de nommage

### Classes
- **Entités** : Nom singulier (Client, Produit)
- **Controllers** : NomController (ProduitController)
- **Services** : NomService (CommandeService)
- **Repositories** : NomRepository (ClientRepository)
- **DTOs** : NomRequest/NomResponse

### Méthodes
- **CRUD** : create, get, update, delete
- **Queries** : findBy, getBy, searchBy
- **Business** : process, calculate, validate

### Tables BDD
- **Nom** : pluriel en minuscules (produits, commandes)
- **Colonnes** : snake_case (date_creation, montant_total)

## Points d'extension

L'architecture permet facilement d'ajouter :
- ✨ Nouveaux types d'utilisateurs (hériter de Utilisateur)
- ✨ Nouvelles méthodes de paiement (enum extensible)
- ✨ Nouveaux statuts de commande
- ✨ Nouveaux endpoints REST
- ✨ Notifications (email, SMS, push)
- ✨ Système de cache (Redis)
- ✨ Message Queue (RabbitMQ, Kafka)
