package com.eggdelivery.util;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * Classe utilitaire pour générer des références uniques
 */
public class ReferenceGenerator {

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final String ALPHANUMERIC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    /**
     * Génère une référence de commande unique
     * Format: CMD-YYYYMMDD-XXXXXX
     */
    public static String generateCommandeReference() {
        String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String random = generateRandomString(6);
        return "CMD-" + date + "-" + random;
    }

    /**
     * Génère une référence de livraison unique
     * Format: LIV-YYYYMMDD-XXXXXX
     */
    public static String generateLivraisonReference() {
        String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String random = generateRandomString(6);
        return "LIV-" + date + "-" + random;
    }

    /**
     * Génère un ID de transaction unique
     * Format: TXN-UUID
     */
    public static String generateTransactionId() {
        return "TXN-" + UUID.randomUUID().toString().replace("-", "").substring(0, 16).toUpperCase();
    }

    /**
     * Génère une chaîne aléatoire de longueur spécifiée
     */
    private static String generateRandomString(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int index = RANDOM.nextInt(ALPHANUMERIC.length());
            sb.append(ALPHANUMERIC.charAt(index));
        }
        return sb.toString();
    }

    /**
     * Génère un code de vérification numérique
     */
    public static String generateVerificationCode(int length) {
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < length; i++) {
            code.append(RANDOM.nextInt(10));
        }
        return code.toString();
    }
}
