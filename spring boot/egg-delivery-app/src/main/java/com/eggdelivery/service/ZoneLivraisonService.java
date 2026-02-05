package com.eggdelivery.service;

import com.eggdelivery.model.ZoneLivraison;
import com.eggdelivery.repository.ZoneLivraisonRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ZoneLivraisonService {

    private final ZoneLivraisonRepository zoneLivraisonRepository;

    public List<ZoneLivraison> getAllZones() {
        return zoneLivraisonRepository.findAll();
    }

    public ZoneLivraison getZoneById(Long id) {
        return zoneLivraisonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Zone de livraison non trouvée avec l'id: " + id));
    }

    public List<ZoneLivraison> getZonesByVendeur(Long vendeurId) {
        return zoneLivraisonRepository.findByVendeurId(vendeurId);
    }

    public List<ZoneLivraison> getZonesActives() {
        return zoneLivraisonRepository.findByStatut(ZoneLivraison.StatutZone.ACTIVE);
    }

    @Transactional
    public ZoneLivraison createZone(ZoneLivraison zoneLivraison) {
        return zoneLivraisonRepository.save(zoneLivraison);
    }

    @Transactional
    public ZoneLivraison updateZone(Long id, ZoneLivraison zoneDetails) {
        ZoneLivraison zone = getZoneById(id);
        zone.setNomZone(zoneDetails.getNomZone());
        zone.setPrixLivraison(zoneDetails.getPrixLivraison());
        zone.setDelaisEstime(zoneDetails.getDelaisEstime());
        zone.setStatut(zoneDetails.getStatut());
        return zoneLivraisonRepository.save(zone);
    }

    @Transactional
    public ZoneLivraison updateStatut(Long id, ZoneLivraison.StatutZone statut) {
        ZoneLivraison zone = getZoneById(id);
        zone.setStatut(statut);
        return zoneLivraisonRepository.save(zone);
    }

    @Transactional
    public void deleteZone(Long id) {
        if (!zoneLivraisonRepository.existsById(id)) {
            throw new RuntimeException("Zone de livraison non trouvée avec l'id: " + id);
        }
        zoneLivraisonRepository.deleteById(id);
    }
}
