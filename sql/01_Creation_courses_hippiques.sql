-- SQL Server 2019 ou ultérieur. Création sur une base de projet vide.
USE master;
GO
IF DB_ID(N'courses_hippiques') IS NULL
    EXEC (N'CREATE DATABASE courses_hippiques COLLATE French_100_CI_AI;');
GO
USE courses_hippiques;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF DB_NAME() <> N'courses_hippiques'
    THROW 51000, N'Base de projet introuvable.', 1;
IF CONVERT(sysname, DATABASEPROPERTYEX(DB_NAME(), 'Collation')) <> N'French_100_CI_AI'
    THROW 51001, N'La base doit utiliser la collation French_100_CI_AI.', 1;
IF EXISTS (SELECT 1 FROM sys.tables WHERE is_ms_shipped = 0)
    THROW 51002, N'La base contient déjà des tables. Aucune table modifiée.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.proprietaire (
        id_proprietaire INT IDENTITY(1,1) PRIMARY KEY,
        nom_proprietaire NVARCHAR(80) NOT NULL,
        prenom_proprietaire NVARCHAR(80) NOT NULL,
        date_nais_proprietaire DATE NOT NULL,
        civilite_proprietaire NVARCHAR(20) NOT NULL,
        CONSTRAINT ck_proprietaire_noms CHECK (
            LEN(nom_proprietaire) > 0 AND LEN(prenom_proprietaire) > 0
        ),
        CONSTRAINT ck_proprietaire_civilite CHECK (
            civilite_proprietaire COLLATE Latin1_General_100_BIN2 IN (N'M', N'Mme')
            AND DATALENGTH(civilite_proprietaire) = 2 * LEN(civilite_proprietaire)
        )
    );

    CREATE TABLE dbo.entraineur (
        id_entraineur INT IDENTITY(1,1) PRIMARY KEY,
        nom_entraineur NVARCHAR(80) NOT NULL,
        prenom_entraineur NVARCHAR(80) NOT NULL,
        date_nais_entraineur DATE NOT NULL,
        civilite_entraineur NVARCHAR(20) NOT NULL,
        localisation_entraineur NVARCHAR(80) NOT NULL,
        CONSTRAINT ck_entraineur_textes CHECK (
            LEN(nom_entraineur) > 0 AND LEN(prenom_entraineur) > 0
            AND LEN(localisation_entraineur) > 0
        ),
        CONSTRAINT ck_entraineur_civilite CHECK (
            civilite_entraineur COLLATE Latin1_General_100_BIN2 IN (N'M', N'Mme')
            AND DATALENGTH(civilite_entraineur) = 2 * LEN(civilite_entraineur)
        )
    );

    CREATE TABLE dbo.jockey (
        id_jockey INT IDENTITY(1,1) PRIMARY KEY,
        nom_jockey NVARCHAR(80) NOT NULL,
        prenom_jockey NVARCHAR(80) NOT NULL,
        date_nais_jockey DATE NOT NULL,
        civilite_jockey NVARCHAR(20) NOT NULL,
        CONSTRAINT ck_jockey_noms CHECK (
            LEN(nom_jockey) > 0 AND LEN(prenom_jockey) > 0
        ),
        CONSTRAINT ck_jockey_civilite CHECK (
            civilite_jockey COLLATE Latin1_General_100_BIN2 IN (N'M', N'Mme')
            AND DATALENGTH(civilite_jockey) = 2 * LEN(civilite_jockey)
        )
    );

    CREATE TABLE dbo.cheval (
        id_cheval INT IDENTITY(1,1) PRIMARY KEY,
        nom_cheval NVARCHAR(80) NOT NULL,
        date_nais_cheval DATE NOT NULL,
        couleur_cheval NVARCHAR(20) NOT NULL,
        specialite_cheval NVARCHAR(20) NOT NULL,
        nom_pere_cheval NVARCHAR(80) NOT NULL,
        nom_mere_cheval NVARCHAR(80) NOT NULL,
        sexe_cheval NVARCHAR(20) NOT NULL,
        id_proprietaire INT NOT NULL,
        id_entraineur INT NOT NULL,
        CONSTRAINT ck_cheval_textes CHECK (
            LEN(nom_cheval) > 0 AND LEN(couleur_cheval) > 0
            AND LEN(specialite_cheval) > 0 AND LEN(nom_pere_cheval) > 0
            AND LEN(nom_mere_cheval) > 0 AND LEN(sexe_cheval) > 0
        ),
        CONSTRAINT fk_cheval_proprietaire FOREIGN KEY (id_proprietaire)
            REFERENCES dbo.proprietaire (id_proprietaire),
        CONSTRAINT fk_cheval_entraineur FOREIGN KEY (id_entraineur)
            REFERENCES dbo.entraineur (id_entraineur)
    );

    CREATE TABLE dbo.course (
        id_course INT IDENTITY(1,1) PRIMARY KEY,
        libelle_course NVARCHAR(100) NOT NULL,
        date_course DATE NOT NULL,
        hippodrome NVARCHAR(100) NOT NULL,
        nb_max_chevaux SMALLINT NULL,
        allocation_1 DECIMAL(12,2) NOT NULL,
        allocation_2 DECIMAL(12,2) NOT NULL,
        allocation_3 DECIMAL(12,2) NOT NULL,
        allocation_4 DECIMAL(12,2) NOT NULL,
        allocation_5 DECIMAL(12,2) NOT NULL,
        age_max_course SMALLINT NULL,
        sexe_course NVARCHAR(20) NULL,
        arrivee_definitive BIT NOT NULL CONSTRAINT df_course_arrivee DEFAULT (0),

        CONSTRAINT ck_course_textes CHECK (
            LEN(libelle_course) > 0 AND LEN(hippodrome) > 0
        ),
        CONSTRAINT ck_course_nb_max CHECK (nb_max_chevaux BETWEEN 0 AND 999),
        CONSTRAINT ck_course_age_max CHECK (age_max_course BETWEEN 0 AND 999),
        CONSTRAINT ck_course_allocations CHECK (
            allocation_1 >= 0 AND allocation_2 >= 0 AND allocation_3 >= 0
            AND allocation_4 >= 0 AND allocation_5 >= 0
        ),
        CONSTRAINT ck_course_sexe CHECK (
            sexe_course IS NULL OR (
                sexe_course COLLATE Latin1_General_100_BIN2
                    IN (N'mâle', N'femelle', N'les deux')
                AND DATALENGTH(sexe_course) = 2 * LEN(sexe_course)
            )
        )
    );

    CREATE TABLE dbo.engagement (
        id_engagement INT IDENTITY(1,1) PRIMARY KEY,
        rang_arrivee SMALLINT NULL,
        temps_secondes DECIMAL(10,3) NULL,
        id_cheval INT NOT NULL,
        id_course INT NOT NULL,
        id_jockey INT NOT NULL,
        CONSTRAINT fk_engagement_cheval FOREIGN KEY (id_cheval)
            REFERENCES dbo.cheval (id_cheval),
        CONSTRAINT fk_engagement_course FOREIGN KEY (id_course)
            REFERENCES dbo.course (id_course),
        CONSTRAINT fk_engagement_jockey FOREIGN KEY (id_jockey)
            REFERENCES dbo.jockey (id_jockey),
        CONSTRAINT uq_engagement_cheval_course UNIQUE (id_cheval, id_course),
        CONSTRAINT ck_engagement_rang CHECK (rang_arrivee > 0),
        CONSTRAINT ck_engagement_temps CHECK (temps_secondes >= 0)
    );

    CREATE TABLE dbo.utilisateur (
        id_utilisateur INT IDENTITY(1,1) PRIMARY KEY,
        identifiant NVARCHAR(80) NOT NULL,
        mot_de_passe NVARCHAR(255) NOT NULL,
        role_utilisateur NVARCHAR(30) NOT NULL,
        compte_actif BIT NOT NULL CONSTRAINT df_utilisateur_actif DEFAULT (1),
        CONSTRAINT uq_utilisateur_identifiant UNIQUE (identifiant),
        CONSTRAINT ck_utilisateur_textes CHECK (
            LEN(identifiant) > 0 AND LEN(mot_de_passe) > 0
            AND LEN(role_utilisateur) > 0
        )
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
