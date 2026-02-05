package com.eggdelivery.controller;

import com.eggdelivery.dto.OffreProduitRequest;
import com.eggdelivery.dto.ProduitRequest;
import com.eggdelivery.dto.VendeurBoutiqueRequest;
import com.eggdelivery.model.Commande;
import com.eggdelivery.model.OffreProduit;
import com.eggdelivery.model.Produit;
import com.eggdelivery.model.Vendeur;
import com.eggdelivery.model.Utilisateur;
import com.eggdelivery.repository.VendeurRepository;
import com.eggdelivery.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/vendeur")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('VENDEUR')")
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Vendeur", description = "API pour les vendeurs")
public class VendeurController {

    private final ProduitService produitService;
    private final OffreProduitService offreProduitService;
    private final CommandeService commandeService;

    private final VendeurService vendeurService;
    private  final UtilisateurService utilisateurService;

    private final VendeurRepository vendeurRepository;

    // ========== PRODUITS ==========
    @GetMapping("/produits")
    public ResponseEntity<List<Produit>> getMesProduits(Authentication authentication) {
        String email = authentication.getName();
        return ResponseEntity.ok(produitService.getProduitsByVendeurEmail(email));
    }

    @PostMapping("/produits")
    public ResponseEntity<Produit> createProduit(
            Authentication authentication,
            @RequestBody ProduitRequest produitRequest) {

        String email = authentication.getName();
        return ResponseEntity.ok(
                produitService.createProduitByVendeurEmail(email, produitRequest)
        );
    }

    @PutMapping("/produits/{id}")
    @Operation(summary = "Modifier un produit")
    public ResponseEntity<Produit> updateProduit(
            @PathVariable Long id,
            @RequestBody ProduitRequest produitRequest) {
        return ResponseEntity.ok(produitService.updateProduit(id, produitRequest));
    }

    @DeleteMapping("/produits/{id}")
    @Operation(summary = "Supprimer un produit")
    public ResponseEntity<Void> deleteProduit(@PathVariable Long id) {
        produitService.deleteProduit(id);
        return ResponseEntity.ok().build();
    }

    // ========== OFFRES ==========
    @GetMapping("/offres")
    @Operation(summary = "Récupérer toutes les offres")
    public ResponseEntity<List<OffreProduit>> getAllOffres() {
        return ResponseEntity.ok(offreProduitService.getAllOffres());
    }

    @GetMapping("/produits/{produitId}/offres")
    @Operation(summary = "Récupérer les offres d'un produit")
    public ResponseEntity<List<OffreProduit>> getOffresByProduit(@PathVariable Long produitId) {
        return ResponseEntity.ok(offreProduitService.getOffresByProduit(produitId));
    }

    @PostMapping("/offres")
    @Operation(summary = "Créer une nouvelle offre")
    public ResponseEntity<OffreProduit> createOffre(@RequestBody OffreProduitRequest offreRequest) {
        return ResponseEntity.ok(offreProduitService.createOffre(offreRequest));
    }

    @PutMapping("/offres/{id}")
    @Operation(summary = "Modifier une offre")
    public ResponseEntity<OffreProduit> updateOffre(
            @PathVariable Long id,
            @RequestBody OffreProduitRequest offreRequest) {
        return ResponseEntity.ok(offreProduitService.updateOffre(id, offreRequest));
    }

    @DeleteMapping("/offres/{id}")
    @Operation(summary = "Supprimer une offre")
    public ResponseEntity<Void> deleteOffre(@PathVariable Long id) {
        offreProduitService.deleteOffre(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/offres/{id}/stock")
    @Operation(summary = "Mettre à jour le stock d'une offre")
    public ResponseEntity<OffreProduit> updateStock(
            @PathVariable Long id,
            @RequestParam Integer nouveauStock) {
        return ResponseEntity.ok(offreProduitService.updateStock(id, nouveauStock));
    }

    // ========== COMMANDES ==========
    @GetMapping("/commandes")
    public ResponseEntity<List<Commande>> getCommandesRecues(Authentication authentication) {
        String email = authentication.getName();
        return ResponseEntity.ok(commandeService.getCommandesByVendeurEmail(email));
    }

    @PutMapping("/commandes/{id}/statut")
    @Operation(summary = "Mettre à jour le statut d'une commande")
    public ResponseEntity<Commande> updateStatutCommande(
            @PathVariable Long id,
            @RequestParam Commande.StatutCommande statut) {
        return ResponseEntity.ok(commandeService.updateStatutCommande(id, statut));
    }


    // ======== BOUTIQUE ========

    @GetMapping("/boutique")
    public ResponseEntity<Vendeur> getMaBoutique(Authentication authentication) {
        String email = authentication.getName();
        return ResponseEntity.ok(vendeurService.getBoutiqueByEmail(email));
    }


    @PutMapping("/boutique")
    public ResponseEntity<Vendeur> updateBoutique(
            Authentication authentication,
            @RequestParam(required = false) String nomBoutique,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String telephone,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String adresse,
            @RequestParam(required = false) MultipartFile photo) throws IOException {

        String userEmail = authentication.getName();
        Vendeur vendeur = vendeurRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé"));

        VendeurBoutiqueRequest dto = new VendeurBoutiqueRequest();
        dto.setNomBoutique(nomBoutique);
        dto.setDescription(description);
        dto.setTelephone(telephone);
        //dto.setEmail(email);
        dto.setAdresse(adresse);
        dto.setPhoto(photo);

        Vendeur updated = vendeurService.updateBoutique(vendeur.getId(), dto);
        return ResponseEntity.ok(updated);
    }
}
