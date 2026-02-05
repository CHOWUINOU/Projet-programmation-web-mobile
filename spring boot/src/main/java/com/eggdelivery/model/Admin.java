package com.eggdelivery.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "admins")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Admin extends Utilisateur {

    public Admin(String nom, String email, String motdepasse, String telephone, String adresse) {
        this.setNom(nom);
        this.setEmail(email);
        this.setMotdepasse(motdepasse);
        this.setTelephone(telephone);
        this.setAdresse(adresse);
        this.getRoles().add(Role.ROLE_ADMIN);
    }
}
