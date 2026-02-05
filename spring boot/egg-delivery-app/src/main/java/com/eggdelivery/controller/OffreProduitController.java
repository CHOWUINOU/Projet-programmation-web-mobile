package com.eggdelivery.controller;

import com.eggdelivery.dto.OffreProduitRequest;
import com.eggdelivery.model.OffreProduit;
import com.eggdelivery.service.OffreProduitService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/offres")
@RequiredArgsConstructor
@Tag(name = "Offres Produits", description = "Gestion des offres de produits")
@SecurityRequirement(name = "bearerAuth")
@CrossOrigin(origins = "*", maxAge = 3600)
public class OffreProduitController {

    private final OffreProduitService offreProduitService;

    @GetMapping
    @Operation(summary = "Liste toutes les offres")
    public ResponseEntity<List<OffreProduit>> getAllOffres() {
        return ResponseEntity.ok(offreProduitService.getAllOffres());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtenir une offre par son ID")
    public ResponseEntity<OffreProduit> getOffreById(@PathVariable Long id) {
        return ResponseEntity.ok(offreProduitService.getOffreById(id));
    }

    @GetMapping("/produit/{produitId}")
    @Operation(summary = "Liste les offres d'un produit")
    public ResponseEntity<List<OffreProduit>> getOffresByProduit(@PathVariable Long produitId) {
        return ResponseEntity.ok(offreProduitService.getOffresByProduit(produitId));
    }

    @PostMapping
    @PreAuthorize("hasRole('VENDEUR') or hasRole('ADMIN')")
    @Operation(summary = "Créer une nouvelle offre")
    public ResponseEntity<OffreProduit> createOffre(@Valid @RequestBody OffreProduitRequest offreRequest) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(offreProduitService.createOffre(offreRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('VENDEUR') or hasRole('ADMIN')")
    @Operation(summary = "Mettre à jour une offre")
    public ResponseEntity<OffreProduit> updateOffre(
            @PathVariable Long id,
            @Valid @RequestBody OffreProduitRequest offreRequest) {
        return ResponseEntity.ok(offreProduitService.updateOffre(id, offreRequest));
    }

    @PutMapping("/{id}/stock")
    @PreAuthorize("hasRole('VENDEUR') or hasRole('ADMIN')")
    @Operation(summary = "Mettre à jour le stock d'une offre")
    public ResponseEntity<OffreProduit> updateStock(
            @PathVariable Long id,
            @RequestParam Integer stock) {
        return ResponseEntity.ok(offreProduitService.updateStock(id, stock));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('VENDEUR') or hasRole('ADMIN')")
    @Operation(summary = "Supprimer une offre")
    public ResponseEntity<Void> deleteOffre(@PathVariable Long id) {
        offreProduitService.deleteOffre(id);
        return ResponseEntity.noContent().build();
    }
}
