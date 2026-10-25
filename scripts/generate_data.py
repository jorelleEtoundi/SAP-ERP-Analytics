from pathlib import Path
import numpy as np
import pandas as pd

# Reproductibilité : ici les données seront identiques à chaque exécution

rng = np.random.default_rng(42)

# Dossiers du projet
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data" / "raw"
RAW_DIR.mkdir(parents=True, exist_ok=True)

# 1. Clients

villes = [
    "Paris","Lyon", "Marseille", "Lille", 
    "Toulouse", "Nantes", "Bordeaux", "Strasbourg"
]

clients = pd.DataFrame({
    "client_id": range(1, 201),
    "nom_client" : [f"Client_{i:03d}" for i in range(1, 201)],
    "ville": rng.choice(villes, size=200),
    "pays": "France",
    "Date_creation":pd.to_datetime(
        rng.integers(
            pd.Timestamp("2020-01-01").value // 10**9,
            pd.Timestamp("2026-01-01").value // 10**9,
            size=200
        ),
        unit="s"
    ).date
})

# 2. Produits
categories = {
    "Informatique": ["Ordinateur", "Écran", "Clavier", "Souris"],
    "Mobilier": ["Bureau", "Chaise", "Armoire", "Étagère"],
    "Fournitures": ["Papier", "Stylo", "Cahier", "Classeur"],
    "Électronique": ["Casque", "Webcam", "Microphone", "Hub USB"]
}

n_produits = 50
categories_produits = rng.choice(
    list(categories.keys()),
    size=n_produits
)

noms_produits = [
    rng.choice(categories[categorie])
    for categorie in categories_produits
]

couts = np.round(rng.uniform(5, 800, size=n_produits), 2)
marges = rng.uniform(1.15, 1.60, size=n_produits)

produits = pd.DataFrame({
    "produit_id": range(1, n_produits + 1),
    "nom_produit": [
        f"{nom}_{i:03d}"
        for i, nom in enumerate(noms_produits, start=1)
    ],
    "categorie": categories_produits,
    "prix_unitaire": np.round(couts * marges, 2),
    "cout_unitaire": couts
})

# 3. Fournisseurs
pays_fournisseurs = [
    "France", "Allemagne", "Italie", 
    "Espagne", "Belgique", "Pays-Bas"
]

fournisseurs = pd.DataFrame({
    "fournisseur_id": range(1, 16),
    "nom_fournisseurr": [
        f"Fournisseur_{i:03d}" for i in range(1, 16)
    ],
    "pays": rng.choice(pays_fournisseurs, size=15),
    "delai_livraison_prevu": rng.integers(2, 16, size=15)
})

# 4. Export des fichiers CSV
clients.to_csv(RAW_DIR / "clients.csv", index=False)
produits.to_csv(RAW_DIR / "produits.csv", index=False)
fournisseurs.to_csv(RAW_DIR / "fournisseurs.csv", index=False)

print("Géneration des données terminée.")
print(f"Clients : {len(clients)} lignes")
print(f"Produits : {len(produits)} lignes")
print(f"Fournisseurs : {len(fournisseurs)} lignes")
print(f"Fichiers enregistrés dans : {RAW_DIR}")