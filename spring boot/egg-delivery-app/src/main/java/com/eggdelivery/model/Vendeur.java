package com.eggdelivery.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "vendeurs")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Vendeur extends Utilisateur {

    @Column(name = "nom_boutique")
    private String nomBoutique;

    private String description;

    @Column(name = "type_vente")
    private String typeVente;

    @Column(name = "logo_boutique")
    private String logoBoutique;

    @OneToMany(mappedBy = "vendeur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Produit> produits = new ArrayList<>();

    @OneToMany(mappedBy = "vendeur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ZoneLivraison> zonesLivraison = new ArrayList<>();

    public Vendeur(String nom, String email, String motdepasse, String telephone, String adresse, 
                   String nomBoutique, String description) {
        this.setNom(nom);
        this.setEmail(email);
        this.setMotdepasse(motdepasse);
        this.setTelephone(telephone);
        this.setAdresse(adresse);
        this.nomBoutique = nomBoutique;
        this.description = description;
        this.getRoles().add(Role.ROLE_VENDEUR);
    }
}
