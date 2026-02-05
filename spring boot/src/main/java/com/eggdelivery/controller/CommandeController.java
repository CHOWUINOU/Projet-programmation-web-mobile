package com.eggdelivery.controller;

import com.eggdelivery.dto.CommandeRequest;
import com.eggdelivery.model.Commande;
import com.eggdelivery.service.CommandeService;
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
@RequestMapping("/api/commandes")
@RequiredArgsConstructor
@Tag(name = "Commandes", description = "Gestion des commandes")
@SecurityRequirement(name = "bearerAuth")
@CrossOrigin(origins = "*", maxAge = 3600)
public class CommandeController {

    private final CommandeService commandeService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Liste toutes les commandes (Admin)")
    public ResponseEntity<List<Commande>> getAllCommandes() {
        return ResponseEntity.ok(commandeService.getAllCommandes());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtenir une commande par son ID")
    public ResponseEntity<Commande> getCommandeById(@PathVariable Long id) {
        return ResponseEntity.ok(commandeService.getCommandeById(id));
    }

    @GetMapping("/client/{clientId}")
    @PreAuthorize("hasRole('CLIENT') or hasRole('ADMIN')")
    @Operation(summary = "Liste les commandes d'un client")
    public ResponseEntity<List<Commande>> getCommandesByClient(@PathVariable Long clientId) {
        return ResponseEntity.ok(commandeService.getCommandesByClient(clientId));
    }

    @GetMapping("/statut/{statut}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDEUR')")
    @Operation(summary = "Liste les commandes par statut")
    public ResponseEntity<List<Commande>> getCommandesByStatut(@PathVariable Commande.StatutCommande statut) {
        return ResponseEntity.ok(commandeService.getCommandesByStatut(statut));
    }

    @PostMapping("/client/{clientId}")
    @PreAuthorize("hasRole('CLIENT')")
    @Operation(summary = "Créer une nouvelle commande")
    public ResponseEntity<Commande> createCommande(
            @PathVariable Long clientId,
            @Valid @RequestBody CommandeRequest commandeRequest) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(commandeService.createCommande(clientId, commandeRequest));
    }

    @PutMapping("/{id}/statut")
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDEUR')")
    @Operation(summary = "Mettre à jour le statut d'une commande")
    public ResponseEntity<Commande> updateStatut(
            @PathVariable Long id,
            @RequestParam Commande.StatutCommande statut) {
        return ResponseEntity.ok(commandeService.updateStatutCommande(id, statut));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('CLIENT') or hasRole('ADMIN')")
    @Operation(summary = "Annuler une commande")
    public ResponseEntity<Void> cancelCommande(@PathVariable Long id) {
        commandeService.cancelCommande(id);
        return ResponseEntity.noContent().build();
    }
}
