-- =====================================
-- Analyse des ventes
-- =====================================

-- 1. Chiffre d'affaires total, nombre de commandes
-- Quantité totale vendue

SELECT 
    COUNT(*) nombre_commandes,
    SUM("quantité") AS quantite_totale_vendue,
    ROUND(SUM(montant_vente), 2) AS chiffre_affaires_total
FROM commande_ventes;

-- 2. Evolution du chiffre d'affaire par mois 

SELECT 
    DATE_TRUNC('month', date_commande)::DATE AS mois,
    COUNT(*) AS nombre_commandes,
    ROUND(SUM(montant_vente), 2) AS chiffre_affaires
FROM commande_ventes
GROUP BY DATE_TRUNC('month', date_commande)
ORDER BY mois ASC;