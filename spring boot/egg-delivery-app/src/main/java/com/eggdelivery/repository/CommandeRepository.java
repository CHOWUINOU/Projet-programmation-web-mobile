package com.eggdelivery.repository;

import com.eggdelivery.model.Client;
import com.eggdelivery.model.Commande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommandeRepository extends JpaRepository<Commande, Long> {
    List<Commande> findByClient(Client client);
    List<Commande> findByClientId(Long clientId);
    Optional<Commande> findByReference(String reference);
    List<Commande> findByStatut(Commande.StatutCommande statut);
    List<Commande> findByClientIdAndStatut(Long clientId, Commande.StatutCommande statut);
    List<Commande> findByVendeurId(Long vendeurId);
}
