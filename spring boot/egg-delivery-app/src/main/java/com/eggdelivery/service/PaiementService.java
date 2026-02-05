package com.eggdelivery.service;

import com.eggdelivery.model.Paiement;
import com.eggdelivery.repository.PaiementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaiementService {

    private final PaiementRepository paiementRepository;

    public List<Paiement> getAllPaiements() {
        return paiementRepository.findAll();
    }

    public Paiement getPaiementById(Long id) {
        return paiementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Paiement non trouvé avec l'id: " + id));
    }

    public Paiement getPaiementByCommandeId(Long commandeId) {
        return paiementRepository.findByCommandeId(commandeId)
                .orElseThrow(() -> new RuntimeException("Paiement non trouvé pour la commande: " + commandeId));
    }

    public List<Paiement> getPaiementsByStatut(Paiement.StatutPaiement statut) {
        return paiementRepository.findByStatutMontant(statut);
    }

    @Transactional
    public Paiement createPaiement(Long commandeId, Paiement.MethodePaiement methode, BigDecimal montant) {
        Paiement paiement = new Paiement();
        paiement.setCommande(null); // À définir avec la commande
        paiement.setMethode(methode);
        paiement.setMontant(montant);
        paiement.setStatutMontant(Paiement.StatutPaiement.EN_ATTENTE);
        paiement.setTransactionId("TXN-" + UUID.randomUUID().toString().substring(0, 16).toUpperCase());
        return paiementRepository.save(paiement);
    }

    @Transactional
    public Paiement updateStatutPaiement(Long id, Paiement.StatutPaiement statut) {
        Paiement paiement = getPaiementById(id);
        paiement.setStatutMontant(statut);
        return paiementRepository.save(paiement);
    }

    @Transactional
    public Paiement confirmerPaiement(Long id) {
        Paiement paiement = getPaiementById(id);
        paiement.setStatutMontant(Paiement.StatutPaiement.REUSSI);
        return paiementRepository.save(paiement);
    }

    @Transactional
    public Paiement rembourserPaiement(Long id) {
        Paiement paiement = getPaiementById(id);
        paiement.setStatutMontant(Paiement.StatutPaiement.REMBOURSE);
        return paiementRepository.save(paiement);
    }
}
