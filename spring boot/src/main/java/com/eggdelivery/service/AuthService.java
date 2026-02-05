package com.eggdelivery.service;

import com.eggdelivery.dto.JwtResponse;
import com.eggdelivery.dto.LoginRequest;
import com.eggdelivery.dto.RegisterRequest;
import com.eggdelivery.model.*;
import com.eggdelivery.repository.ClientRepository;
import com.eggdelivery.repository.LivreurRepository;
import com.eggdelivery.repository.UtilisateurRepository;
import com.eggdelivery.repository.VendeurRepository;
import com.eggdelivery.security.JwtUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getMotdepasse())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Set<String> roles = userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toSet());

        Utilisateur utilisateur = utilisateurRepository.findByEmail(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

        return new JwtResponse(jwt, utilisateur.getId(), utilisateur.getNom(), utilisateur.getEmail(), roles);
    }

    @Transactional
    public String register(RegisterRequest registerRequest) {
        if (utilisateurRepository.existsByEmail(registerRequest.getEmail())) {
            throw new RuntimeException("Erreur: L'email est déjà utilisé!");
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
                client.setPreferencesLivraison(registerRequest.getPreferencesLivraison());
                clientRepository.save(client);
                break;

            case "VENDEUR":
                Vendeur vendeur = new Vendeur(
                        registerRequest.getNom(),
                        registerRequest.getEmail(),
                        encodedPassword,
                        registerRequest.getTelephone(),
                        registerRequest.getAdresse(),
                        registerRequest.getNomBoutique(),
                        registerRequest.getDescription()
                );
                vendeurRepository.save(vendeur);
                break;

            case "LIVREUR":
                Livreur livreur = new Livreur(
                        registerRequest.getNom(),
                        registerRequest.getEmail(),
                        encodedPassword,
                        registerRequest.getTelephone(),
                        registerRequest.getAdresse(),
                        registerRequest.getMoyenTransport()
                );
                livreurRepository.save(livreur);
                break;

            default:
                throw new RuntimeException("Type d'utilisateur invalide");
        }

        return "Utilisateur enregistré avec succès!";
    }
}
