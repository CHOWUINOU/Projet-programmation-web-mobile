package com.eggdelivery.controller;

import com.eggdelivery.model.Produit;
import com.eggdelivery.service.ProduitService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/public")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
@Tag(name = "Public", description = "API accessible sans authentification")
public class PublicController {

    private final ProduitService produitService;

    @GetMapping("/produits")
    @Operation(summary = "Récupérer tous les produits disponibles publiquement")
    public ResponseEntity<List<Produit>> getAllProduits() {
        return ResponseEntity.ok(produitService.getAllProduits());
    }
}

