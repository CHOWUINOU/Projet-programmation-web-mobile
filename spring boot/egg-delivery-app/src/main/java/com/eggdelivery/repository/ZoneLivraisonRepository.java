package com.eggdelivery.repository;

import com.eggdelivery.model.ZoneLivraison;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ZoneLivraisonRepository extends JpaRepository<ZoneLivraison, Long> {
    List<ZoneLivraison> findByVendeurId(Long vendeurId);
    List<ZoneLivraison> findByStatut(ZoneLivraison.StatutZone statut);
}
