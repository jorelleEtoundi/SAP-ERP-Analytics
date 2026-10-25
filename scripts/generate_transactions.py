from pathlib import Path

import pandas as pd
import numpy as np

# Reproductibilité
rng = np.random.default_rng(123)

BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data" / "raw"

# Changement des référentiels existants
clients =  pd.read_csv(RAW_DIR / "clients.csv")
produits = pd.read_csv(RAW_DIR / "produits.csv")
fournisseurs = pd.read_csv(RAW_DIR / "fournisseurs.csv")

# Période simulée : Janvier à septembre 2026
DATE_DEBUT = pd.Timestamp("2026-01-01")
DATE_FIN = pd.Timestamp("2026-10-01")

def date_aleatoires(nombre):
    debut = DATE_DEBUT.value // 10**9
    fin = DATE_FIN.value // 10**9
    secondes = rng.integers(debut, fin, size=nombre)
    return pd.to_datetime(secondes, unit="s").normalize()

# 1. Commande de vente
n_ventes = 1000

ventes = pd.DataFrame({
    "commande_vente_id": range(1, n_ventes + 1),
    "client_id": rng.choice(clients["client_id"], size=n_ventes),
    "produit_id": rng.choice(produits["produit_id"], size=n_ventes),
    "date_commande": date_aleatoires(n_ventes),
    "quantite": rng.integers(1, 21, size=n_ventes),
    "statut":rng.choice(
        [
            "Livres", "En cours", "Annulee"
        ],
        size=n_ventes,
        p=[0.75, 0.18, 0.07]
    ) 
})

# Ajout des prix et calcul du montant de chaque ligne
ventes = ventes.merge(
    produits[["produit_id", "prix_unitaire"]],
    on="produit_id",
    how="left",
    validate="many_to_one"
)
ventes["montant_vente"] = (
    ventes["quantite"] * ventes["prix_unitaire"]
).round(2)

# 2. Commandes d'achat
n_achats = 300

achats = pd.DataFrame ({
    "commande_achat_id": range(1, n_achats + 1),
    "fournisseur_id": rng.choice(
        fournisseurs["fournisseur_id"], size=n_achats
    ),
    "produit_id": rng.choice(
        produits["produit_id"], size=n_achats
    ),
    "date_commande": date_aleatoires(n_achats),
    "quantite": rng.integers(5, 101, size=n_achats)
})

# Récupération des couts de produits
achats = achats.merge(
    produits[
        ["produit_id", "cout_unitaire"]
    ],
    on="produit_id",
    how="left",
    validate="many_to_one"
)

# Ajout des informations de livraison du fournisseur
achats = achats.merge(
    fournisseurs[
        ["fournisseur_id", "delai_livraison_prevu"]
    ],
    on="fournisseur_id",
    how="left",
    validate="many_to_one"
)
achats["prix_achat_unitaire"] = (
    achats["cout_unitaire"] * rng.uniform(0.90, 1.10, size=len(achats))
).round(2)

retard = rng.choice([0, 2, 5, 10], size=n_achats, p=[0.65, 0.15, 0.12, 0.08])

achats["date_livraison_prevue"] = (
    achats["date_commande"]
    + pd.to_timedelta(
        achats["delai_livraison_prevu"], 
        unit="D"
    )
)
retard = rng.choice([0, 2, 5, 10], size=len(achats), p=[0.65, 0.15, 0.12, 0.08])

achats["date_livraison"] = (
    achats["date_livraison_prevue"]
    + pd.to_timedelta(retard, unit="D")
    
)

achats["livraison_en_retard"] = (
    achats["date_livraison"] > achats["date_livraison_prevue"]
)

# 3. Export
ventes.to_csv(RAW_DIR / "commande_ventes.csv", index=False)
achats.to_csv(RAW_DIR / "commande_achats.csv", index=False)

print("Génération des transactions terminée.")
print(f"commandes de vente : {len(ventes)}")
print(f"commandes d'achat : {len(achats)}")
print(
    "Taux de retard des achats :"
    f"{achats['livraison_en_retard'].mean() * 100:.2f} %"
)
print(f"Fichier enregistrés dans : {RAW_DIR}")