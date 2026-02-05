package com.eggdelivery.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "zone_livraisons")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZoneLivraison {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nom_zone", nullable = false)
    private String nomZone;

    @Column(name = "prix_livraison")
    private String prixLivraison;

    @Column(name = "delais_estime")
    private String delaisEstime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutZone statut = StatutZone.ACTIVE;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendeur_id")
    private Vendeur vendeur;

    @ManyToMany
    @JoinTable(
        name = "zone_offre_produit",
        joinColumns = @JoinColumn(name = "zone_livraison_id"),
        inverseJoinColumns = @JoinColumn(name = "offre_produit_id")
    )
    private List<OffreProduit> offresProduits = new ArrayList<>();

    public enum StatutZone {
        ACTIVE, INACTIVE
    }
}
