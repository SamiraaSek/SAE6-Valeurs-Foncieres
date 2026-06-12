USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Ventes_fonciere')
BEGIN
    ALTER DATABASE Ventes_fonciere SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Ventes_fonciere;
END
GO
CREATE DATABASE Ventes_fonciere;
GO
USE Ventes_fonciere;
GO
ALTER DATABASE Ventes_fonciere SET RECOVERY SIMPLE;
GO

-- NIVEAU 1 : TABLES SANS DÉPENDANCES
CREATE TABLE COMMUNE (
    id_commune          INT IDENTITY(1,1) PRIMARY KEY,
    code_commune        VARCHAR(100),
    nom_commune         VARCHAR(500),
    code_departement    VARCHAR(20),
    ancien_code_commune VARCHAR(100),
    ancien_nom_commune  VARCHAR(500)
);

CREATE TABLE BIEN (
    id_bien                   INT IDENTITY(1,1) PRIMARY KEY,
    code_type_local           VARCHAR(50),
    type_local                VARCHAR(200),
    surface_reelle_bati       FLOAT NULL,
    nombre_pieces_principales INT NULL
);

CREATE TABLE Nature_culture (
    id_nature_culture   INT IDENTITY(1,1) PRIMARY KEY,
    code_nature_culture VARCHAR(50),
    nature_culture      VARCHAR(200)
);

CREATE TABLE Nature_culture_speciale (
    id_nature_culture_speciale   INT IDENTITY(1,1) PRIMARY KEY,
    code_nature_culture_speciale VARCHAR(50),
    nature_culture_speciale      VARCHAR(200)
);

-- NIVEAU 2 : TABLES AVEC CLÉS ÉTRANGÈRES
CREATE TABLE ADRESSE (
    id_adresse        INT IDENTITY(1,1) PRIMARY KEY,
    adresse_numero    VARCHAR(50),
    adresse_suffixe   VARCHAR(50),
    adresse_code_voie VARCHAR(100),
    adresse_nom_voie  VARCHAR(500),
    code_postal       VARCHAR(20),
    longitude         FLOAT,
    latitude          FLOAT,
    id_commune        INT REFERENCES COMMUNE(id_commune)
);

CREATE TABLE PARCELLE (
    n_parcelle            INT IDENTITY(1,1) PRIMARY KEY,
    id_parcelle           VARCHAR(100),
    ancien_id_parcelle    VARCHAR(100),
    lot_1_surface_terrain FLOAT,
    lot_2_surface_terrain FLOAT,
    lot_3_surface_terrain FLOAT,
    lot_4_surface_terrain FLOAT,
    lot_5_surface_terrain FLOAT,
    lot_1_numero          VARCHAR(100),
    lot_2_numero          VARCHAR(100),
    lot_3_numero          VARCHAR(100),
    lot_4_numero          VARCHAR(100),
    lot_5_numero          VARCHAR(100),
    numero_disposition    VARCHAR(50),
    numero_volume         VARCHAR(50),
    surface_terrain       FLOAT NULL,
    id_adresse            INT REFERENCES ADRESSE(id_adresse)
);

CREATE TABLE MUTATION (
    n_mutation      INT IDENTITY(1,1) PRIMARY KEY,
    id_mutation     VARCHAR(100),
    valeur_fonciere FLOAT,
    nature_vente    VARCHAR(200),
    date_mutation   DATE NULL,
    n_parcelle      INT REFERENCES PARCELLE(n_parcelle)
);

-- NIVEAU 3 : TABLES DE RELATIONS
CREATE TABLE Mutation_bien (
    id_mutation_bien          INT IDENTITY(1,1) PRIMARY KEY,
    n_mutation                INT REFERENCES MUTATION(n_mutation),
    id_bien                   INT REFERENCES BIEN(id_bien),
    date_mutation             DATE,
    surface_reelle_bati       FLOAT NULL,
    nombre_pieces_principales INT NULL
);

CREATE TABLE Bien_parcelle (
    id_bien    INT REFERENCES BIEN(id_bien),
    n_parcelle INT REFERENCES PARCELLE(n_parcelle),
    PRIMARY KEY (id_bien, n_parcelle)
);

CREATE TABLE Parcelle_nat_cult (
    n_parcelle        INT REFERENCES PARCELLE(n_parcelle),
    id_nature_culture INT REFERENCES Nature_culture(id_nature_culture),
    PRIMARY KEY (n_parcelle, id_nature_culture)
);

CREATE TABLE Parcelle_nat_cult_spe (
    n_parcelle                 INT REFERENCES PARCELLE(n_parcelle),
    id_nature_culture_speciale INT REFERENCES Nature_culture_speciale(id_nature_culture_speciale),
    PRIMARY KEY (n_parcelle, id_nature_culture_speciale)
);
GO