-- ================================================
-- Analyse des achats et des fournisseurs
-- ===============================================

-- 1. Indicateurs globaux des achats

SELECT
    COUNT(*) AS nombre_lignes_achat,
    SUM(quantite) AS quantite_totale_achatee,
    ROUND(SUM(quantite * prix_achat_unitaire), 2) AS montant_total_achats,
    COUNT(*) FILTER (WHERE livraison_en_retard) AS nombre_livraisons_en_retard,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE livraison_en_retard)
        / NULLIF(COUNT(*), 0),
        2
    ) AS taux_retard_pct
FROM commande_achats;

-- 2. Performance des fournisseurs

SELECT 
    f.fournisseur_id,
    f.nom_fournisseur,
    f.pays,
    COUNT(ca.commande_achats_id) AS nombre_lignes_achat,
    ROUND(
        SUM(ca.quantite * ca.prix_achat_unitaire),
        2
    ) AS montant_total_achats,
    COUNT(*) FILTER (WHERE ca.livraison_en_retard) AS livraison_en_retard,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE ca.livraison_en_retard)
        / NULLIF(COUNT(*), 0),
        2
    ) AS taux_retard_pct
FROM fournisseurs AS f 
INNER JOIN commande_achats AS ca
    ON f.fournisseur_id = ca.fournisseur_id
GROUP BY 
    f.fournisseur_id,
    f.nom_fournisseur,
    f.pays
ORDER BY taux_retard_pct DESC, montant_total_achats DESC;

-- 3. Analyse des délais de livraison

SELECT
    fournisseur_id,
    COUNT(*) AS nombre_livraisons,
    ROUND(
        AVG(date_livraison - date_livraison_prevue),
        2
    ) AS ecart_moyen_jours,
    COUNT(*) FILTER ( WHERE date_livraison > date_livraison_prevue) as nombre_livraisons_en_retard
FROM commande_achats
GROUP BY fournisseur_id
ORDER BY ecart_moyen_jours DESC;