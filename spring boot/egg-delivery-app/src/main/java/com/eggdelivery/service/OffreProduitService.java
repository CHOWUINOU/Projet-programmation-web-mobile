package com.eggdelivery.service;

import com.eggdelivery.dto.OffreProduitRequest;
import com.eggdelivery.model.OffreProduit;
import com.eggdelivery.model.Produit;
import com.eggdelivery.repository.OffreProduitRepository;
import com.eggdelivery.repository.ProduitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OffreProduitService {

    private final OffreProduitRepository offreProduitRepository;
    private final ProduitRepository produitRepository;

    public List<OffreProduit> getAllOffres() {
        return offreProduitRepository.findAll();
    }

    public OffreProduit getOffreById(Long id) {
        return offreProduitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Offre non trouvée avec l'id: " + id));
    }

    public List<OffreProduit> getOffresByProduit(Long produitId) {
        return offreProduitRepository.findByProduitId(produitId);
    }

    @Transactional
    public OffreProduit createOffre(OffreProduitRequest offreRequest) {
        Produit produit = produitRepository.findById(offreRequest.getProduitId())
                .orElseThrow(() -> new RuntimeException("Produit non trouvé avec l'id: " + offreRequest.getProduitId()));

        OffreProduit offre = new OffreProduit();
        offre.setProduit(produit);
        offre.setPrixUnitaire(offreRequest.getPrixUnitaire());
        offre.setStock(offreRequest.getStock());
        offre.setUniteDeVente(offreRequest.getUniteDeVente());
        offre.setDisponibilite(OffreProduit.DisponibiliteOffre.DISPONIBLE);

        return offreProduitRepository.save(offre);
    }

    @Transactional
    public OffreProduit updateOffre(Long id, OffreProduitRequest offreRequest) {
        OffreProduit offre = getOffreById(id);
        
        offre.setPrixUnitaire(offreRequest.getPrixUnitaire());
        offre.setStock(offreRequest.getStock());
        offre.setUniteDeVente(offreRequest.getUniteDeVente());

        return offreProduitRepository.save(offre);
    }

    @Transactional
    public void deleteOffre(Long id) {
        if (!offreProduitRepository.existsById(id)) {
            throw new RuntimeException("Offre non trouvée avec l'id: " + id);
        }
        offreProduitRepository.deleteById(id);
    }

    @Transactional
    public OffreProduit updateStock(Long id, Integer nouveauStock) {
        OffreProduit offre = getOffreById(id);
        offre.setStock(nouveauStock);
        
        if (nouveauStock == 0) {
            offre.setDisponibilite(OffreProduit.DisponibiliteOffre.RUPTURE_STOCK);
        } else {
            offre.setDisponibilite(OffreProduit.DisponibiliteOffre.DISPONIBLE);
        }

        return offreProduitRepository.save(offre);
    }
}
