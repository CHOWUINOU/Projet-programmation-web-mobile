package com.eggdelivery.service;

import com.eggdelivery.dto.VendeurBoutiqueRequest;
import com.eggdelivery.model.Vendeur;
import com.eggdelivery.repository.VendeurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VendeurService {

    private final VendeurRepository vendeurRepository;
    private final String uploadDir = "uploads/logos";

    public List<Vendeur> getAllVendeurs() {
        return vendeurRepository.findAll();
    }

    public Vendeur getVendeurById(Long id) {
        return vendeurRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé avec l'id: " + id));
    }

    public Vendeur getVendeurByEmail(String email) {
        return vendeurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé avec l'email: " + email));
    }

    @Transactional
    public Vendeur updateVendeur(Long id, Vendeur vendeurDetails) {
        Vendeur vendeur = getVendeurById(id);
        vendeur.setNomBoutique(vendeurDetails.getNomBoutique());
        vendeur.setDescription(vendeurDetails.getDescription());
        vendeur.setNom(vendeurDetails.getNom());
        vendeur.setTelephone(vendeurDetails.getTelephone());
        vendeur.setAdresse(vendeurDetails.getAdresse());
        return vendeurRepository.save(vendeur);
    }

    @Transactional
    public Vendeur validerVendeur(Long id) {
        Vendeur vendeur = getVendeurById(id);
        vendeur.setStatut(Vendeur.StatutUtilisateur.ACTIF);
        return vendeurRepository.save(vendeur);
    }

    @Transactional
    public void deleteVendeur(Long id) {
        if (!vendeurRepository.existsById(id)) {
            throw new RuntimeException("Vendeur non trouvé avec l'id: " + id);
        }
        vendeurRepository.deleteById(id);
    }

    @Transactional
    public Vendeur updateBoutiqueByEmail(String email, VendeurBoutiqueRequest data) {
        Vendeur vendeur = vendeurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé"));

        vendeur.setNomBoutique(data.getNomBoutique());
        vendeur.setDescription(data.getDescription());
        vendeur.setTelephone(data.getTelephone());
        vendeur.setEmail(data.getEmail());
        vendeur.setAdresse(data.getAdresse());

        return vendeurRepository.save(vendeur);
    }

    public Vendeur getBoutiqueByEmail(String email) {
        return vendeurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé"));
    }

    @Transactional
    public Vendeur updateBoutique(Long vendeurId, VendeurBoutiqueRequest data) throws IOException {
        Vendeur vendeur = vendeurRepository.findById(vendeurId)
                .orElseThrow(() -> new RuntimeException("Vendeur non trouvé"));

        if (data.getNomBoutique() != null) vendeur.setNomBoutique(data.getNomBoutique());
        if (data.getDescription() != null) vendeur.setDescription(data.getDescription());
        if (data.getTelephone() != null) vendeur.setTelephone(data.getTelephone());
        if (data.getEmail() != null) vendeur.setEmail(data.getEmail());
        if (data.getAdresse() != null) vendeur.setAdresse(data.getAdresse());

        // upload logo
        if (data.getPhoto() != null && !data.getPhoto().isEmpty()) {
            Path uploadPath = Paths.get("uploads/logos");
            if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);

            String fileName = vendeur.getId() + "_" + data.getPhoto().getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);
            Files.write(filePath, data.getPhoto().getBytes());

            vendeur.setLogoBoutique(fileName);
        }

        return vendeurRepository.save(vendeur);
    }
}
