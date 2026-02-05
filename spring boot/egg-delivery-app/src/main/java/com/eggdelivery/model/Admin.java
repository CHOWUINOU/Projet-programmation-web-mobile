package com.eggdelivery.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "admins")
@Getter // Remplacez @Data par @Getter et @Setter pour plus de contrôle avec l'héritage
@Setter
@ToString
@NoArgsConstructor // Génère le constructeur Admin()
public class Admin extends Utilisateur {

    // Votre constructeur personnalisé
    public Admin(String nom, String email, String motdepasse, String telephone, String adresse) {
        super(); // Appelle le constructeur de Utilisateur
        this.setNom(nom);
        this.setEmail(email);
        this.setMotdepasse(motdepasse);
        this.setTelephone(telephone);
        this.setAdresse(adresse);
        this.getRoles().add(Role.ROLE_ADMIN);
    }
}