-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 05 fév. 2026 à 17:03
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `egg_delivery_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

CREATE TABLE `clients` (
  `preferences_livraison` varchar(255) DEFAULT NULL,
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `clients`
--

INSERT INTO `clients` (`preferences_livraison`, `id`) VALUES
(NULL, 2),
(NULL, 5);

-- --------------------------------------------------------

--
-- Structure de la table `commandes`
--

CREATE TABLE `commandes` (
  `id` bigint(20) NOT NULL,
  `adresse_livraison` varchar(255) NOT NULL,
  `date_commande` datetime(6) NOT NULL,
  `montant_total` decimal(38,2) NOT NULL,
  `reference` varchar(255) NOT NULL,
  `statut` enum('EN_ATTENTE','CONFIRMEE','EN_PREPARATION','PRETE','EN_LIVRAISON','LIVREE','ANNULEE') NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `vendeur_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `ligne_commandes`
--

CREATE TABLE `ligne_commandes` (
  `id` bigint(20) NOT NULL,
  `prix_commande` decimal(38,2) NOT NULL,
  `quantite` int(11) NOT NULL,
  `sous_total` decimal(38,2) NOT NULL,
  `commande_id` bigint(20) NOT NULL,
  `offre_produit_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `livraisons`
--

CREATE TABLE `livraisons` (
  `id` bigint(20) NOT NULL,
  `date_creation` datetime(6) NOT NULL,
  `date_livraison` datetime(6) DEFAULT NULL,
  `frais_livraison` varchar(255) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `statut` enum('EN_ATTENTE','ASSIGNEE','EN_COURS','LIVREE','ECHEC') NOT NULL,
  `commande_id` bigint(20) NOT NULL,
  `livreur_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `livreurs`
--

CREATE TABLE `livreurs` (
  `moyen_transport` varchar(255) DEFAULT NULL,
  `statut_livreur` enum('DISPONIBLE','EN_LIVRAISON','INDISPONIBLE') NOT NULL,
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `livreurs`
--

INSERT INTO `livreurs` (`moyen_transport`, `statut_livreur`, `id`) VALUES
('Moto', 'DISPONIBLE', 4),
('Moto', 'DISPONIBLE', 7);

-- --------------------------------------------------------

--
-- Structure de la table `offre_produits`
--

CREATE TABLE `offre_produits` (
  `id` bigint(20) NOT NULL,
  `datecreation` datetime(6) NOT NULL,
  `datemiseajour` datetime(6) DEFAULT NULL,
  `disponibilite` enum('DISPONIBLE','RUPTURE_STOCK','INDISPONIBLE') NOT NULL,
  `prix_unitaire` decimal(38,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `unite_de_vente` varchar(255) DEFAULT NULL,
  `produit_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `offre_produits`
--

INSERT INTO `offre_produits` (`id`, `datecreation`, `datemiseajour`, `disponibilite`, `prix_unitaire`, `stock`, `unite_de_vente`, `produit_id`) VALUES
(2, '2026-02-04 14:51:45.000000', '2026-02-04 14:51:45.000000', 'DISPONIBLE', 2500.00, 10, 'carton (12 plateaux)', 3),
(3, '2026-02-04 14:52:25.000000', '2026-02-04 14:52:25.000000', 'DISPONIBLE', 3000.00, 12, 'demi-carton (6 plateaux)', 2),
(4, '2026-02-04 16:06:44.000000', '2026-02-04 16:06:44.000000', 'DISPONIBLE', 5000.00, 12, 'carton (12 plateaux)', 4),
(5, '2026-02-04 16:17:33.000000', '2026-02-04 16:17:33.000000', 'DISPONIBLE', 1000.00, 3, 'plateau', 4);

-- --------------------------------------------------------

--
-- Structure de la table `paiements`
--

CREATE TABLE `paiements` (
  `id` bigint(20) NOT NULL,
  `date_paiement` datetime(6) NOT NULL,
  `methode` enum('ESPECES','CARTE_BANCAIRE','MOBILE_MONEY','VIREMENT') NOT NULL,
  `montant` decimal(38,2) NOT NULL,
  `statut_montant` enum('EN_ATTENTE','REUSSI','ECHOUE','REMBOURSE') NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `commande_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

CREATE TABLE `produits` (
  `id` bigint(20) NOT NULL,
  `datecreation` datetime(6) NOT NULL,
  `description` text DEFAULT NULL,
  `disponibilite` enum('DISPONIBLE','RUPTURE_STOCK','INDISPONIBLE') NOT NULL,
  `nom` varchar(255) NOT NULL,
  `type_oeuf` varchar(255) DEFAULT NULL,
  `vendeur_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`id`, `datecreation`, `description`, `disponibilite`, `nom`, `type_oeuf`, `vendeur_id`) VALUES
(2, '2026-02-04 14:50:48.000000', 'Ce sont des Oeufs doux de la prairie', 'DISPONIBLE', 'Ouefs dou', 'L', 6),
(3, '2026-02-04 14:51:29.000000', 'Oueufs tres bon a manger', 'DISPONIBLE', 'Ouefs Frais', 'XL', 6),
(4, '2026-02-04 16:06:25.000000', 'Bon ouefs du village', 'DISPONIBLE', 'Ouefs village', 'M', 6);

-- --------------------------------------------------------

--
-- Structure de la table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` bigint(20) NOT NULL,
  `role` enum('ROLE_CLIENT','ROLE_ADMIN','ROLE_VENDEUR','ROLE_LIVREUR') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role`) VALUES
(1, 'ROLE_VENDEUR'),
(2, 'ROLE_CLIENT'),
(3, 'ROLE_VENDEUR'),
(4, 'ROLE_LIVREUR'),
(5, 'ROLE_CLIENT'),
(6, 'ROLE_VENDEUR'),
(7, 'ROLE_LIVREUR');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id` bigint(20) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `confirmation_motdepasse` varchar(255) DEFAULT NULL,
  `datecreation` datetime(6) NOT NULL,
  `email` varchar(255) NOT NULL,
  `motdepasse` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `statut` enum('ACTIF','INACTIF','SUSPENDU') NOT NULL,
  `telephone` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `adresse`, `confirmation_motdepasse`, `datecreation`, `email`, `motdepasse`, `nom`, `statut`, `telephone`) VALUES
(1, 'Douala, akwa', NULL, '2026-02-02 13:31:23.000000', 'annaelle@gmail.com', '$2a$10$0px239cJHqSChLd4UQKqgujhZM5Oh1/iLu4Sni076vqSsv0GD2r4O', 'annaelle', 'ACTIF', '678986755'),
(2, 'douala,Nyalla', NULL, '2026-02-03 00:42:21.000000', 'dinera@gmail.com', '$2a$10$4QcefjG1fUYCTvfmLTGAXuXONlPLJSfUzpQJidvF3iIJ78Kc07x8W', 'dinera', 'ACTIF', '693875690'),
(3, 'douala, nyalle', NULL, '2026-02-03 00:44:05.000000', 'olmo@gmail.com', '$2a$10$vE4PR7ZUqhOO8Civ3z2q.OemmxiN6qZwo3nteaifSBoZ62HLhIQZ6', 'olmo', 'ACTIF', '693908672'),
(4, 'douala, nyalla', NULL, '2026-02-03 00:47:06.000000', 'danny@gmail.com', '$2a$10$.ziwLjX0l.41Zd7yjWwfl.qADahJWWrEiBrEsetGrekuCLXpFMUcG', 'danny', 'ACTIF', '689903455'),
(5, 'Douala.yassa', NULL, '2026-02-03 12:21:38.000000', 'user@gmail.com', '$2a$10$JTOLBQPm5X4ie1a6l5DREuza4907Ni0chw4MybwwE09PHJj6ySLiy', 'user', 'ACTIF', '698734567'),
(6, 'douala', NULL, '2026-02-03 12:40:12.000000', 'alice2@gmail.com', '$2a$10$vPzTNiir82htyFVFu/Uc9eGdGNJ9/HtF5qqCUOGXFhUXQt0.ITGbG', 'alice', 'ACTIF', '675489765'),
(7, 'marie@gmail.com', NULL, '2026-02-04 15:19:30.000000', 'mari@gmail.com', '$2a$10$gcYyx0wKZMGLpUvMxLD1UODTIXzQQC5spRMuK31U9UOtlNNbsvrSy', 'marie louis', 'ACTIF', '687908732');

-- --------------------------------------------------------

--
-- Structure de la table `vendeurs`
--

CREATE TABLE `vendeurs` (
  `description` varchar(255) DEFAULT NULL,
  `logo_boutique` varchar(255) DEFAULT NULL,
  `nom_boutique` varchar(255) DEFAULT NULL,
  `type_vente` varchar(255) DEFAULT NULL,
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vendeurs`
--

INSERT INTO `vendeurs` (`description`, `logo_boutique`, `nom_boutique`, `type_vente`, `id`) VALUES
('', NULL, 'annaelle', NULL, 1),
('', NULL, 'olmo', NULL, 3),
('je vends des oeufs et tres frais et arromatiser', '6_Capture d\'écran 2025-11-20 010430.png', 'Ferme ultra Douala 2', NULL, 6);

-- --------------------------------------------------------

--
-- Structure de la table `zone_livraisons`
--

CREATE TABLE `zone_livraisons` (
  `id` bigint(20) NOT NULL,
  `delais_estime` varchar(255) DEFAULT NULL,
  `nom_zone` varchar(255) NOT NULL,
  `prix_livraison` varchar(255) DEFAULT NULL,
  `statut` enum('ACTIVE','INACTIVE') NOT NULL,
  `vendeur_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `zone_offre_produit`
--

CREATE TABLE `zone_offre_produit` (
  `zone_livraison_id` bigint(20) NOT NULL,
  `offre_produit_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `commandes`
--
ALTER TABLE `commandes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_7puwjgv8euf3hgg9md3c392wd` (`reference`),
  ADD KEY `FKoib3exi3ry2spqi19i9qk4ey1` (`client_id`),
  ADD KEY `FKj3xobdq97dnrmj9fs05468w1` (`vendeur_id`);

--
-- Index pour la table `ligne_commandes`
--
ALTER TABLE `ligne_commandes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKrvg91xestg6qh7vh7c4iw8lca` (`commande_id`),
  ADD KEY `FKa86j5nis20lnxnnqwmcipwya1` (`offre_produit_id`);

--
-- Index pour la table `livraisons`
--
ALTER TABLE `livraisons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_cl0s55txmpstpjmyk13pjacat` (`commande_id`),
  ADD KEY `FKetihr3tgtypbgyfs2qpftehsi` (`livreur_id`);

--
-- Index pour la table `livreurs`
--
ALTER TABLE `livreurs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `offre_produits`
--
ALTER TABLE `offre_produits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK465xivlxn0mh9315qihmjr2bp` (`produit_id`);

--
-- Index pour la table `paiements`
--
ALTER TABLE `paiements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_tkx0ahv3fe1vnlgl0fk8v7x99` (`commande_id`),
  ADD UNIQUE KEY `UK_mp755ui7pdxxyis64cvdx75x2` (`transaction_id`);

--
-- Index pour la table `produits`
--
ALTER TABLE `produits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK44jvy9y7lox92c62sg1i04hph` (`vendeur_id`);

--
-- Index pour la table `user_roles`
--
ALTER TABLE `user_roles`
  ADD KEY `FKfcyyb2hb5c89klb6j22comi2w` (`user_id`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_6ldvumu3hqvnmmxy1b6lsxwqy` (`email`);

--
-- Index pour la table `vendeurs`
--
ALTER TABLE `vendeurs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `zone_livraisons`
--
ALTER TABLE `zone_livraisons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK3tro2hyq9h5od3d3q7o7gbflq` (`vendeur_id`);

--
-- Index pour la table `zone_offre_produit`
--
ALTER TABLE `zone_offre_produit`
  ADD KEY `FKrdd1w0bbehdbdya5bo37kw0sy` (`offre_produit_id`),
  ADD KEY `FKbff64mopxo09lldchijurfnh1` (`zone_livraison_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `commandes`
--
ALTER TABLE `commandes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `ligne_commandes`
--
ALTER TABLE `ligne_commandes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `livraisons`
--
ALTER TABLE `livraisons`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `offre_produits`
--
ALTER TABLE `offre_produits`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `paiements`
--
ALTER TABLE `paiements`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `produits`
--
ALTER TABLE `produits`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `zone_livraisons`
--
ALTER TABLE `zone_livraisons`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `FKryy5uqya668cermkbky8yjkqc` FOREIGN KEY (`id`) REFERENCES `utilisateurs` (`id`);

--
-- Contraintes pour la table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `FKml6493bb2myr7nol8wgsu02xx` FOREIGN KEY (`id`) REFERENCES `utilisateurs` (`id`);

--
-- Contraintes pour la table `commandes`
--
ALTER TABLE `commandes`
  ADD CONSTRAINT `FKj3xobdq97dnrmj9fs05468w1` FOREIGN KEY (`vendeur_id`) REFERENCES `vendeurs` (`id`),
  ADD CONSTRAINT `FKoib3exi3ry2spqi19i9qk4ey1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`);

--
-- Contraintes pour la table `ligne_commandes`
--
ALTER TABLE `ligne_commandes`
  ADD CONSTRAINT `FKa86j5nis20lnxnnqwmcipwya1` FOREIGN KEY (`offre_produit_id`) REFERENCES `offre_produits` (`id`),
  ADD CONSTRAINT `FKrvg91xestg6qh7vh7c4iw8lca` FOREIGN KEY (`commande_id`) REFERENCES `commandes` (`id`);

--
-- Contraintes pour la table `livraisons`
--
ALTER TABLE `livraisons`
  ADD CONSTRAINT `FKetihr3tgtypbgyfs2qpftehsi` FOREIGN KEY (`livreur_id`) REFERENCES `livreurs` (`id`),
  ADD CONSTRAINT `FKgr1hpl4grb7pf00fj2xf0caxf` FOREIGN KEY (`commande_id`) REFERENCES `commandes` (`id`);

--
-- Contraintes pour la table `livreurs`
--
ALTER TABLE `livreurs`
  ADD CONSTRAINT `FK86yoa2tgcc2bwrt2c28u2l3oq` FOREIGN KEY (`id`) REFERENCES `utilisateurs` (`id`);

--
-- Contraintes pour la table `offre_produits`
--
ALTER TABLE `offre_produits`
  ADD CONSTRAINT `FK465xivlxn0mh9315qihmjr2bp` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`id`);

--
-- Contraintes pour la table `paiements`
--
ALTER TABLE `paiements`
  ADD CONSTRAINT `FK9nk9m8et7flj8ilc0692d8xmp` FOREIGN KEY (`commande_id`) REFERENCES `commandes` (`id`);

--
-- Contraintes pour la table `produits`
--
ALTER TABLE `produits`
  ADD CONSTRAINT `FK44jvy9y7lox92c62sg1i04hph` FOREIGN KEY (`vendeur_id`) REFERENCES `vendeurs` (`id`);

--
-- Contraintes pour la table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `FKfcyyb2hb5c89klb6j22comi2w` FOREIGN KEY (`user_id`) REFERENCES `utilisateurs` (`id`);

--
-- Contraintes pour la table `vendeurs`
--
ALTER TABLE `vendeurs`
  ADD CONSTRAINT `FK7mhq9q4w212666vanqnx3ls3` FOREIGN KEY (`id`) REFERENCES `utilisateurs` (`id`);

--
-- Contraintes pour la table `zone_livraisons`
--
ALTER TABLE `zone_livraisons`
  ADD CONSTRAINT `FK3tro2hyq9h5od3d3q7o7gbflq` FOREIGN KEY (`vendeur_id`) REFERENCES `vendeurs` (`id`);

--
-- Contraintes pour la table `zone_offre_produit`
--
ALTER TABLE `zone_offre_produit`
  ADD CONSTRAINT `FKbff64mopxo09lldchijurfnh1` FOREIGN KEY (`zone_livraison_id`) REFERENCES `zone_livraisons` (`id`),
  ADD CONSTRAINT `FKrdd1w0bbehdbdya5bo37kw0sy` FOREIGN KEY (`offre_produit_id`) REFERENCES `offre_produits` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
