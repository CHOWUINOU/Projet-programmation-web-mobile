package com.eggdelivery.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "paiements")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Paiement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MethodePaiement methode;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut_montant", nullable = false)
    private StatutPaiement statutMontant = StatutPaiement.EN_ATTENTE;

    @Column(nullable = false)
    private BigDecimal montant;

    @CreatedDate
    @Column(name = "date_paiement", nullable = false, updatable = false)
    private LocalDateTime datePaiement;

    @Column(name = "transaction_id", unique = true)
    private String transactionId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "commande_id", nullable = false)
    private Commande commande;

    public enum MethodePaiement {
        ESPECES, CARTE_BANCAIRE, MOBILE_MONEY, VIREMENT
    }

    public enum StatutPaiement {
        EN_ATTENTE, REUSSI, ECHOUE, REMBOURSE
    }
}
