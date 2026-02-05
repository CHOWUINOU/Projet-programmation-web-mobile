package com.eggdelivery.service;

import com.eggdelivery.dto.ProduitRequest;
import com.eggdelivery.model.Produit;
import com.eggdelivery.model.Vendeur;
import com.eggdelivery.repository.ProduitRepository;
import com.eggdelivery.repository.VendeurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProduitService {

    private final ProduitRepository produitRepository;
    private final VendeurRepository vendeurRepository;

    public List<Produit> getAllProduits() {
        return produitRepository.findAll();
    }

    public Produit getProduitById(Long id) {
        return produitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Produit non trouvé avec l'id: " + id));
    }

    public List<Produit> getProduitsByVendeur(Long vendeurId) {
        return produitRepository.findByVendeurId(vendeurId);
    }

    @Transactional
    public Produit createProduit(Long vendeurId, ProduitRequest produitRequest) {
        Vendeur vendeur = vendeurRepository.findById(vendeurId)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé avec l'id: " + vendeurId));

        Produit produit = new Produit();
        produit.setNom(produitRequest.getNom());
        produit.setDescription(produitRequest.getDescription());
        produit.setTypeOeuf(produitRequest.getTypeOeuf());
        produit.setVendeur(vendeur);
        produit.setDisponibilite(Produit.DisponibiliteProduit.DISPONIBLE);

        return produitRepository.save(produit);
    }

    @Transactional
    public Produit updateProduit(Long id, ProduitRequest produitRequest) {
        Produit produit = getProduitById(id);
        
        produit.setNom(produitRequest.getNom());
        produit.setDescription(produitRequest.getDescription());
        produit.setTypeOeuf(produitRequest.getTypeOeuf());

        return produitRepository.save(produit);
    }

    @Transactional
    public void deleteProduit(Long id) {
        if (!produitRepository.existsById(id)) {
            throw new RuntimeException("Produit non trouvé avec l'id: " + id);
        }
        produitRepository.deleteById(id);
    }

    public List<Produit> getProduitsByTypeOeuf(String typeOeuf) {
        return produitRepository.findByTypeOeuf(typeOeuf);
    }

    public List<Produit> getProduitsByVendeurEmail(String email) {
        Vendeur vendeur = vendeurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé"));
        return produitRepository.findByVendeurId(vendeur.getId());
    }

    public Produit createProduitByVendeurEmail(String email, ProduitRequest request) {
        Vendeur vendeur = vendeurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé"));
        return createProduit(vendeur.getId(), request);
    }


}
