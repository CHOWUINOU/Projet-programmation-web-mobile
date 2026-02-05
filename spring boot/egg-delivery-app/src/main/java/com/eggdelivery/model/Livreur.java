package com.eggdelivery.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "livreurs")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Livreur extends Utilisateur {

    @Column(name = "moyen_transport")
    private String moyenTransport;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutLivreur statutLivreur = StatutLivreur.DISPONIBLE;

    @OneToMany(mappedBy = "livreur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Livraison> livraisons = new ArrayList<>();

    public enum StatutLivreur {
        DISPONIBLE, EN_LIVRAISON, INDISPONIBLE
    }

    public Livreur(String nom, String email, String motdepasse, String telephone, String adresse, String moyenTransport) {
        this.setNom(nom);
        this.setEmail(email);
        this.setMotdepasse(motdepasse);
        this.setTelephone(telephone);
        this.setAdresse(adresse);
        this.moyenTransport = moyenTransport;
        this.getRoles().add(Role.ROLE_LIVREUR);
    }
}
