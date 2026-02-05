package com.eggdelivery.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "produits")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Produit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(nullable = false)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "type_oeuf")
    private String typeOeuf;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime datecreation;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DisponibiliteProduit disponibilite = DisponibiliteProduit.DISPONIBLE;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendeur_id")
    private Vendeur vendeur;

    @OneToMany(mappedBy = "produit", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<OffreProduit> offres = new ArrayList<>();

    public enum DisponibiliteProduit {
        DISPONIBLE, RUPTURE_STOCK, INDISPONIBLE
    }
}
