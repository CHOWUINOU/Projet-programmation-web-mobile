package com.eggdelivery.service;

import com.eggdelivery.model.Livraison;
import com.eggdelivery.model.Livreur;
import com.eggdelivery.repository.LivraisonRepository;
import com.eggdelivery.repository.LivreurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LivraisonService {

    private final LivraisonRepository livraisonRepository;
    private final LivreurRepository livreurRepository;

    public List<Livraison> getAllLivraisons() {
        return livraisonRepository.findAll();
    }

    public Livraison getLivraisonById(Long id) {
        return livraisonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Livraison non trouvée avec l'id: " + id));
    }

    public Livraison getLivraisonByCommandeId(Long commandeId) {
        return livraisonRepository.findByCommandeId(commandeId)
                .orElseThrow(() -> new RuntimeException("Livraison non trouvée pour la commande: " + commandeId));
    }

    public List<Livraison> getLivraisonsByLivreur(Long livreurId) {
        return livraisonRepository.findByLivreurId(livreurId);
    }

    @Transactional
    public Livraison assignerLivreur(Long livraisonId, Long livreurId) {
        Livraison livraison = getLivraisonById(livraisonId);
        Livreur livreur = livreurRepository.findById(livreurId)
                .orElseThrow(() -> new RuntimeException("Livreur non trouvé avec l'id: " + livreurId));

        if (livreur.getStatutLivreur() != Livreur.StatutLivreur.DISPONIBLE) {
            throw new RuntimeException("Le livreur n'est pas disponible");
        }

        livraison.setLivreur(livreur);
        livraison.setStatut(Livraison.StatutLivraison.ASSIGNEE);

        livreur.setStatutLivreur(Livreur.StatutLivreur.EN_LIVRAISON);
        livreurRepository.save(livreur);

        return livraisonRepository.save(livraison);
    }

    @Transactional
    public Livraison demarrerLivraison(Long id) {
        Livraison livraison = getLivraisonById(id);
        
        if (livraison.getStatut() != Livraison.StatutLivraison.ASSIGNEE) {
            throw new RuntimeException("La livraison n'est pas dans un état permettant de démarrer");
        }

        livraison.setStatut(Livraison.StatutLivraison.EN_COURS);
        return livraisonRepository.save(livraison);
    }

    @Transactional
    public Livraison terminerLivraison(Long id) {
        Livraison livraison = getLivraisonById(id);
        
        if (livraison.getStatut() != Livraison.StatutLivraison.EN_COURS) {
            throw new RuntimeException("La livraison n'est pas en cours");
        }

        livraison.setStatut(Livraison.StatutLivraison.LIVREE);
        livraison.setDateLivraison(LocalDateTime.now());

        if (livraison.getLivreur() != null) {
            Livreur livreur = livraison.getLivreur();
            livreur.setStatutLivreur(Livreur.StatutLivreur.DISPONIBLE);
            livreurRepository.save(livreur);
        }

        return livraisonRepository.save(livraison);
    }

    @Transactional
    public Livraison updatePosition(Long id, Double latitude, Double longitude) {
        Livraison livraison = getLivraisonById(id);
        livraison.setLatitude(latitude);
        livraison.setLongitude(longitude);
        return livraisonRepository.save(livraison);
    }

    public List<Livraison> getLivraisonsByStatut(Livraison.StatutLivraison statut) {
        return livraisonRepository.findByStatut(statut);
    }
}
