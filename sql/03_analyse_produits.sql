-- =======================================
-- Analyse des performances des produits
-- =======================================

-- 1. Chiffre d'affaires par produits

SELECT
    p.produit_id,
    p.nom_produit,
    p.categorie,
    SUM(cv."quantité") AS quantite_totale_vendue,
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires
FROM commande_ventes AS cv
INNER JOIN produits AS p
    ON cv.produit_id = p.produit_id
GROUP BY 
    p.produit_id,
    p.nom_produit,
    p.categorie
ORDER BY chiffre_affaires DESC;

-- 2. Top 10 des produits par chiffre d'affaires

SELECT
    p.produit_id,
    p.nom_produit,
    p.categorie,
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires
FROM commande_ventes AS cv
INNER JOIN produits AS p
    ON cv.produit_id = p.produit_id
GROUP BY 
    p.produit_id,
    p.nom_produit,
    p.categorie
ORDER BY chiffre_affaires DESC
LIMIT 10;