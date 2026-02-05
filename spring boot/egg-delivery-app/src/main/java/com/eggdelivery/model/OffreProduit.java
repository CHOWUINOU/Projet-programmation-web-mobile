package com.eggdelivery.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "offre_produits")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class OffreProduit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "prix_unitaire", nullable = false)
    private BigDecimal prixUnitaire;

    @Column(nullable = false)
    private Integer stock = 0;

    @Column(name = "unite_de_vente")
    private String uniteDeVente;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DisponibiliteOffre disponibilite = DisponibiliteOffre.DISPONIBLE;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime datecreation;

    @LastModifiedDate
    private LocalDateTime datemiseajour;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "produit_id", nullable = false)
    @JsonIgnore
    private Produit produit;

    @ManyToMany(mappedBy = "offresProduits")
    private List<ZoneLivraison> zonesLivraison = new ArrayList<>();

    @OneToMany(mappedBy = "offreProduit", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<LigneCommande> lignesCommande = new ArrayList<>();

    public enum DisponibiliteOffre {
        DISPONIBLE, RUPTURE_STOCK, INDISPONIBLE
    }
}
