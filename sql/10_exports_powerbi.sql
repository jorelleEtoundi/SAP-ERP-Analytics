
-- ============================================================
-- SAP-ERP-Analytics
-- Fichier : 10_exports_powerbi.sql
-- Objectif : exporter les analyses pour Power BI Web
-- ============================================================


-- 1. KPI globaux
\copy (SELECT (SELECT COUNT(*) FROM commande_ventes) AS nombre_lignes_vente, (SELECT SUM("quantité") FROM commande_ventes) AS quantite_totale_vendue, (SELECT ROUND(SUM(montant_vente), 2) FROM commande_ventes) AS chiffre_affaires_total, (SELECT ROUND(AVG(montant_vente), 2) FROM commande_ventes) AS montant_moyen_par_ligne_vente, (SELECT ROUND(SUM(quantite * prix_achat_unitaire), 2) FROM commande_achats) AS montant_total_achats, (SELECT COUNT(*) FROM clients) AS nombre_clients, (SELECT COUNT(*) FROM produits) AS nombre_produits, (SELECT COUNT(*) FROM fournisseurs) AS nombre_fournisseurs, (SELECT COUNT(*) FROM stocks WHERE alerte_stock) AS nombre_produits_en_alerte, (SELECT COUNT(*) FROM commande_achats WHERE livraison_en_retard) AS nombre_livraisons_en_retard, (SELECT ROUND(SUM(cv.montant_vente) - SUM(cv."quantité" * p.cout_unitaire), 2) FROM commande_ventes cv INNER JOIN produits p ON cv.produit_id = p.produit_id) AS marge_brute_estimee) TO 'data/processed/kpi_globaux.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- 2. Chiffre d'affaires mensuel
\copy (SELECT DATE_TRUNC('month', date_commande)::DATE AS mois, COUNT(*) AS nombre_lignes_vente, SUM("quantité") AS quantite_vendue, ROUND(SUM(montant_vente), 2) AS chiffre_affaires FROM commande_ventes GROUP BY DATE_TRUNC('month', date_commande) ORDER BY mois) TO 'data/processed/ventes_mensuelles.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- 3. Performance et rentabilite par produit
\copy (SELECT p.produit_id, p.nom_produit, p.categorie, SUM(cv."quantité") AS quantite_totale_vendue, ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires, ROUND(SUM(cv."quantité" * p.cout_unitaire), 2) AS cout_estime, ROUND(SUM(cv.montant_vente) - SUM(cv."quantité" * p.cout_unitaire), 2) AS marge_brute_estimee, ROUND(100.0 * (SUM(cv.montant_vente) - SUM(cv."quantité" * p.cout_unitaire)) / NULLIF(SUM(cv.montant_vente), 0), 2) AS taux_marge_pct FROM commande_ventes cv INNER JOIN produits p ON cv.produit_id = p.produit_id GROUP BY p.produit_id, p.nom_produit, p.categorie ORDER BY chiffre_affaires DESC) TO 'data/processed/rentabilite_produits.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- 4. Performance par categorie
\copy (SELECT p.categorie, COUNT(DISTINCT p.produit_id) AS nombre_produits, SUM(cv."quantité") AS quantite_totale_vendue, ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires, ROUND(SUM(cv."quantité" * p.cout_unitaire), 2) AS cout_estime, ROUND(SUM(cv.montant_vente) - SUM(cv."quantité" * p.cout_unitaire), 2) AS marge_brute_estimee, ROUND(100.0 * (SUM(cv.montant_vente) - SUM(cv."quantité" * p.cout_unitaire)) / NULLIF(SUM(cv.montant_vente), 0), 2) AS taux_marge_pct FROM commande_ventes cv INNER JOIN produits p ON cv.produit_id = p.produit_id GROUP BY p.categorie ORDER BY chiffre_affaires DESC) TO 'data/processed/ventes_categories.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- 5. Top 10 des clients par chiffre d'affaires
\copy (SELECT c.client_id, c.nom_client, c.ville, c.pays, COUNT(cv.commande_ventes_id) AS nombre_lignes_vente, SUM(cv."quantité") AS quantite_totale_achetee, ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires FROM clients c INNER JOIN commande_ventes cv ON c.client_id = cv.client_id GROUP BY c.client_id, c.nom_client, c.ville, c.pays ORDER BY chiffre_affaires DESC LIMIT 10) TO 'data/processed/top_clients.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- 6. Performance des fournisseurs et retards de livraison
\copy (SELECT f.fournisseur_id, f.nom_fournisseur, f.pays, COUNT(ca.commande_achats_id) AS nombre_lignes_achat, ROUND(SUM(ca.quantite * ca.prix_achat_unitaire), 2) AS montant_total_achats, COUNT(*) FILTER (WHERE ca.livraison_en_retard) AS livraisons_en_retard, ROUND(100.0 * COUNT(*) FILTER (WHERE ca.livraison_en_retard) / NULLIF(COUNT(*), 0), 2) AS taux_retard_pct, ROUND(AVG(ca.date_livraison - ca.date_livraison_prevue), 2) AS ecart_moyen_jours FROM fournisseurs f INNER JOIN commande_achats ca ON f.fournisseur_id = ca.fournisseur_id GROUP BY f.fournisseur_id, f.nom_fournisseur, f.pays ORDER BY taux_retard_pct DESC, montant_total_achats DESC) TO 'data/processed/performance_fournisseurs.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- 7. Produits dont le stock est en alerte
\copy (SELECT s.stocks_id, p.produit_id, p.nom_produit, p.categorie, s.quantite_disponible, s.seuil_alerte, s.seuil_alerte - s.quantite_disponible AS quantite_manquante_pour_atteindre_le_seuil, s.alerte_stock FROM stocks s INNER JOIN produits p ON s.produit_id = p.produit_id WHERE s.alerte_stock = TRUE ORDER BY s.quantite_disponible ASC) TO 'data/processed/alertes_stocks.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- 8. Synthese de rentabilite par categorie
\copy (SELECT p.categorie, ROUND(SUM(cv.montant_vente), 2) AS chiffre_affaires, ROUND(SUM(cv."quantité" * p.cout_unitaire), 2) AS cout_estime, ROUND(SUM(cv.montant_vente) - SUM(cv."quantité" * p.cout_unitaire), 2) AS marge_brute_estimee, ROUND(100.0 * (SUM(cv.montant_vente) - SUM(cv."quantité" * p.cout_unitaire)) / NULLIF(SUM(cv.montant_vente), 0), 2) AS taux_marge_pct FROM commande_ventes cv INNER JOIN produits p ON cv.produit_id = p.produit_id GROUP BY p.categorie ORDER BY marge_brute_estimee DESC) TO 'data/processed/rentabilite_categories.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');
