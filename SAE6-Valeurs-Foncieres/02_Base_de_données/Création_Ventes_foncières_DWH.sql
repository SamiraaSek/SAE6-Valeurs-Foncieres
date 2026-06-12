USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Ventes_fonciere_DWH')
BEGIN
    ALTER DATABASE Ventes_fonciere_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Ventes_fonciere_DWH;
END
GO
CREATE DATABASE Ventes_fonciere_DWH;
GO
USE Ventes_fonciere_DWH;
GO
ALTER DATABASE Ventes_fonciere_DWH SET RECOVERY SIMPLE;
GO

-- DIMENSIONS
CREATE TABLE DIM_TEMPS (
    id_date      INT IDENTITY(1,1) PRIMARY KEY,
    date_mutation DATE,
    annee        INT,
    trimestre_   INT,
    mois         INT
);

CREATE TABLE DIM_BIEN (
    id_bien                   INT PRIMARY KEY,
    code_type_local           VARCHAR(50),
    type_local                VARCHAR(200),
    surface_reelle_bati       FLOAT NULL,
    nombre_pieces_principales INT NULL
);

CREATE TABLE DIM_ADRESSE (
    id_adresse        INT PRIMARY KEY,
    adresse_numero    VARCHAR(50),
    adresse_suffixe   VARCHAR(50),
    adresse_code_voie VARCHAR(100),
    adresse_nom_voie  VARCHAR(500),
    code_postal       VARCHAR(20),
    longitude         FLOAT,
    latitude          FLOAT,
    code_commune      VARCHAR(100),
    nom_commune       VARCHAR(500),
    code_departement  VARCHAR(20),
    ancien_code_commune VARCHAR(100),
    ancien_nom_commune  VARCHAR(500)
);

CREATE TABLE DIM_PARCELLE (
    n_parcelle            INT PRIMARY KEY,
    id_parcelle           VARCHAR(100),
    lot_1_surface_terrain FLOAT,
    lot_2_surface_terrain FLOAT,
    lot_3_surface_terrain FLOAT,
    lot_4_surface_terrain FLOAT,
    lot_5_surface_terrain FLOAT
);

-- TABLE DE FAITS
CREATE TABLE FAIT_MUTATION (
    id_mutation           VARCHAR(100) PRIMARY KEY,
    valeur_fonciere       FLOAT,
    nature_vente          VARCHAR(200),
    n_parcelle            INT REFERENCES DIM_PARCELLE(n_parcelle),
    id_date               INT REFERENCES DIM_TEMPS(id_date),
    id_adresse            INT REFERENCES DIM_ADRESSE(id_adresse),
    id_bien               INT REFERENCES DIM_BIEN(id_bien),
    nb_maisons            INT DEFAULT 0,
    nb_appart             INT DEFAULT 0,
    nb_dependance         INT DEFAULT 0,
    nb_localindu          INT DEFAULT 0,
    nb_pasdelocal         INT DEFAULT 0,
    surface_bati_totale   FLOAT DEFAULT 0,
    surface_bati_moyenne  FLOAT DEFAULT 0,
    nb_pieces_total       INT DEFAULT 0
);
GO