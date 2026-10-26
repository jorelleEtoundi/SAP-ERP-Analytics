-- ===============================================
-- Analyse des stockes et des risques de rupture
-- ===============================================

-- 1. Vue globale des stocks

SELECT
    COUNT(*) AS nombre_produits_stockes,
    SUM(quantite_disponible) AS quantite_totale_en_stock,
    COUNT(*) FILTER (WHERE alerte_stock) AS nombre_produits_en_alerte,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE alerte_stock)
        / NULLIF(COUNT(*), 0),
        2
    ) AS taux_produits_en_alerte_pct
From stocks;

-- 2. Produits sous leur seuil d'alerte

SELECT
    s.stocks_id,
    p.produit_id,
    p.nom_produit,
    p.categorie,
    s.quantite_disponible,
    s.seuil_alerte,
    s.seuil_alerte - s.quantite_disponible
        AS quantite_manquante_pour_atteindre_le_seuil,
    s.alerte_stock
FROM stocks AS s 
INNER JOIN produits AS p
    ON s.produit_id = p.produit_id
WHERE s.quantite_disponible <= s.seuil_alerte
ORDER BY 
    (s.seuil_alerte - s.quantite_disponible) DESC;


-- 3. Niveau de stock par categorie

SELECT 
    p.categorie,
    COUNT(*) AS nombre_produits,
    SUM(s.quantite_disponible) AS quantite_totale_en_stock,
    SUM(s.seuil_alerte) AS somme_des_seuils_alerte,
    COUNT(*) FILTER (WHERE s.alerte_stock) AS nombre_produits_en_alerte
FROM stocks AS s
INNER JOIN produits AS p
    ON s.produit_id = p.produit_id
GROUP BY p.categorie
ORDER BY quantite_totale_en_stock ASC;