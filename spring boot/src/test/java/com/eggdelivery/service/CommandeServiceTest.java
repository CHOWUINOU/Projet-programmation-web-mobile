package com.eggdelivery.service;

import com.eggdelivery.dto.CommandeRequest;
import com.eggdelivery.model.*;
import com.eggdelivery.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CommandeServiceTest {

    @Mock
    private CommandeRepository commandeRepository;

    @Mock
    private ClientRepository clientRepository;

    @Mock
    private OffreProduitRepository offreProduitRepository;

    @Mock
    private LigneCommandeRepository ligneCommandeRepository;

    @Mock
    private LivraisonRepository livraisonRepository;

    @InjectMocks
    private CommandeService commandeService;

    private Client client;
    private OffreProduit offreProduit;
    private Produit produit;

    @BeforeEach
    void setUp() {
        // Créer un client de test
        client = new Client();
        client.setId(1L);
        client.setNom("Test Client");
        client.setEmail("test@example.com");

        // Créer un produit de test
        produit = new Produit();
        produit.setId(1L);
        produit.setNom("Œufs Bio");
        produit.setDisponibilite(Produit.DisponibiliteProduit.DISPONIBLE);

        // Créer une offre de test
        offreProduit = new OffreProduit();
        offreProduit.setId(1L);
        offreProduit.setProduit(produit);
        offreProduit.setPrixUnitaire(new BigDecimal("150.00"));
        offreProduit.setStock(100);
        offreProduit.setDisponibilite(OffreProduit.DisponibiliteOffre.DISPONIBLE);
    }

    @Test
    void testCreateCommande_Success() {
        // Arrange
        CommandeRequest request = new CommandeRequest();
        request.setAdresseLivraison("Yaoundé");
        
        List<CommandeRequest.LigneCommandeRequest> lignes = new ArrayList<>();
        CommandeRequest.LigneCommandeRequest ligne = new CommandeRequest.LigneCommandeRequest();
        ligne.setOffreProduitId(1L);
        ligne.setQuantite(2);
        lignes.add(ligne);
        request.setLignesCommande(lignes);

        when(clientRepository.findById(1L)).thenReturn(Optional.of(client));
        when(offreProduitRepository.findById(1L)).thenReturn(Optional.of(offreProduit));
        when(commandeRepository.save(any(Commande.class))).thenAnswer(invocation -> {
            Commande commande = invocation.getArgument(0);
            commande.setId(1L);
            return commande;
        });
        when(livraisonRepository.save(any(Livraison.class))).thenReturn(new Livraison());

        // Act
        Commande result = commandeService.createCommande(1L, request);

        // Assert
        assertNotNull(result);
        assertEquals("Yaoundé", result.getAdresseLivraison());
        assertEquals(new BigDecimal("300.00"), result.getMontantTotal());
        assertEquals(1, result.getLignesCommande().size());
        verify(commandeRepository, times(1)).save(any(Commande.class));
        verify(livraisonRepository, times(1)).save(any(Livraison.class));
    }

    @Test
    void testCreateCommande_ClientNotFound() {
        // Arrange
        CommandeRequest request = new CommandeRequest();
        when(clientRepository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(RuntimeException.class, () -> {
            commandeService.createCommande(999L, request);
        });
    }

    @Test
    void testCreateCommande_InsufficientStock() {
        // Arrange
        offreProduit.setStock(1); // Stock insuffisant
        
        CommandeRequest request = new CommandeRequest();
        request.setAdresseLivraison("Yaoundé");
        
        List<CommandeRequest.LigneCommandeRequest> lignes = new ArrayList<>();
        CommandeRequest.LigneCommandeRequest ligne = new CommandeRequest.LigneCommandeRequest();
        ligne.setOffreProduitId(1L);
        ligne.setQuantite(5); // Demande plus que le stock disponible
        lignes.add(ligne);
        request.setLignesCommande(lignes);

        when(clientRepository.findById(1L)).thenReturn(Optional.of(client));
        when(offreProduitRepository.findById(1L)).thenReturn(Optional.of(offreProduit));

        // Act & Assert
        assertThrows(RuntimeException.class, () -> {
            commandeService.createCommande(1L, request);
        });
    }

    @Test
    void testGetCommandeById_Success() {
        // Arrange
        Commande commande = new Commande();
        commande.setId(1L);
        when(commandeRepository.findById(1L)).thenReturn(Optional.of(commande));

        // Act
        Commande result = commandeService.getCommandeById(1L);

        // Assert
        assertNotNull(result);
        assertEquals(1L, result.getId());
    }

    @Test
    void testGetCommandeById_NotFound() {
        // Arrange
        when(commandeRepository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(RuntimeException.class, () -> {
            commandeService.getCommandeById(999L);
        });
    }

    @Test
    void testUpdateStatutCommande_Success() {
        // Arrange
        Commande commande = new Commande();
        commande.setId(1L);
        commande.setStatut(Commande.StatutCommande.EN_ATTENTE);
        
        when(commandeRepository.findById(1L)).thenReturn(Optional.of(commande));
        when(commandeRepository.save(any(Commande.class))).thenReturn(commande);

        // Act
        Commande result = commandeService.updateStatutCommande(1L, Commande.StatutCommande.CONFIRMEE);

        // Assert
        assertNotNull(result);
        assertEquals(Commande.StatutCommande.CONFIRMEE, result.getStatut());
        verify(commandeRepository, times(1)).save(commande);
    }

    @Test
    void testCancelCommande_Success() {
        // Arrange
        Commande commande = new Commande();
        commande.setId(1L);
        commande.setStatut(Commande.StatutCommande.EN_ATTENTE);
        
        LigneCommande ligne = new LigneCommande();
        ligne.setOffreProduit(offreProduit);
        ligne.setQuantite(2);
        commande.setLignesCommande(List.of(ligne));

        when(commandeRepository.findById(1L)).thenReturn(Optional.of(commande));
        when(commandeRepository.save(any(Commande.class))).thenReturn(commande);

        // Act
        commandeService.cancelCommande(1L);

        // Assert
        assertEquals(Commande.StatutCommande.ANNULEE, commande.getStatut());
        assertEquals(102, offreProduit.getStock()); // Stock restauré (100 + 2)
        verify(commandeRepository, times(1)).save(commande);
    }

    @Test
    void testCancelCommande_CannotCancel() {
        // Arrange
        Commande commande = new Commande();
        commande.setId(1L);
        commande.setStatut(Commande.StatutCommande.LIVREE); // Déjà livrée
        
        when(commandeRepository.findById(1L)).thenReturn(Optional.of(commande));

        // Act & Assert
        assertThrows(RuntimeException.class, () -> {
            commandeService.cancelCommande(1L);
        });
    }
}
