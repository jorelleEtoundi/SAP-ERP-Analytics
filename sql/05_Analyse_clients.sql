-- ===================================
-- Analyse des clients
-- ==========================

-- 1. Chiffre d'affaire et commandes par client

SELECT  
    p.client_id,
    p.nom_client,
    p.ville,
    p.pays,
    COUNT(cv.commande_ventes_id) AS nombre_lignes_vente,
    SUM(cv."quantité") AS quantite_totale_vendue,
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires
FROM clients AS c
INNER JOIN commande_ventes AS cv 
    ON c.client_id = cv.client_id
GROUP BY 
    p.client_id,
    p.nom_client,
    p.ville,
    p.pays
ORDER BY chiffre_affaires DESC;


-- 2. Top 10 des clients par chiffre d'affaires

SELECT
    p.client_id,
    p.nom_client,
    p.ville,
    p.pays,
    COUNT(cv.commande_ventes_id) AS nombre_lignes_vente,
    ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires
FROM clients AS c 
INNER JOIN commande_ventes AS cv
    ON c.client_id = cv.client_id
GROUP BY    
    p.client_id,
    p.nom_client,
    p.ville,
    p.pays
ORDER BY chiffre_affaires DESC
LIMIT 10;