package com.eggdelivery.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "clients")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Client extends Utilisateur {

    @Column(name = "preferences_livraison")
    private String preferencesLivraison;

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Commande> commandes = new ArrayList<>();

    public Client(String nom, String email, String motdepasse, String telephone, String adresse) {
        this.setNom(nom);
        this.setEmail(email);
        this.setMotdepasse(motdepasse);
        this.setTelephone(telephone);
        this.setAdresse(adresse);
        this.getRoles().add(Role.ROLE_CLIENT);
    }
}
