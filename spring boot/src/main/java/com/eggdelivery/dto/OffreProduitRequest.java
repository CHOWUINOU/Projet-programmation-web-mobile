package com.eggdelivery.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OffreProduitRequest {
    
    @NotNull(message = "Le produit est obligatoire")
    private Long produitId;
    
    @NotNull(message = "Le prix unitaire est obligatoire")
    @Positive(message = "Le prix doit être positif")
    private BigDecimal prixUnitaire;
    
    @NotNull(message = "Le stock est obligatoire")
    @Positive(message = "Le stock doit être positif")
    private Integer stock;
    
    private String uniteDeVente;
}
