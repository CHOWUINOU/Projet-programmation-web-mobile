package com.eggdelivery.repository;

import com.eggdelivery.model.Produit;
import com.eggdelivery.model.Vendeur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProduitRepository extends JpaRepository<Produit, Long> {
    List<Produit> findByVendeur(Vendeur vendeur);
    List<Produit> findByVendeurId(Long vendeurId);
    List<Produit> findByDisponibilite(Produit.DisponibiliteProduit disponibilite);
    List<Produit> findByTypeOeuf(String typeOeuf);
}
