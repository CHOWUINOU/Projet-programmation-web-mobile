package com.eggdelivery.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private Long id;
    private String nom;
    private String email;
    private String telephone;
    private Set<String> roles;

    public JwtResponse(String token, Long id, String nom, String email, String telephone, Set<String> roles) {
        this.token = token;
        this.id = id;
        this.nom = nom;
        this.email = email;
        this.telephone = telephone;
        this.roles = roles;
    }
}