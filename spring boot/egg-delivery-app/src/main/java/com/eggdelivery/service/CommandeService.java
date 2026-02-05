package com.eggdelivery.service;

import com.eggdelivery.dto.CommandeRequest;
import com.eggdelivery.model.*;
import com.eggdelivery.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CommandeService {

    private final CommandeRepository commandeRepository;
    private final ClientRepository clientRepository;
    private final OffreProduitRepository offreProduitRepository;
    private final LigneCommandeRepository ligneCommandeRepository;
    private final LivraisonRepository livraisonRepository;

    private final VendeurRepository vendeurRepository;

    public List<Commande> getAllCommandes() {
        return commandeRepository.findAll();
    }

    public Commande getCommandeById(Long id) {
        return commandeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Commande non trouvée avec l'id: " + id));
    }

    public List<Commande> getCommandesByClient(Long clientId) {
        return commandeRepository.findByClientId(clientId);
    }

    @Transactional
    public Commande createCommande(Long clientId, CommandeRequest commandeRequest) {
        Client client = clientRepository.findById(clientId)
                .orElseThrow(() -> new RuntimeException("Client non trouvé avec l'id: " + clientId));

        // Créer la commande
        Commande commande = new Commande();
        commande.setReference("CMD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        commande.setClient(client);
        commande.setAdresseLivraison(commandeRequest.getAdresseLivraison());
        commande.setStatut(Commande.StatutCommande.EN_ATTENTE);
        commande.setMontantTotal(BigDecimal.ZERO);

        // Créer les lignes de commande
        List<LigneCommande> lignesCommande = new ArrayList<>();
        BigDecimal montantTotal = BigDecimal.ZERO;

        for (CommandeRequest.LigneCommandeRequest ligneRequest : commandeRequest.getLignesCommande()) {
            OffreProduit offreProduit = offreProduitRepository.findById(ligneRequest.getOffreProduitId())
                    .orElseThrow(() -> new RuntimeException("Offre produit non trouvée"));

            // Vérifier le stock
            if (offreProduit.getStock() < ligneRequest.getQuantite()) {
                throw new RuntimeException("Stock insuffisant pour le produit: " + offreProduit.getProduit().getNom());
            }

            LigneCommande ligne = new LigneCommande();
            ligne.setCommande(commande);
            ligne.setOffreProduit(offreProduit);
            ligne.setQuantite(ligneRequest.getQuantite());
            ligne.setPrixCommande(offreProduit.getPrixUnitaire());
            ligne.calculerSousTotal();

            lignesCommande.add(ligne);
            montantTotal = montantTotal.add(ligne.getSousTotal());

            // Mettre à jour le stock
            offreProduit.setStock(offreProduit.getStock() - ligneRequest.getQuantite());
            offreProduitRepository.save(offreProduit);
        }

        commande.setLignesCommande(lignesCommande);
        commande.setMontantTotal(montantTotal);

        // Sauvegarder la commande
        Commande savedCommande = commandeRepository.save(commande);

        // Créer une livraison associée
        Livraison livraison = new Livraison();
        livraison.setCommande(savedCommande);
        livraison.setStatut(Livraison.StatutLivraison.EN_ATTENTE);
        livraisonRepository.save(livraison);

        return savedCommande;
    }

    @Transactional
    public Commande updateStatutCommande(Long id, Commande.StatutCommande nouveauStatut) {
        Commande commande = getCommandeById(id);
        commande.setStatut(nouveauStatut);
        return commandeRepository.save(commande);
    }

    @Transactional
    public void cancelCommande(Long id) {
        Commande commande = getCommandeById(id);
        
        if (commande.getStatut() != Commande.StatutCommande.EN_ATTENTE &&
            commande.getStatut() != Commande.StatutCommande.CONFIRMEE) {
            throw new RuntimeException("Cette commande ne peut plus être annulée");
        }

        // Remettre les stocks
        for (LigneCommande ligne : commande.getLignesCommande()) {
            OffreProduit offre = ligne.getOffreProduit();
            offre.setStock(offre.getStock() + ligne.getQuantite());
            offreProduitRepository.save(offre);
        }

        commande.setStatut(Commande.StatutCommande.ANNULEE);
        commandeRepository.save(commande);
    }

    public List<Commande> getCommandesByStatut(Commande.StatutCommande statut) {
        return commandeRepository.findByStatut(statut);
    }

    public List<Commande> getCommandesByEmail(String email) {
        Client client = clientRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Client non trouvé"));

        return commandeRepository.findByClientId(client.getId());
    }

    @Transactional
    public Commande createCommandeByEmail(String email, CommandeRequest request) {
        Client client = clientRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Client non trouvé"));

        return createCommande(client.getId(), request);
    }
    public List<Commande> getCommandesByVendeurEmail(String email) {
        Vendeur vendeur = vendeurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé"));

        return commandeRepository.findByVendeurId(vendeur.getId());
    }
}
