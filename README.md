# SAP-ERP-Analytics

**Analyse des ventes, des achats, de la rentabilité et des stocks à partir de données ERP simulées.**

## Présentation du projet

SAP-ERP-Analytics est un projet de portfolio Data Analytics inspiré des processus de gestion rencontrés dans un environnement ERP. Il vise à transformer des données opérationnelles simulées en indicateurs utiles au pilotage de l'activité.

Le projet couvre plusieurs domaines : ventes, produits, clients, fournisseurs, achats et stocks. Il combine Python, PostgreSQL, SQL et Power BI Web pour illustrer un processus d'analyse de données, de la génération des données jusqu'à leur visualisation.

> **Périmètre :** ce projet utilise des données synthétiques. Il ne s'agit pas d'une connexion réelle à un système SAP.

## Objectifs métier

- Suivre le chiffre d'affaires et les quantités vendues.
- Identifier les produits et catégories qui contribuent le plus aux ventes.
- Analyser la contribution des clients au chiffre d'affaires.
- Évaluer les retards de livraison des fournisseurs.
- Repérer les produits dont le stock est inférieur au seuil d'alerte.
- Estimer la marge brute à partir du chiffre d'affaires et des coûts unitaires de référence.
- Construire des indicateurs et des visualisations facilitant la prise de décision.

## Technologies utilisées

- **Python et pandas** : génération, préparation et validation des données.
- **PostgreSQL** : stockage relationnel et requêtes analytiques.
- **SQL** : agrégations, indicateurs métier, analyses de ventes, d'achats, de stocks et de rentabilité.
- **Power BI Web** : création du tableau de bord interactif.
- **Git et GitHub** : versionnement et documentation du projet.

## Données simulées

Le jeu de données comprend six tables :

| Table | Description |
|---|---|
| `clients` | Informations sur les clients |
| `produits` | Catégories, prix et coûts unitaires des produits |
| `fournisseurs` | Informations sur les fournisseurs et délais prévus |
| `commande_ventes` | Lignes de vente, quantités, prix et montants |
| `commande_achats` | Achats, dates de livraison et retards |
| `stocks` | Quantités disponibles et seuils d'alerte |

Les données sont générées par les scripts Python du dossier `scripts/`.

## Architecture du projet

```text
SAP-ERP-Analytics/
├── data/
│   ├── raw/
│   └── processed/
├── docs/
│   └── data_model.md
├── powerbi/
├── scripts/
│   ├── generate_data.py
│   ├── generate_stock.py
│   ├── generate_transactions.py
│   └── validate_data.py
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_analyse_ventes.sql
│   ├── 03_analyse_produits.sql
│   ├── 04_analyse_categories.sql
│   ├── 05_Analyse_clients.sql
│   ├── 06_Analyse_achats_fournisseurs.sql
│   ├── 07_analyse_stocks.sql
│   ├── 08_analyse_rentabilite.sql
│   ├── 09_synthese_kpi.sql
│   └── 10_exports_powerbi.sql
└── README.md
```

## Principales analyses SQL

- Chiffre d'affaires global et évolution mensuelle des ventes.
- Performance des produits et des catégories.
- Classement des clients selon leur chiffre d'affaires.
- Montants d'achats et performance des fournisseurs.
- Détection des alertes de stock.
- Estimation de la marge brute par produit et catégorie.
- Synthèse des KPI et export des résultats pour Power BI.

## Résultats clés

Sur le jeu de données actuel, les analyses produisent notamment les résultats suivants :

| Indicateur | Résultat |
|---|---:|
| Lignes de vente | 1 000 |
| Chiffre d'affaires | 5 155 909,61 |
| Montant total des achats | 5 914 083,93 |
| Marge brute estimée | 1 411 136,67 |
| Taux de marge brute estimée | 27,37 % |
| Clients | 200 |
| Produits | 50 |
| Fournisseurs | 15 |
| Lignes d'achat en retard | 86 |
| Produits en alerte de stock | 9 |

**À noter :** les montants sont issus des données synthétiques du projet. La marge est une estimation calculée à partir des coûts unitaires de référence ; elle ne représente pas nécessairement la marge comptable historique ni le bénéfice net. Le nombre de lignes d'achat en retard ne correspond pas nécessairement au nombre de commandes distinctes.

## Tableau de bord Power BI

Le tableau de bord présente les indicateurs globaux et plusieurs angles d'analyse :

- évolution mensuelle des ventes ;
- répartition des ventes par catégorie ;
- rentabilité estimée des produits ;
- analyse des achats et de la fiabilité des fournisseurs ;
- disponibilité des stocks et alertes.

Une capture du tableau de bord sera ajoutée ici lorsque le fichier image aura été placé dans le dépôt.

## Reproduire le projet

### 1. Cloner le dépôt

```bash
git clone https://github.com/jorelleEtoundi/SAP-ERP-Analytics.git
cd SAP-ERP-Analytics
```

### 2. Préparer l'environnement Python

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3. Générer et valider les données

Consulter les scripts disponibles dans `scripts/`. Exécuter les scripts de génération dans l'ordre adapté à leurs dépendances, puis lancer le script de validation.

### 4. Créer la base PostgreSQL

Créer une base PostgreSQL dédiée au projet, puis exécuter le script `sql/01_create_tables.sql`. Importer ensuite les fichiers CSV générés dans les tables correspondantes.

Exécuter les scripts d'analyse SQL dans l'ordre numérique. Le script `sql/10_exports_powerbi.sql` prépare les exports destinés à Power BI.

Les noms de base de données, paramètres de connexion et chemins locaux doivent être adaptés à l'environnement utilisé.

## Limites et pistes d'amélioration

- Les données sont synthétiques et ne proviennent pas d'un ERP réel.
- La marge brute est estimée à partir des coûts de référence disponibles.
- Les analyses peuvent être enrichies par des indicateurs temporels, des contrôles qualité supplémentaires et une automatisation du pipeline.

## Compétences illustrées

Python · pandas · PostgreSQL · SQL · modélisation relationnelle · contrôle qualité des données · KPI métier · Power BI · Git/GitHub
