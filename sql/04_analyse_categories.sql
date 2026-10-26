-- ===================================
-- Analyse des ventes par categorie
-- ===================================

-- 1. Chiffre d'affaires et quantité vendues par categorie

SELECT
    p.categorie,
    COUNT(*) AS nombre_lignes_vente,
    SUM(cv."quantité") AS quantite_totale_vendue,
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires
FROM commande_ventes AS cv
INNER JOIN produits AS p
    ON cv.produit_id = p.produit_id
GROUP BY p.categorie
ORDER BY chiffre_affaires DESC;


-- 2. Part de chaque categorie dans le chiffre d'affaires total

SELECT
    p.categorie,
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires,
    ROUND(
        100.0 * SUM(cv.montant_vente)
        / SUM(SUM(cv.montant_vente)) OVER (),
        2
    ) AS part_chiffre_affaires_pct
FROM commande_ventes AS cv
INNER JOIN produits AS p
    ON cv.produit_id = p.produit_id
GROUP BY p.categorie
ORDER BY chiffre_affaires DESC;