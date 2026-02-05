package com.eggdelivery.controller;

import com.eggdelivery.model.Commande;
import com.eggdelivery.model.Paiement;
import com.eggdelivery.repository.CommandeRepository;
import com.eggdelivery.repository.PaiementRepository;
import com.eggdelivery.security.UserDetailsImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/paiements")
@RequiredArgsConstructor
public class PaiementController {

    private final CommandeRepository commandeRepository;
    private final PaiementRepository paiementRepository;

    @PostMapping("/process")
    public ResponseEntity<Map<String, String>> processPaiement(
            @RequestBody Map<String, Object> request,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {

        Long commandeId = Long.valueOf(request.get("commandeId").toString());
        String methode = request.get("methode").toString();
        String phone = request.get("phone").toString();

        Commande commande = commandeRepository.findById(commandeId)
                .orElseThrow(() -> new RuntimeException("Commande non trouvée"));

        // Créer le paiement
        Paiement paiement = new Paiement();
        paiement.setCommande(commande);
        paiement.setMethode(Paiement.MethodePaiement.valueOf(methode.toUpperCase()));
        paiement.setMontant(commande.getMontantTotal());
        paiement.setDatePaiement(LocalDateTime.now());
        paiement.setTransactionId("TXN-" + UUID.randomUUID().toString().substring(0, 8));

        // Simuler le paiement (dans la réalité, intégrer une API de paiement)
        paiement.setStatutMontant(Paiement.StatutPaiement.REUSSI);

        paiementRepository.save(paiement);

        // Mettre à jour le statut de la commande
        commande.setStatut(Commande.StatutCommande.CONFIRMEE);
        commandeRepository.save(commande);

        return ResponseEntity.ok(Map.of(
                "status", "success",
                "message", "Paiement effectué avec succès",
                "transactionId", paiement.getTransactionId()
        ));
    }

    @GetMapping("/{commandeId}/status")
    public ResponseEntity<Map<String, Object>> getPaiementStatus(@PathVariable Long commandeId) {
        Paiement paiement = paiementRepository.findByCommandeId(commandeId)
                .orElseThrow(() -> new RuntimeException("Paiement non trouvé"));

        return ResponseEntity.ok(Map.of(
                "statut", paiement.getStatutMontant(),
                "methode", paiement.getMethode(),
                "montant", paiement.getMontant(),
                "date", paiement.getDatePaiement(),
                "transactionId", paiement.getTransactionId()
        ));
    }
}