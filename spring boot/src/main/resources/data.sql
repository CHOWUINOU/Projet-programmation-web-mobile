-- Script d'initialisation de la base de données avec des données de test
-- Egg Delivery Application

-- Note: Les mots de passe sont hashés avec BCrypt
-- Mot de passe par défaut pour tous les utilisateurs: password123
-- Hash BCrypt: $2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH

-- ==========================================
-- ADMIN
-- ==========================================
INSERT INTO utilisateurs (nom, email, motdepasse, telephone, adresse, statut, datecreation, dtype)
VALUES ('Admin Principal', 'admin@eggdelivery.com', '$2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH', '+237690000001', 'Yaoundé Centre', 'ACTIF', NOW(), 'Admin');

INSERT INTO user_roles (user_id, role)
VALUES (LAST_INSERT_ID(), 'ROLE_ADMIN');

-- ==========================================
-- VENDEURS
-- ==========================================
-- Vendeur 1: Ferme Bio Eggs
INSERT INTO utilisateurs (nom, email, motdepasse, telephone, adresse, statut, datecreation, dtype)
VALUES ('Jean Vendeur', 'vendeur1@eggdelivery.com', '$2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH', '+237690000002', 'Yaoundé Bastos', 'ACTIF', NOW(), 'Vendeur');

SET @vendeur1_id = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role)
VALUES (@vendeur1_id, 'ROLE_VENDEUR');

INSERT INTO vendeurs (id, nom_boutique, description, type_vente)
VALUES (@vendeur1_id, 'Ferme Bio Eggs', 'Œufs biologiques de qualité premium provenant de poules élevées en plein air', 'Bio');

-- Vendeur 2: Eggs Express
INSERT INTO utilisateurs (nom, email, motdepasse, telephone, adresse, statut, datecreation, dtype)
VALUES ('Marie Vendeur', 'vendeur2@eggdelivery.com', '$2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH', '+237690000003', 'Douala Akwa', 'ACTIF', NOW(), 'Vendeur');

SET @vendeur2_id = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role)
VALUES (@vendeur2_id, 'ROLE_VENDEUR');

INSERT INTO vendeurs (id, nom_boutique, description, type_vente)
VALUES (@vendeur2_id, 'Eggs Express', 'Livraison rapide d\'œufs frais dans toute la ville', 'Standard');

-- ==========================================
-- LIVREURS
-- ==========================================
-- Livreur 1
INSERT INTO utilisateurs (nom, email, motdepasse, telephone, adresse, statut, datecreation, dtype)
VALUES ('Paul Livreur', 'livreur1@eggdelivery.com', '$2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH', '+237690000004', 'Yaoundé Mvan', 'ACTIF', NOW(), 'Livreur');

SET @livreur1_id = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role)
VALUES (@livreur1_id, 'ROLE_LIVREUR');

INSERT INTO livreurs (id, moyen_transport, statut_livreur)
VALUES (@livreur1_id, 'Moto', 'DISPONIBLE');

-- Livreur 2
INSERT INTO utilisateurs (nom, email, motdepasse, telephone, adresse, statut, datecreation, dtype)
VALUES ('Sophie Livreur', 'livreur2@eggdelivery.com', '$2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH', '+237690000005', 'Douala Bonanjo', 'ACTIF', NOW(), 'Livreur');

SET @livreur2_id = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role)
VALUES (@livreur2_id, 'ROLE_LIVREUR');

INSERT INTO livreurs (id, moyen_transport, statut_livreur)
VALUES (@livreur2_id, 'Voiture', 'DISPONIBLE');

-- ==========================================
-- CLIENTS
-- ==========================================
-- Client 1
INSERT INTO utilisateurs (nom, email, motdepasse, telephone, adresse, statut, datecreation, dtype)
VALUES ('Alice Client', 'client1@eggdelivery.com', '$2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH', '+237690000006', 'Yaoundé Nlongkak', 'ACTIF', NOW(), 'Client');

SET @client1_id = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role)
VALUES (@client1_id, 'ROLE_CLIENT');

INSERT INTO clients (id, preferences_livraison)
VALUES (@client1_id, 'Livraison le matin entre 8h-10h');

-- Client 2
INSERT INTO utilisateurs (nom, email, motdepasse, telephone, adresse, statut, datecreation, dtype)
VALUES ('Bob Client', 'client2@eggdelivery.com', '$2a$10$YYfJ3qU6PXZXmLLvxZXvtOKqXO9pq2YqvLZF7GfXqHlGlGHGHGHGH', '+237690000007', 'Douala Bali', 'ACTIF', NOW(), 'Client');

SET @client2_id = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role)
VALUES (@client2_id, 'ROLE_CLIENT');

INSERT INTO clients (id, preferences_livraison)
VALUES (@client2_id, 'Livraison l\'après-midi');

-- ==========================================
-- PRODUITS
-- ==========================================
-- Produits du Vendeur 1 (Ferme Bio Eggs)
INSERT INTO produits (nom, description, type_oeuf, datecreation, disponibilite, vendeur_id)
VALUES 
('Œufs Bio Extra Large', 'Œufs biologiques XL de poules élevées en plein air', 'Bio', NOW(), 'DISPONIBLE', @vendeur1_id),
('Œufs Bio Medium', 'Œufs biologiques taille moyenne', 'Bio', NOW(), 'DISPONIBLE', @vendeur1_id),
('Œufs Fermiers', 'Œufs de ferme traditionnelle', 'Fermier', NOW(), 'DISPONIBLE', @vendeur1_id);

SET @produit1_id = LAST_INSERT_ID() - 2;
SET @produit2_id = LAST_INSERT_ID() - 1;
SET @produit3_id = LAST_INSERT_ID();

-- Produits du Vendeur 2 (Eggs Express)
INSERT INTO produits (nom, description, type_oeuf, datecreation, disponibilite, vendeur_id)
VALUES 
('Œufs Blancs Standard', 'Œufs blancs frais du jour', 'Standard', NOW(), 'DISPONIBLE', @vendeur2_id),
('Œufs Bruns Standard', 'Œufs bruns frais', 'Standard', NOW(), 'DISPONIBLE', @vendeur2_id);

SET @produit4_id = LAST_INSERT_ID() - 1;
SET @produit5_id = LAST_INSERT_ID();

-- ==========================================
-- OFFRES PRODUITS
-- ==========================================
-- Offres pour les produits du Vendeur 1
INSERT INTO offre_produits (prix_unitaire, stock, unite_de_vente, disponibilite, datecreation, produit_id)
VALUES 
(150.00, 500, 'Unité', 'DISPONIBLE', NOW(), @produit1_id),
(1500.00, 50, 'Boîte de 12', 'DISPONIBLE', NOW(), @produit1_id),
(120.00, 800, 'Unité', 'DISPONIBLE', NOW(), @produit2_id),
(1200.00, 70, 'Boîte de 12', 'DISPONIBLE', NOW(), @produit2_id),
(100.00, 1000, 'Unité', 'DISPONIBLE', NOW(), @produit3_id);

-- Offres pour les produits du Vendeur 2
INSERT INTO offre_produits (prix_unitaire, stock, unite_de_vente, disponibilite, datecreation, produit_id)
VALUES 
(80.00, 2000, 'Unité', 'DISPONIBLE', NOW(), @produit4_id),
(800.00, 150, 'Boîte de 12', 'DISPONIBLE', NOW(), @produit4_id),
(85.00, 1500, 'Unité', 'DISPONIBLE', NOW(), @produit5_id),
(850.00, 120, 'Boîte de 12', 'DISPONIBLE', NOW(), @produit5_id);

-- ==========================================
-- ZONES DE LIVRAISON
-- ==========================================
-- Zones pour Vendeur 1
INSERT INTO zone_livraisons (nom_zone, prix_livraison, delais_estime, statut, vendeur_id)
VALUES 
('Yaoundé Centre', '500 FCFA', '30-45 minutes', 'ACTIVE', @vendeur1_id),
('Yaoundé Périphérie', '1000 FCFA', '1-2 heures', 'ACTIVE', @vendeur1_id);

-- Zones pour Vendeur 2
INSERT INTO zone_livraisons (nom_zone, prix_livraison, delais_estime, statut, vendeur_id)
VALUES 
('Douala Centre', '500 FCFA', '30-45 minutes', 'ACTIVE', @vendeur2_id),
('Douala Périphérie', '1000 FCFA', '1-2 heures', 'ACTIVE', @vendeur2_id);

-- ==========================================
-- COMMANDE EXEMPLE
-- ==========================================
INSERT INTO commandes (reference, date_commande, montant_total, statut, adresse_livraison, client_id)
VALUES ('CMD-TEST001', NOW(), 3050.00, 'CONFIRMEE', 'Yaoundé Nlongkak, Rue 1234', @client1_id);

SET @commande_test = LAST_INSERT_ID();

-- Lignes de commande
INSERT INTO ligne_commandes (quantite, prix_commande, sous_total, commande_id, offre_produit_id)
VALUES 
(2, 1500.00, 3000.00, @commande_test, 2),  -- 2 boîtes de 12 œufs bio XL
(1, 50.00, 50.00, @commande_test, 5);       -- 1 unité d'œuf fermier

-- Livraison pour cette commande
INSERT INTO livraisons (date_livraison, statut, frais_livraison, date_creation, commande_id, livreur_id)
VALUES (NULL, 'ASSIGNEE', '500 FCFA', NOW(), @commande_test, @livreur1_id);

-- Paiement pour cette commande
INSERT INTO paiements (methode, statut_montant, montant, date_paiement, transaction_id, commande_id)
VALUES ('MOBILE_MONEY', 'EN_ATTENTE', 3550.00, NOW(), 'TXN-' || UUID(), @commande_test);

-- ==========================================
-- FIN DU SCRIPT
-- ==========================================

-- Afficher un résumé
SELECT 'Base de données initialisée avec succès!' AS Message;
SELECT COUNT(*) AS 'Nombre d\'utilisateurs' FROM utilisateurs;
SELECT COUNT(*) AS 'Nombre de produits' FROM produits;
SELECT COUNT(*) AS 'Nombre d\'offres' FROM offre_produits;
SELECT COUNT(*) AS 'Nombre de commandes' FROM commandes;
