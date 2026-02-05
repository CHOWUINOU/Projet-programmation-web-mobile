package com.eggdelivery.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProduitRequest {
    
    @NotBlank(message = "Le nom du produit est obligatoire")
    private String nom;
    
    private String description;
    
    private String typeOeuf;
}
