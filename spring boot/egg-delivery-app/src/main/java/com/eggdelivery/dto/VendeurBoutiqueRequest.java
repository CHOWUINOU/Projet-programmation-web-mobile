package com.eggdelivery.dto;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class VendeurBoutiqueRequest {
    private String nomBoutique;
    private String description;
    private String telephone;
    private String email;
    private String adresse;
    private MultipartFile photo;
}