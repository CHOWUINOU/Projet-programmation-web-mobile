package com.eggdelivery.service;

import com.eggdelivery.dto.JwtResponse;
import com.eggdelivery.dto.LoginRequest;
import com.eggdelivery.dto.RegisterRequest;
import com.eggdelivery.model.*;
import com.eggdelivery.repository.*;
import com.eggdelivery.security.JwtUtils;
import com.eggdelivery.security.UserDetailsImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final UtilisateurRepository utilisateurRepository;
    private final ClientRepository clientRepository;
    private final VendeurRepository vendeurRepository;
    private final LivreurRepository livreurRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtils jwtUtils;

    public JwtResponse login(LoginRequest loginRequest) {
        // Accepte email ou téléphone comme identifiant
        String username = loginRequest.getEmail();

        // Si c'est un numéro de téléphone (commence par 6, 7, ou 8 et longueur 9)
        if (username.matches("^[6-8][0-9]{8}$")) {
            Utilisateur utilisateur = utilisateurRepository.findByTelephone(username)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé avec ce numéro"));
            username = utilisateur.getEmail();
        }

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username, loginRequest.getMotdepasse())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        Set<String> roles = userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toSet());

        Utilisateur utilisateur = utilisateurRepository.findByEmail(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

        return new JwtResponse(jwt, utilisateur.getId(), utilisateur.getNom(),
                utilisateur.getEmail(), utilisateur.getTelephone(), roles);
    }

    @Transactional
    public String register(RegisterRequest registerRequest) {
        if (utilisateurRepository.existsByEmail(registerRequest.getEmail())) {
            throw new RuntimeException("Erreur: L'email est déjà utilisé!");
        }

        if (utilisateurRepository.existsByTelephone(registerRequest.getTelephone())) {
            throw new RuntimeException("Erreur: Le numéro de téléphone est déjà utilisé!");
        }

        String encodedPassword = passwordEncoder.encode(registerRequest.getMotdepasse());

        switch (registerRequest.getTypeUtilisateur().toUpperCase()) {
            case "CLIENT":
                Client client = new Client(
                        registerRequest.getNom(),
                        registerRequest.getEmail(),
                        encodedPassword,
                        registerRequest.getTelephone(),
                        registerRequest.getAdresse()
                );
                if (registerRequest.getPreferencesLivraison() != null) {
                    client.setPreferencesLivraison(registerRequest.getPreferencesLivraison());
                }
                clientRepository.save(client);
                return "Client enregistré avec succès!";

            case "VENDEUR":
                Vendeur vendeur = new Vendeur(
                        registerRequest.getNom(),
                        registerRequest.getEmail(),
                        encodedPassword,
                        registerRequest.getTelephone(),
                        registerRequest.getAdresse(),
                        registerRequest.getNomBoutique() != null ?
                                registerRequest.getNomBoutique() : registerRequest.getNom() + " Boutique",
                        registerRequest.getDescription() != null ?
                                registerRequest.getDescription() : "Vendeur de œufs frais"
                );
                vendeurRepository.save(vendeur);
                return "Vendeur enregistré avec succès!";

            case "LIVREUR":
                Livreur livreur = new Livreur(
                        registerRequest.getNom(),
                        registerRequest.getEmail(),
                        encodedPassword,
                        registerRequest.getTelephone(),
                        registerRequest.getAdresse(),
                        registerRequest.getMoyenTransport() != null ?
                                registerRequest.getMoyenTransport() : "Moto"
                );
                livreurRepository.save(livreur);
                return "Livreur enregistré avec succès!";

            default:
                throw new RuntimeException("Type d'utilisateur invalide");
        }
    }
}