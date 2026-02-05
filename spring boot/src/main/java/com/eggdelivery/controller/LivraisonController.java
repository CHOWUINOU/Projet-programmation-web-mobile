package com.eggdelivery.controller;

import com.eggdelivery.model.Livraison;
import com.eggdelivery.service.LivraisonService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/livraisons")
@RequiredArgsConstructor
@Tag(name = "Livraisons", description = "Gestion des livraisons")
@SecurityRequirement(name = "bearerAuth")
@CrossOrigin(origins = "*", maxAge = 3600)
public class LivraisonController {

    private final LivraisonService livraisonService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Liste toutes les livraisons (Admin)")
    public ResponseEntity<List<Livraison>> getAllLivraisons() {
        return ResponseEntity.ok(livraisonService.getAllLivraisons());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtenir une livraison par son ID")
    public ResponseEntity<Livraison> getLivraisonById(@PathVariable Long id) {
        return ResponseEntity.ok(livraisonService.getLivraisonById(id));
    }

    @GetMapping("/commande/{commandeId}")
    @Operation(summary = "Obtenir la livraison d'une commande")
    public ResponseEntity<Livraison> getLivraisonByCommande(@PathVariable Long commandeId) {
        return ResponseEntity.ok(livraisonService.getLivraisonByCommandeId(commandeId));
    }

    @GetMapping("/livreur/{livreurId}")
    @PreAuthorize("hasRole('LIVREUR') or hasRole('ADMIN')")
    @Operation(summary = "Liste les livraisons d'un livreur")
    public ResponseEntity<List<Livraison>> getLivraisonsByLivreur(@PathVariable Long livreurId) {
        return ResponseEntity.ok(livraisonService.getLivraisonsByLivreur(livreurId));
    }

    @GetMapping("/statut/{statut}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Liste les livraisons par statut")
    public ResponseEntity<List<Livraison>> getLivraisonsByStatut(@PathVariable Livraison.StatutLivraison statut) {
        return ResponseEntity.ok(livraisonService.getLivraisonsByStatut(statut));
    }

    @PutMapping("/{id}/assigner")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Assigner un livreur à une livraison")
    public ResponseEntity<Livraison> assignerLivreur(
            @PathVariable Long id,
            @RequestParam Long livreurId) {
        return ResponseEntity.ok(livraisonService.assignerLivreur(id, livreurId));
    }

    @PutMapping("/{id}/demarrer")
    @PreAuthorize("hasRole('LIVREUR')")
    @Operation(summary = "Démarrer une livraison")
    public ResponseEntity<Livraison> demarrerLivraison(@PathVariable Long id) {
        return ResponseEntity.ok(livraisonService.demarrerLivraison(id));
    }

    @PutMapping("/{id}/terminer")
    @PreAuthorize("hasRole('LIVREUR')")
    @Operation(summary = "Terminer une livraison")
    public ResponseEntity<Livraison> terminerLivraison(@PathVariable Long id) {
        return ResponseEntity.ok(livraisonService.terminerLivraison(id));
    }

    @PutMapping("/{id}/position")
    @PreAuthorize("hasRole('LIVREUR')")
    @Operation(summary = "Mettre à jour la position du livreur")
    public ResponseEntity<Livraison> updatePosition(
            @PathVariable Long id,
            @RequestParam Double latitude,
            @RequestParam Double longitude) {
        return ResponseEntity.ok(livraisonService.updatePosition(id, latitude, longitude));
    }
}
