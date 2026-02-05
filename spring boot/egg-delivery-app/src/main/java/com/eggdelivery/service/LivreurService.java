package com.eggdelivery.service;

import com.eggdelivery.model.Livreur;
import com.eggdelivery.repository.LivreurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LivreurService {

    private final LivreurRepository livreurRepository;

    public List<Livreur> getAllLivreurs() {
        return livreurRepository.findAll();
    }

    public Livreur getLivreurById(Long id) {
        return livreurRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Livreur non trouvé avec l'id: " + id));
    }

    public Livreur getLivreurByEmail(String email) {
        return livreurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Livreur non trouvé avec l'email: " + email));
    }

    public List<Livreur> getLivreursDisponibles() {
        return livreurRepository.findByStatutLivreur(Livreur.StatutLivreur.DISPONIBLE);
    }

    @Transactional
    public Livreur updateStatut(Long id, Livreur.StatutLivreur statut) {
        Livreur livreur = getLivreurById(id);
        livreur.setStatutLivreur(statut);
        return livreurRepository.save(livreur);
    }

    @Transactional
    public Livreur updateLivreur(Long id, Livreur livreurDetails) {
        Livreur livreur = getLivreurById(id);
        livreur.setNom(livreurDetails.getNom());
        livreur.setTelephone(livreurDetails.getTelephone());
        livreur.setAdresse(livreurDetails.getAdresse());
        livreur.setMoyenTransport(livreurDetails.getMoyenTransport());
        return livreurRepository.save(livreur);
    }

    @Transactional
    public void deleteLivreur(Long id) {
        if (!livreurRepository.existsById(id)) {
            throw new RuntimeException("Livreur non trouvé avec l'id: " + id);
        }
        livreurRepository.deleteById(id);
    }
}
