-- ================================================
-- Analyse des rentabilités
-- ===========================================


-- 1. Rentabilité estimée par produit

SELECT
    p.produit_id,
    p.nom_produit,
    p.categorie,
    SUM(cv."quantité") AS quantite_totale_vendue,
    ROUND(
        SUM(cv."quantité" * p.cout_unitaire), 
        2
    ) AS cout_unitaire,
    ROUND(
        SUM(cv.montant_vente)
        - SUM(cv."quantité" * p.cout_unitaire),
        2
    ) AS marge_brute_estimee,
    ROUND(
        100.0 * (
            SUM(cv."quantité" * p.cout_unitaire),
        ) / NULLIF(SUM(cv.montant_vente), 0),
        2
    ) AS taux_marge_pct
FROM commande_ventes AS cv
INNER JOIN produits AS p 
    ON cv.produit_id = p.produit_id
GROUP BY
    p.produit_id,
    p.nom_produit,
    p.categorie
ORDER BY marge_brute_estimee DESC;

-- 2. Top 10 des produits par marge brute estimée

SELECT 
    p.produit_id,
    p.nom_produit,
    p.categorie,
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires,
    ROUND(SUM(cv."quantité" * p.cout_unitaire), 2) AS cout_estimee,
    ROUND(
        SUM(cv."quantité" * p.cout_unitaire),
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
    ON cv.produit_id = p.produit_id
GROUP BY
    p.produit_id,
    p.nom_produit,
    p.categorie
ORDER BY marge_brute_estimee DESC
LIMIT 10;

-- 3. Rentabilité estimée par categorie

SELECT 
    p.categorie,
    COUNT(DISTINCT p.produit_id) AS nombre_produits,
    SUM(cv."quantité") AS quantite_totale_vendue, 
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires,
    ROUND(
        SUM(cv."quantité" * p.cout_unitaire),
        2
    ) AS cout_estimee,
    ROUND(
        SUM(cv.montant_vente)
        - SUM(cv."quantité" * p.cout_unitaire),
        2
    ) AS marge_brute_estimee,
    ROUND(
        100.0 * (
            SUM(cv.montant_vente)
            - SUM(cv."quantité" * p.cout_unitaire)
        ) / NULLIF (SUM(cv.montant_vente), 0),
        2
    ) AS taux_marge_pct
FROM commande_ventes AS cv
INNER JOIN produits AS P 
    ON cv.produit_id = p.produit_id
GROUP BY p.categorie
ORDER BY marge_brute_estimee DESC;