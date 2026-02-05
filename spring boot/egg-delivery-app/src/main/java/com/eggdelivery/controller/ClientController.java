package com.eggdelivery.controller;

import com.eggdelivery.dto.CommandeRequest;
import com.eggdelivery.model.Commande;
import com.eggdelivery.model.Utilisateur;
import com.eggdelivery.service.CommandeService;
import com.eggdelivery.service.ProduitService;
import com.eggdelivery.model.Produit;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/client")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Client", description = "API pour les clients")
public class ClientController {

    private final CommandeService commandeService;
    private final ProduitService produitService;

    @GetMapping("/produits")
    @Operation(summary = "Récupérer tous les produits disponibles")
    @PreAuthorize("permitAll()")
    public ResponseEntity<List<Produit>> getAllProduits() {
        return ResponseEntity.ok(produitService.getAllProduits());
    }


    @GetMapping("/produits/{id}")
    @Operation(summary = "Récupérer un produit par ID")
    @PreAuthorize("permitAll()")
    public ResponseEntity<Produit> getProduitById(@PathVariable Long id) {
        return ResponseEntity.ok(produitService.getProduitById(id));
    }

    @GetMapping("/commandes")
    @Operation(summary = "Récupérer les commandes du client connecté")
    @PreAuthorize("hasRole('CLIENT')")
    public ResponseEntity<List<Commande>> getMesCommandes(Authentication authentication) {

        String email = authentication.getName(); // depuis le JWT
        return ResponseEntity.ok(commandeService.getCommandesByEmail(email));
    }

    @PostMapping("/commandes")
    @Operation(summary = "Créer une nouvelle commande")
    @PreAuthorize("hasRole('CLIENT')")
    public ResponseEntity<Commande> createCommande(
            Authentication authentication,
            @RequestBody CommandeRequest commandeRequest) {

        String email = authentication.getName();
        return ResponseEntity.ok(
                commandeService.createCommandeByEmail(email, commandeRequest)
        );
    }

    @GetMapping("/commandes/{id}")
    @Operation(summary = "Récupérer une commande par ID")
    @PreAuthorize("hasRole('CLIENT')")
    public ResponseEntity<Commande> getCommandeById(@PathVariable Long id) {
        return ResponseEntity.ok(commandeService.getCommandeById(id));
    }

    @PutMapping("/commandes/{id}/annuler")
    @Operation(summary = "Annuler une commande")
    @PreAuthorize("hasRole('CLIENT')")
    public ResponseEntity<Void> cancelCommande(@PathVariable Long id) {
        commandeService.cancelCommande(id);
        return ResponseEntity.ok().build();
    }
}
