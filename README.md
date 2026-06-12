# SAE 6 — Analyse des Valeurs Foncières
### De la donnée brute au tableau de bord décisionnel

> **IUT Université de Lille — BUT Science de la Donnée — 2025-2026**  
> Carmelle QUENUM & Samira SEKONGO

---

## Problématique

> *Comment transformer un jeu de données brutes sur les transactions immobilières en une solution décisionnelle complète, permettant d'analyser les valeurs foncières sur le territoire français ?*

---

## Structure du projet

```
SAE6-Valeurs-Foncieres/
├── 01_Données/               → Source des données (lien data.gouv.fr)
├── 02_Base_de_données/       → Scripts SQL (MCD, MLD, création tables)
├── 03_ETL/                   → Script Python + Packages SSIS (.dtsx)
├── 04_PowerBI/               → Tableau de bord (.pbix)
├── 05_Documentation/         → Rapport, documentation, cahier de recette
└── README.md
```

---

## Pipeline de données

```
CSV brut (DVF data.gouv.fr)
        ↓
Script Python (nettoyage + chargement)
        ↓
Base relationnelle : Ventes_fonciere (SQL Server)
        ↓
ETL SSIS (transformation + chargement DWH)
        ↓
Entrepôt décisionnel : Ventes_fonciere_DWH (schéma en étoile)
        ↓
Tableau de bord Power BI
```

---

## Source des données

| Élément | Détail |
|---|---|
| Source | [data.gouv.fr — DVF Géolocalisées](https://www.data.gouv.fr/datasets/demandes-de-valeurs-foncieres-geolocalisees/) |
| Période | 2020 — 2025 |
| Nombre de lignes | 20 102 739 lignes |
| Format | CSV (séparateur `;`) |

---

## 🗄️ Modèle décisionnel (schéma en étoile)

```
                    DIM_TEMPS
                        |
DIM_ADRESSE — FAIT_MUTATION — DIM_BIEN
                        |
                   DIM_PARCELLE
```

| Table | Rôle |
|---|---|
| `FAIT_MUTATION` | Table de faits centrale |
| `DIM_TEMPS` | Dimension temporelle (année, trimestre, mois) |
| `DIM_BIEN` | Dimension type de bien immobilier |
| `DIM_ADRESSE` | Dimension géographique (commune, département, GPS) |
| `DIM_PARCELLE` | Dimension parcelle (surface, nature de culture) |

---

## ETL Niveau 1 — Script Python

Le script `03_ETL/script_python_integration.py` charge les données brutes du CSV vers la base relationnelle source.

**Traitements effectués :**
- Conversion des décimales (virgule → point)
- Gestion des dates multi-formats (`dd/MM/yyyy` et `yyyy-MM-dd`)
- Normalisation des chaînes (strip, majuscules, NULL → vide)
- Dédoublonnage par sous-ensemble de colonnes
- Vérification des clés existantes avant insertion
- Chargement dans l'ordre des dépendances de clés étrangères

---

## ⚙️ ETL Niveau 2 — SSIS

Le projet SSIS `03_ETL/ETL_SSIS/` contient 7 packages orchestrés séquentiellement :

| Package | Rôle |
|---|---|
| `00_Alim_DWH.dtsx` | Orchestrateur principal |
| `01_Vider_DWH.dtsx` | Vide les tables avant rechargement |
| `02_Alim_DIM_TEMPS.dtsx` | Alimentation dimension temporelle |
| `03_Alim_DIM_BIEN.dtsx` | Alimentation dimension bien |
| `04_Alim_DIM_PARCELLE.dtsx` | Alimentation dimension parcelle |
| `05_Alim_DIM_ADRESSE.dtsx` | Alimentation dimension adresse |
| `06_ALIM_FAIT_MUTATION.dtsx` | Alimentation table de faits |

---

## Tableau de bord Power BI

Le tableau de bord contient **5 pages d'analyse + 1 page qualité** :

| Page | Contenu |
|---|---|
| Vue générale | KPIs globaux, évolution annuelle, répartition par nature de vente |
| Analyse temporelle | Drill-down année→trimestre→mois, saisonnalité |
| Analyse géographique | Carte à bulles, top 10 communes et départements |
| Analyse par type de bien | Maisons vs appartements, prix au m², surfaces |
| Analyse des parcelles | Nature de culture, surfaces, corrélations |
| Audit qualité | Taux de complétude par colonne, valeurs manquantes |

---

## Livrables

| Livrable | Fichier |
|---|---|
| Rapport complet | `05_Documentation/Rapport_SAE6.pdf` |
| Documentation Power BI | `05_Documentation/Documentation_PowerBI_SAE6.pdf` |
| Cahier de recette | `05_Documentation/Cahier_Recette_PowerBI_SAE6.pdf` |
| Script Python ETL | `03_ETL/script_python_integration.py` |
| Packages SSIS | `03_ETL/ETL_SSIS/` |

---

## Technologies utilisées

![Python](https://img.shields.io/badge/Python-3.x-blue)
![SQL Server](https://img.shields.io/badge/SQL_Server-2019-red)
![SSIS](https://img.shields.io/badge/SSIS-Visual_Studio-purple)
![Power BI](https://img.shields.io/badge/Power_BI-Desktop-yellow)
![Polars](https://img.shields.io/badge/Polars-DataFrame-orange)

---

## Auteurs

| Nom | Rôle principal |
|---|---|
| **Carmelle QUENUM** | Script Python ETL, modélisation BDD, Power BI |
| **Samira SEKONGO** | ETL SSIS, modélisation DWH, Power BI |

---

*IUT Université de Lille — BUT Science de la Donnée — Parcours Visualisation et conception d'outils — 2025-2026*
