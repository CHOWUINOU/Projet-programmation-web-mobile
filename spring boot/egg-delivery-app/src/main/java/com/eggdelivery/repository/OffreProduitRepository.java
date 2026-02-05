package com.eggdelivery.repository;

import com.eggdelivery.model.OffreProduit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OffreProduitRepository extends JpaRepository<OffreProduit, Long> {
    List<OffreProduit> findByProduitId(Long produitId);
    List<OffreProduit> findByDisponibilite(OffreProduit.DisponibiliteOffre disponibilite);
    List<OffreProduit> findByStockGreaterThan(Integer stock);

}
