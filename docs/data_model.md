# Modèle de données — SAP-ERP-Analytics

## Objectif
Simuler les données d'un système ERP pour analyser les ventes,
les achats, les stocks et la performance des fournisseurs.

## Tables

### clients
- client_id : identifiant unique du client
- nom_client : nom du client
- ville : ville du client
- pays : pays du client
- date_creation : date de création du client

### produits
- produit_id : identifiant unique du produit
- nom_produit : nom du produit
- categorie : catégorie du produit
- prix_unitaire : prix de vente unitaire
- cout_unitaire : coût d'achat unitaire

### fournisseurs
- fournisseur_id : identifiant unique du fournisseur
- nom_fournisseur : nom du fournisseur
- pays : pays du fournisseur
- delai_livraison_prevu : délai prévu en jours

### commandes_ventes
- commande_vente_id : identifiant unique de la commande
- client_id : référence au client
- produit_id : référence au produit
- date_commande : date de la commande
- quantite : quantité commandée
- statut : statut de la commande

### commandes_achats
- commande_achat_id : identifiant unique de la commande d'achat
- fournisseur_id : référence au fournisseur
- produit_id : référence au produit
- date_commande : date de commande
- date_livraison : date réelle de livraison
- quantite : quantité achetée
- prix_achat_unitaire : prix d'achat unitaire

### stocks
- stock_id : identifiant unique de l'enregistrement
- produit_id : référence au produit
- quantite_disponible : quantité en stock
- seuil_alerte : seuil minimal de stock
- date_maj : date de mise à jour du stock
