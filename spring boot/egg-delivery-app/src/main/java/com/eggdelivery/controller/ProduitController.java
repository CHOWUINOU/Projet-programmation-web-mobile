package com.eggdelivery.controller;

import com.eggdelivery.dto.ProduitRequest;
import com.eggdelivery.model.Produit;
import com.eggdelivery.service.ProduitService;
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
@RequestMapping("/api/produits")
@RequiredArgsConstructor
@Tag(name = "Produits", description = "Gestion des produits")
@SecurityRequirement(name = "bearerAuth")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ProduitController {

    private final ProduitService produitService;

    @GetMapping
    @Operation(summary = "Liste tous les produits")
    public ResponseEntity<List<Produit>> getAllProduits() {
        return ResponseEntity.ok(produitService.getAllProduits());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtenir un produit par son ID")
    public ResponseEntity<Produit> getProduitById(@PathVariable Long id) {
        return ResponseEntity.ok(produitService.getProduitById(id));
    }

    @GetMapping("/vendeur/{vendeurId}")
    @Operation(summary = "Liste les produits d'un vendeur")
    public ResponseEntity<List<Produit>> getProduitsByVendeur(@PathVariable Long vendeurId) {
        return ResponseEntity.ok(produitService.getProduitsByVendeur(vendeurId));
    }

    @GetMapping("/type/{typeOeuf}")
    @Operation(summary = "Liste les produits par type d'œuf")
    public ResponseEntity<List<Produit>> getProduitsByType(@PathVariable String typeOeuf) {
        return ResponseEntity.ok(produitService.getProduitsByTypeOeuf(typeOeuf));
    }

    @PostMapping("/vendeur/{vendeurId}")
    @PreAuthorize("hasRole('VENDEUR') or hasRole('ADMIN')")
    @Operation(summary = "Créer un nouveau produit")
    public ResponseEntity<Produit> createProduit(
            @PathVariable Long vendeurId,
            @Valid @RequestBody ProduitRequest produitRequest) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(produitService.createProduit(vendeurId, produitRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('VENDEUR') or hasRole('ADMIN')")
    @Operation(summary = "Mettre à jour un produit")
    public ResponseEntity<Produit> updateProduit(
            @PathVariable Long id,
            @Valid @RequestBody ProduitRequest produitRequest) {
        return ResponseEntity.ok(produitService.updateProduit(id, produitRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('VENDEUR') or hasRole('ADMIN')")
    @Operation(summary = "Supprimer un produit")
    public ResponseEntity<Void> deleteProduit(@PathVariable Long id) {
        produitService.deleteProduit(id);
        return ResponseEntity.noContent().build();
    }
}
