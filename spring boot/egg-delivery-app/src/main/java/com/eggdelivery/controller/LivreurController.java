package com.eggdelivery.controller;

import com.eggdelivery.model.Livraison;
import com.eggdelivery.model.Livreur;
import com.eggdelivery.service.LivraisonService;
import com.eggdelivery.service.LivreurService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/livreur")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('LIVREUR')")
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Livreur", description = "API pour les livreurs")
public class LivreurController {

    private final LivraisonService livraisonService;
    private final LivreurService livreurService;

    @GetMapping("/livraisons/disponibles")
    @Operation(summary = "Récupérer les livraisons disponibles")
    public ResponseEntity<List<Livraison>> getLivraisonsDisponibles() {
        return ResponseEntity.ok(livraisonService.getLivraisonsByStatut(Livraison.StatutLivraison.EN_ATTENTE));
    }

    @GetMapping("/livraisons")
    @Operation(summary = "Récupérer mes livraisons")
    public ResponseEntity<List<Livraison>> getMesLivraisons(@RequestParam Long livreurId) {
        return ResponseEntity.ok(livraisonService.getLivraisonsByLivreur(livreurId));
    }

    @GetMapping("/livraisons/{id}")
    @Operation(summary = "Récupérer une livraison par ID")
    public ResponseEntity<Livraison> getLivraisonById(@PathVariable Long id) {
        return ResponseEntity.ok(livraisonService.getLivraisonById(id));
    }

    @PostMapping("/livraisons/{id}/accepter")
    @Operation(summary = "Accepter une livraison")
    public ResponseEntity<Livraison> accepterLivraison(
            @PathVariable Long id,
            @RequestParam Long livreurId) {
        return ResponseEntity.ok(livraisonService.assignerLivreur(id, livreurId));
    }

    @PostMapping("/livraisons/{id}/demarrer")
    @Operation(summary = "Démarrer une livraison")
    public ResponseEntity<Livraison> demarrerLivraison(@PathVariable Long id) {
        return ResponseEntity.ok(livraisonService.demarrerLivraison(id));
    }

    @PostMapping("/livraisons/{id}/terminer")
    @Operation(summary = "Terminer une livraison")
    public ResponseEntity<Livraison> terminerLivraison(@PathVariable Long id) {
        return ResponseEntity.ok(livraisonService.terminerLivraison(id));
    }

    @PutMapping("/livraisons/{id}/position")
    @Operation(summary = "Mettre à jour la position du livreur")
    public ResponseEntity<Livraison> updatePosition(
            @PathVariable Long id,
            @RequestParam Double latitude,
            @RequestParam Double longitude) {
        return ResponseEntity.ok(livraisonService.updatePosition(id, latitude, longitude));
    }

    @GetMapping("/statut")
    @Operation(summary = "Récupérer le statut du livreur")
    public ResponseEntity<Livreur.StatutLivreur> getStatutLivreur(@RequestParam Long livreurId) {
        Livreur livreur = livreurService.getLivreurById(livreurId);
        return ResponseEntity.ok(livreur.getStatutLivreur());
    }

    @PutMapping("/statut")
    @Operation(summary = "Mettre à jour le statut du livreur")
    public ResponseEntity<Void> updateStatutLivreur(
            @RequestParam Long livreurId,
            @RequestParam Livreur.StatutLivreur statut) {
        livreurService.updateStatut(livreurId, statut);
        return ResponseEntity.ok().build();
    }
}
