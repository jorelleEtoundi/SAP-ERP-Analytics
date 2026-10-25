from pathlib import Path

import numpy as np
import pandas as pd

rng = np.random.default_rng(456)

BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data" / "raw"

produits = pd.read_csv(RAW_DIR / "produits.csv")

n = len(produits)

stocks = pd.DataFrame({
    "stock_id": range(1, n + 1),
    "produit_id": produits["produit_id"],
    "quantite_disponible": rng.integers(0,201, size=n),
    "seuil_alerte": rng.integers(10, 51, size=n),
    "date_maj": pd.Timestamp("2026-10-01")
})

# Identification des produits sous leur seuil d'alerte
stocks["alerte_stock"] = (
    stocks["quantite_disponible"] < stocks["seuil_alerte"]
)

# Exportation du fichier
stocks.to_csv(RAW_DIR / "stocks.csv", index=False)

print("Génération des stocks terminée.")
print(f"Nombre de produits en stock : {len(stocks)}")
print(
    "Produits sous le seuiln d'alerte : "
    f"{stocks['alerte_stock'].sum()}"
)
print(f"Fichier enregistré dans : {RAW_DIR / 'stocks.csv'}")