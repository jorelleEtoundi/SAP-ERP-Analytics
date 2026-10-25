-- =================================
-- Création du modle relationnel
-- =================================

CREATE TABLE IF NOT EXISTS clients (
    client_id INTEGER PRIMARY KEY,
    nom_client VARCHAR(150) NOT NULL,
    ville VARCHAR(100),
    pays VARCHAR(100),
    date_creation DATE
);

CREATE TABLE IF NOT EXISTS produits (
    produit_id INTEGER PRIMARY KEY,
    nom_produit VARCHAR(150) NOT NULL,
    categorie VARCHAR(100),
    prix_unitaire NUMERIC(12, 2) NOT NULL CHECK (prix_unitaire >= 0),
    cout_unitaire NUMERIC(12, 2) NOT NULL CHECK (cout_unitaire >= 0)
);

CREATE TABLE IF NOT EXISTS fournisseurs (
    fournisseur_id INTEGER PRIMARY KEY,
    nom_fournisseur VARCHAR(150) NOT NULL,
    pays VARCHAR(100),
    delai_livraison_prevu INTEGER NOT NULL
        CHECK (delai_livraison_prevu >=0)
);

CREATE TABLE IF NOT EXISTS commande_ventes (
    commande_ventes_id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(client_id),
    produit_id INTEGER NOT NULL REFERENCES produits(produit_id),
    date_commande DATE NOT NULL,
    quantité INTEGER NOT NULL CHECK (quantité > 0),
    statut VARCHAR(50),
    prix_unitaire NUMERIC(12, 2) NOT NULL CHECK (prix_unitaire >= 0),
    montant_vente NUMERIC(14, 2) NOT NULL CHECK (montant_vente >= 0)
);

CREATE TABLE IF NOT EXISTS commande_achats (
    commande_achats_id INTEGER PRIMARY KEY,
    fournisseur_id INTEGER NOT NULL REFERENCES fournisseurs(fournisseur_id),
    produit_id INTEGER NOT NULL REFERENCES produits(produit_id),
    date_commande DATE NOT NULL,
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    cout_unitaire NUMERIC(12, 2) NOT NULL CHECK (cout_unitaire >= 0),
    delai_livraison_prevu INTEGER NOT NULL CHECK(delai_livraison_prevu >= 0),
    prix_achat_unitaire NUMERIC(12, 2) NOT NULL CHECK (prix_achat_unitaire >= 0),
    date_livraison_prevue DATE NOT NULL,
    date_livraison DATE NOT NULL,
    livraison_en_retard BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS stocks (
    stocks_id INTEGER PRIMARY KEY,
    produit_id INTEGER NOT NULL REFERENCES produits(produit_id),
    quantite_disponible INTEGER NOT NULL CHECK (quantite_disponible >= 0),
    seuil_alerte INTEGER NOT NULL CHECK (seuil_alerte >= 0),
    date_maj DATE NOT NULL,
    alerte_stock BOOLEAN NOT NULL
);

-- Index pour les jointures et analyses

CREATE INDEX IF NOT EXISTS idx_ventes_client
    ON commande_ventes(client_id);

CREATE INDEX IF NOT EXISTS idx_ventes_produits
    ON commande_ventes(produit_id);

CREATE INDEX IF NOT EXISTS idx_achats_fournisseur
    ON commande_achats(fournisseur_id);

CREATE INDEX IF NOT EXISTS idx_achats_produit
    ON commande_achats(produit_id);

CREATE INDEX IF NOT EXISTS idx_ventes_date
    ON commande_ventes(date_commande);

CREATE INDEX IF NOT EXISTS idx_achats_date
    ON commande_achats(date_commande);