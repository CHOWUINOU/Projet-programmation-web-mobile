package com.eggdelivery.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "ligne_commandes")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LigneCommande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer quantite;

    @Column(name = "prix_commande", nullable = false)
    private BigDecimal prixCommande;

    @Column(name = "sous_total", nullable = false)
    private BigDecimal sousTotal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "commande_id", nullable = false)
    private Commande commande;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "offre_produit_id", nullable = false)
    private OffreProduit offreProduit;

    public void calculerSousTotal() {
        if (quantite != null && prixCommande != null) {
            this.sousTotal = prixCommande.multiply(BigDecimal.valueOf(quantite));
        } else {
            this.sousTotal = BigDecimal.ZERO;
        }
    }
}
