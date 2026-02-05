# Guide de Démarrage Rapide - Egg Delivery App

## 🚀 Démarrage Rapide avec Docker (Recommandé)

### Prérequis
- Docker
- Docker Compose

### Étapes

1. **Cloner le projet**
```bash
cd egg-delivery-app
```

2. **Lancer avec Docker Compose**
```bash
docker-compose up -d
```

3. **Vérifier que les services sont actifs**
```bash
docker-compose ps
```

4. **Accéder à l'application**
- API: http://localhost:8080
- Swagger UI: http://localhost:8080/swagger-ui.html

5. **Arrêter l'application**
```bash
docker-compose down
```

## 💻 Démarrage Manuel (Sans Docker)

### Prérequis
- Java 17+
- Maven 3.6+
- MySQL 8.0+

### Étapes

1. **Créer la base de données**
```sql
CREATE DATABASE egg_delivery_db;
CREATE USER 'eggdelivery'@'localhost' IDENTIFIED BY 'eggdelivery123';
GRANT ALL PRIVILEGES ON egg_delivery_db.* TO 'eggdelivery'@'localhost';
FLUSH PRIVILEGES;
```

2. **Configurer application.properties**
Vérifier/modifier `src/main/resources/application.properties`

3. **Compiler et lancer**
```bash
mvn clean install
mvn spring-boot:run
```

Ou avec un profil spécifique :
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

## 🧪 Mode Développement (avec H2)

Pour un démarrage ultra-rapide sans MySQL :

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

Accéder à la console H2 : http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:eggdeliverydb`
- Username: `sa`
- Password: (vide)

## 📝 Premiers Tests

### 1. Créer un compte client

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nom": "Test Client",
    "email": "test@example.com",
    "motdepasse": "password123",
    "telephone": "+237600000000",
    "adresse": "Yaoundé",
    "typeUtilisateur": "CLIENT"
  }'
```

### 2. Se connecter

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "motdepasse": "password123"
  }'
```

Copier le `token` de la réponse.

### 3. Lister les produits

```bash
curl -X GET http://localhost:8080/api/produits \
  -H "Authorization: Bearer VOTRE_TOKEN"
```

### 4. Créer une commande

```bash
curl -X POST http://localhost:8080/api/commandes/client/1 \
  -H "Authorization: Bearer VOTRE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "adresseLivraison": "Yaoundé Nlongkak",
    "lignesCommande": [
      {
        "offreProduitId": 1,
        "quantite": 2
      }
    ]
  }'
```

## 📚 Documentation API Complète

Accéder à Swagger UI pour tester toutes les API :
**http://localhost:8080/swagger-ui.html**

## 🔑 Comptes de Test (si vous avez exécuté data.sql)

### Admin
- Email: `admin@eggdelivery.com`
- Password: `password123`

### Vendeur
- Email: `vendeur1@eggdelivery.com`
- Password: `password123`

### Livreur
- Email: `livreur1@eggdelivery.com`
- Password: `password123`

### Client
- Email: `client1@eggdelivery.com`
- Password: `password123`

## 🐛 Dépannage

### Port 8080 déjà utilisé
Changer le port dans `application.properties`:
```properties
server.port=8081
```

### Erreur de connexion à MySQL
Vérifier que MySQL est lancé:
```bash
sudo systemctl status mysql
```

### Erreur "Table doesn't exist"
Vérifier `spring.jpa.hibernate.ddl-auto` dans `application.properties`:
```properties
spring.jpa.hibernate.ddl-auto=update
```

## 📊 Monitoring

### Vérifier la santé de l'application
```bash
curl http://localhost:8080/actuator/health
```

### Voir les logs en temps réel (Docker)
```bash
docker-compose logs -f app
```

## 🎯 Prochaines Étapes

1. Explorer toutes les API via Swagger UI
2. Tester les différents rôles (Admin, Vendeur, Livreur, Client)
3. Créer des commandes complètes
4. Suivre le cycle de vie d'une livraison

## 📞 Support

Pour plus d'informations, consultez le [README.md](README.md) complet.
