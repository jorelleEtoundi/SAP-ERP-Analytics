-- ===============================
-- Synthèse KPI
-- ==============================


-- 1. Indicateurs globaux des ventes

SELECT
    COUNT(*) AS nombre_lignes_vente,
    SUM("quantité") AS quantite_totale_vendue,
    ROUND(SUM(montant_vente), 2) AS chiffre_affaires_total,
    ROUND(AVG(montant_vente), 2) AS montant_moyen_par_ligne_vente
FROM commande_ventes;

-- 2. Indicateurs globaux des achats

SELECT 
    COUNT(*) AS nombre_lignes_achat,
    SUM(quantite) AS quantite_totale_achatee,
    ROUND(SUM(quantite * prix_achat_unitaire), 2) AS montant_total_achats,
    COUNT(*) FILTER (WHERE livraison_en_retard = TRUE) AS nombre_livraisons_en_retard,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE livraison_en_retard
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS taux_retard_pct
FROM commande_achats;

-- 3. Indicateurs client et produits

SELECT 
    (SELECT COUNT(*) FROM clients) AS nombre_clients,
    (SELECT COUNT(*) FROM produits) AS nombre_produits,
    (SELECT COUNT(*) FROM fournisseurs) AS nombre_fournisseurs;


-- 4. Indicateurs globaux des stocks

SELECT 
    COUNT(*) AS nombre_produits_suivis,
    SUM(quantite_disponible) AS quantite_totale_en_stock,
    COUNT(*) FILTER (
        WHERE alerte_stock
    ) AS nombre_produits_en_alerte,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE alerte_stock
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS taux_alerte_stock_pct
FROM stocks;

-- 5. Marge brute estimée globale

SELECT 
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires_total,
    ROUND(
        SUM(cv."quantité" * p.cout_unitaire),
        2
    ) AS cout_estime_des_produits_vendus,
    ROUND(
        SUM(cv.montant_vente)
        - SUM(cv."quantité" * p.cout_unitaire),
        2
    ) AS marge_brute_estimee,
    ROUND(
        100.0 * (
            SUM(cv.montant_vente)
            - SUM(cv."quantité" * p.cout_unitaire)
        ) / NULLIF(SUM(cv.montant_vente), 0),
        2
    ) AS taux_marge_pct
FROM commande_ventes AS cv 
INNER JOIN produits AS p 
    ON cv.produit_id = p.produit_id;


-- 6. Synthèse des principaux indicateurs

SELECT 
    (SELECT COUNT(*) FROM commande_ventes) AS nombre_lignes_vente,
    (SELECT ROUND(SUM(montant_vente), 2) FROM commande_ventes) AS chiffre_affaires_total,
    (SELECT ROUND(SUM(quantite * prix_achat_unitaire), 2) FROM commande_achats) AS montant_total_achats,
    (SELECT COUNT(*) FROM clients) AS nombre_clients,
    (SELECT COUNT(*) FROM produits) AS nombre_produits,
    (SELECT COUNT(*) FROM fournisseurs) AS nombre_fournisseurs,
    (SELECT COUNT(*) FROM stocks WHERE alerte_stock) AS nombre_produits_en_alerte,
    (SELECT COUNT(*) FROM commande_achats WHERE livraison_en_retard) AS nombre_livraisons_en_retard,
    (SELECT ROUND(
        SUM(cv.montant_vente)
        - SUM(cv."quantité" * p.cout_unitaire),
        2
    )
    FROM commande_ventes AS cv
    INNER JOIN produits AS p 
        ON cv.produit_id = p.produit_id
    ) AS marge_brute_estimee;
