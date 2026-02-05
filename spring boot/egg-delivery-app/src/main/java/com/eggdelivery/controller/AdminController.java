package com.eggdelivery.controller;

import com.eggdelivery.model.*;
import com.eggdelivery.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('ADMIN')")
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Admin", description = "API pour les administrateurs")
public class AdminController {

    private final UtilisateurService utilisateurService;
    private final CommandeService commandeService;
    private final LivraisonService livraisonService;
    private final ProduitService produitService;
    private final VendeurService vendeurService;
    private final LivreurService livreurService;

    // ========== UTILISATEURS ==========
    @GetMapping("/utilisateurs")
    @Operation(summary = "Récupérer tous les utilisateurs")
    public ResponseEntity<List<Utilisateur>> getAllUtilisateurs() {
        return ResponseEntity.ok(utilisateurService.getAllUtilisateurs());
    }

    @GetMapping("/utilisateurs/{id}")
    @Operation(summary = "Récupérer un utilisateur par ID")
    public ResponseEntity<Utilisateur> getUtilisateurById(@PathVariable Long id) {
        return ResponseEntity.ok(utilisateurService.getUtilisateurById(id));
    }

    @PutMapping("/utilisateurs/{id}/statut")
    @Operation(summary = "Modifier le statut d'un utilisateur")
    public ResponseEntity<Utilisateur> updateStatutUtilisateur(
            @PathVariable Long id,
            @RequestParam Utilisateur.StatutUtilisateur statut) {
        return ResponseEntity.ok(utilisateurService.updateStatut(id, statut));
    }

    @DeleteMapping("/utilisateurs/{id}")
    @Operation(summary = "Supprimer un utilisateur")
    public ResponseEntity<Void> deleteUtilisateur(@PathVariable Long id) {
        utilisateurService.deleteUtilisateur(id);
        return ResponseEntity.ok().build();
    }

    // ========== VENDEURS ==========
    @GetMapping("/vendeurs")
    @Operation(summary = "Récupérer tous les vendeurs")
    public ResponseEntity<List<Vendeur>> getAllVendeurs() {
        return ResponseEntity.ok(vendeurService.getAllVendeurs());
    }

    @PutMapping("/vendeurs/{id}/valider")
    @Operation(summary = "Valider un vendeur")
    public ResponseEntity<Vendeur> validerVendeur(@PathVariable Long id) {
        return ResponseEntity.ok(vendeurService.validerVendeur(id));
    }

    // ========== LIVREURS ==========
    @GetMapping("/livreurs")
    @Operation(summary = "Récupérer tous les livreurs")
    public ResponseEntity<List<Livreur>> getAllLivreurs() {
        return ResponseEntity.ok(livreurService.getAllLivreurs());
    }

    // ========== COMMANDES ==========
    @GetMapping("/commandes")
    @Operation(summary = "Récupérer toutes les commandes")
    public ResponseEntity<List<Commande>> getAllCommandes() {
        return ResponseEntity.ok(commandeService.getAllCommandes());
    }



    // ========== LIVRAISONS ==========
    @GetMapping("/livraisons")
    @Operation(summary = "Récupérer toutes les livraisons")
    public ResponseEntity<List<Livraison>> getAllLivraisons() {
        return ResponseEntity.ok(livraisonService.getAllLivraisons());
    }

    // ========== PRODUITS ==========
    @GetMapping("/produits")
    @Operation(summary = "Récupérer tous les produits")
    public ResponseEntity<List<Produit>> getAllProduits() {
        return ResponseEntity.ok(produitService.getAllProduits());
    }
}
