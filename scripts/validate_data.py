from pathlib import Path

import pandas as pd

BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data" / "raw"

# Chargement des six fichiers

clients = pd.read_csv(RAW_DIR / "clients.csv")
produits = pd.read_csv(RAW_DIR / "produits.csv")
fournisseurs = pd.read_csv(RAW_DIR / "fournisseurs.csv")
ventes = pd.read_csv(RAW_DIR / "commande_ventes.csv")
achats = pd.read_csv(RAW_DIR / "commande_achats.csv")
stocks = pd.read_csv(RAW_DIR / "stocks.csv")

tables = {
    "clients": clients,
    "produits": produits,
    "fournisseurs": fournisseurs,
    "ventes": ventes,
    "achats": achats,
    "stocks": stocks,
}

print("=" * 60)
print("1. Dimensions, valeurs manquantes et doublons")
print("=" * 60)

for nom, df in tables.items():
    print(f"\n{nom}")
    print(f" Lignes : {len(df)}")
    print(f" Colonnes : {len(df.columns)}")
    print(f" Valeurs manquantes : {df.isna().sum().sum()}")
    print(f" Lignes dupliquées : {df.duplicated().sum()}")
    
# Vérification de l'unicité des identifiants 
print("\n" + "=" * 60)
print("2. Unicité des identifiants")
print("=" * 60)

cles_primaires = [
    ("clients", clients, "client_id"),
    ("produits", produits, "produit_id"),
    ("fournisseurs", fournisseurs, "fournisseur_id"),
    ("ventes", ventes, "commande_vente_id"),
    ("achats", achats, "commande_achat_id"),
    ("stocks", stocks, "stock_id")
]

for nom_table, df, colonne in cles_primaires:
    doublons = df[colonne].duplicated().sum()
    print(f"{nom_table}.{colonne} : {doublons} identifiant(s) dupliqué(s)")

relations = [
    ("ventes -> clients", ventes, "client_id", clients, "client_id"),
    ("ventes -> produits", ventes, "produit_id", produits, "produit_id"),
    ("achats -> fournisseurs", achats, "fournisseur_id", fournisseurs, "fournisseur_id"),
    ("achats -> produits", achats, "produit_id", produits, "produit_id"),
    ("stocks -> produits", stocks, "produit_id", produits,"produit_id"),
]

for nom, source, colonne, cible, cle in relations:
    invalides = ~source[colonne].isin(cible[cle])
    print(f"{nom} : {invalides.sum()} référence(s) invalide(s)")
    
# Vérification des montants et les quantités
print("\n" + "=" * 60)
print("4. Controles métier")
print("=" * 60)

print(
    "Ventes avec quantité <= 0 :",
    (ventes["quantite"] <= 0).sum()
)

print(
    "Ventes avec montant négatif :",
    (ventes["montant_vente"] < 0).sum()
)

print(
    "Achats avec quantité <= 0 :",
    (achats["quantite"] <= 0).sum()
)

print(
    "Achats avec montant négatif :",
    ((achats["quantite"] * achats["prix_achat_unitaire"]) < 0).sum()
)

print(
    "Stocks avec quantité négative :",
    (stocks["quantite_disponible"] < 0).sum()
)

print(
    "Stocks sous le seuil d'alerte sans alerte :",
    (
        (stocks["quantite_disponible"] <= stocks["seuil_alerte"])
        & (~stocks["alerte_stock"].astype(bool))
    ).sum()
)
date_prevue = pd.to_datetime(achats["date_livraison_prevue"])
date_reelle = pd.to_datetime(achats["date_livraison"])

retard_calcule = date_reelle > date_prevue
retard_declare = achats["livraison_en_retard"].astype(bool)

print(
    "Incoherences sur les retards de livraison :",
    (retard_calcule != retard_declare).sum()
)

# Vérification de la coherence des dates de livraison
achats["date_livraison_prevue"] = pd.to_datetime(
    achats["date_livraison_prevue"]
)
achats["date_livraison"] = pd.to_datetime(
    achats["date_livraison"]
)

retards_incoherents = (
    (date_reelle > date_prevue) != retard_declare
).sum()

print("Indicateurs de retard incoherents : ", retards_incoherents)
print("\nControle qualité terminé.")