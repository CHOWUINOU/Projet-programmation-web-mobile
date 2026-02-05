package com.eggdelivery.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommandeRequest {
    
    @NotBlank(message = "L'adresse de livraison est obligatoire")
    private String adresseLivraison;
    
    @NotEmpty(message = "La commande doit contenir au moins un produit")
    private List<LigneCommandeRequest> lignesCommande;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LigneCommandeRequest {
        private Long offreProduitId;
        private Integer quantite;
    }
}
