-- Jeu d’essai SQL Server. Exécuter après le script de création.
USE courses_hippiques;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF DB_NAME() <> N'courses_hippiques'
    THROW 51003, N'Base de projet introuvable.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF 7 <> (
        SELECT COUNT(*) FROM sys.identity_columns
        WHERE OBJECT_SCHEMA_NAME(object_id) = N'dbo' AND OBJECT_NAME(object_id) IN
            (N'proprietaire', N'entraineur', N'jockey', N'cheval', N'course',
             N'engagement', N'utilisateur')
        AND last_value IS NULL
    )
        THROW 51004, N'Le jeu d’essai exige les sept tables neuves.', 1;

    INSERT INTO dbo.proprietaire
        (nom_proprietaire, prenom_proprietaire, date_nais_proprietaire, civilite_proprietaire)
    VALUES
        (N'Delacroix', N'Henri', '1958-04-12', N'M'),
        (N'Montclair', N'Sophie', '1971-09-30', N'Mme'),
        (N'Van Berg', N'Étienne', '1964-01-18', N'M'),
        (N'Lefèvre', N'Marguerite', '1949-11-05', N'Mme'),
        (N'Haddad', N'Karim', '1982-06-21', N'M');

    INSERT INTO dbo.entraineur
        (nom_entraineur, prenom_entraineur, date_nais_entraineur,
         civilite_entraineur, localisation_entraineur)
    VALUES
        (N'Lagardère', N'Pascal', '1967-02-14', N'M', N'Chantilly'),
        (N'Rousseau', N'Isabelle', '1975-07-08', N'Mme', N'Maisons-Laffitte'),
        (N'Bellamy', N'Thierry', '1970-10-25', N'M', N'Senlis'),
        (N'Castaing', N'Mathilde', '1980-03-02', N'Mme', N'Pau');

    INSERT INTO dbo.jockey (nom_jockey, prenom_jockey, date_nais_jockey, civilite_jockey)
    VALUES
        (N'Carglass', N'Olivier', '1993-05-17', N'M'),
        (N'Soumillon', N'Clément', '1990-08-03', N'M'),
        (N'Guyon', N'Maxime', '1995-12-11', N'M'),
        (N'Barzalona', N'Aurélie', '1997-02-26', N'Mme'),
        (N'Lecoeuvre', N'Théo', '1999-09-09', N'M'),
        (N'Lacourte', N'Camille', '1994-04-30', N'Mme');

    INSERT INTO dbo.cheval
        (nom_cheval, date_nais_cheval, couleur_cheval, specialite_cheval,
         nom_pere_cheval, nom_mere_cheval, sexe_cheval, id_proprietaire, id_entraineur)
    VALUES
        (N'Éclair de Lune', '2022-03-14', N'Bai', N'Plat',
         N'Sunday Rain', N'Lune Rousse', N'Femelle', 1, 1),
        (N'Tempête Noire', '2021-04-02', N'Noir', N'Plat',
         N'Night Storm', N'Bella Notte', N'Mâle', 1, 1),
        (N'Franky', '2020-05-20', N'Alezan', N'Plat',
         N'Vent Solaire', N'Reine des Prés', N'Mâle', 2, 2),
        (N'Belle Étoile', '2022-02-11', N'Gris', N'Plat',
         N'Star Gazer', N'Perle Rare', N'Femelle', 2, 2),
        (N'Fleur de Sable', '2022-04-27', N'Alezan', N'Plat',
         N'Desert King', N'Rose des Sables', N'Femelle', 3, 3),
        (N'Sultan d''Orient', '2021-01-30', N'Bai brun', N'Plat',
         N'Orient Express', N'Soie Dorée', N'Mâle', 3, 3),
        (N'Oussama', '2020-03-08', N'Bai', N'Obstacle',
         N'Grand Large', N'Marée Haute', N'Mâle', 4, 4),
        (N'Vent d''Ouest', '2021-05-16', N'Gris', N'Obstacle',
         N'Cap Nord', N'Brise Légère', N'Mâle', 4, 4),
        (N'Dame Blanche', '2022-03-03', N'Gris', N'Plat',
         N'Snow Prince', N'Neige Éternelle', N'Femelle', 5, 1),
        (N'Prince Rouge', '2021-06-09', N'Alezan', N'Plat',
         N'Rouge Gorge', N'Reine Margot', N'Mâle', 5, 2),
        (N'John Porc', '2022-01-19', N'Bai', N'Plat',
         N'Plume d''Or', N'Ballade', N'Femelle', 1, 3),
        (N'Foudre Dorée', '2021-04-22', N'Alezan', N'Plat',
         N'Thunder Gold', N'Aube Dorée', N'Mâle', 2, 1);

    INSERT INTO dbo.course
        (libelle_course, date_course, hippodrome, nb_max_chevaux, allocation_1,
         allocation_2, allocation_3, allocation_4, allocation_5, age_max_course,
         sexe_course, arrivee_definitive)
    VALUES
        (N'Prix de l''Arc de Saint-Denis', '2026-10-04', N'ParisLongchamp',
         8, 150000.00, 60000.00, 30000.00, 15000.00, 7500.00, 6, N'les deux', 1),
        (N'Prix des Pouliches d''Automne', '2026-09-20', N'Chantilly',
         6, 80000.00, 32000.00, 16000.00, 8000.00, 4000.00, 4, N'femelle', 1),
        (N'Grand Steeple-Chase d''Auteuil', '2026-11-08', N'Auteuil',
         6, 120000.00, 48000.00, 24000.00, 12000.00, 6000.00, 6, N'les deux', 1),
        (N'Prix d''Hiver', '2026-12-12', N'Saint-Cloud',
         8, 60000.00, 24000.00, 12000.00, 6000.00, 3000.00, 6, N'les deux', 0),
        (N'Prix de Noël', '2026-12-26', N'Auteuil',
         6, 90000.00, 36000.00, 18000.00, 9000.00, 4500.00, 6, N'les deux', 0),
        (N'Prix du Nouvel An', '2027-01-01', N'Cagnes-sur-Mer',
         10, 50000.00, 20000.00, 10000.00, 5000.00, 2500.00, 5, N'les deux', 0);

    -- Course 1 : six chevaux classés
    INSERT INTO dbo.engagement (rang_arrivee, temps_secondes, id_cheval, id_course, id_jockey)
    VALUES
        (1, 112.450, 3, 1, 1),
        (2, 112.870, 2, 1, 2),
        (3, 113.020, 12, 1, 3),
        (4, 113.400, 6, 1, 4),
        (5, 113.910, 10, 1, 5),
        (6, 114.250, 1, 1, 6);

    -- Course 2 : cinq femelles classées
    INSERT INTO dbo.engagement (rang_arrivee, temps_secondes, id_cheval, id_course, id_jockey)
    VALUES
        (1, 96.320, 5, 2, 2),
        (2, 96.510, 1, 2, 1),
        (3, 96.800, 4, 2, 3),
        (4, 97.150, 11, 2, 4),
        (5, 97.600, 9, 2, 5);

    -- Course 3 : trois classés et un non-classé
    INSERT INTO dbo.engagement (rang_arrivee, temps_secondes, id_cheval, id_course, id_jockey)
    VALUES
        (1, 245.100, 7, 3, 6),
        (2, 246.380, 8, 3, 4),
        (3, 248.920, 10, 3, 5),
        (NULL, NULL, 12, 3, 3);

    -- Course 4 : six engagements sans résultat
    INSERT INTO dbo.engagement (rang_arrivee, temps_secondes, id_cheval, id_course, id_jockey)
    VALUES
        (NULL, NULL, 2, 4, 2),
        (NULL, NULL, 3, 4, 1),
        (NULL, NULL, 6, 4, 4),
        (NULL, NULL, 10, 4, 5),
        (NULL, NULL, 12, 4, 3),
        (NULL, NULL, 5, 4, 6);

    -- Course 5 : deux engagements. Course 6 : aucun.
    INSERT INTO dbo.engagement (rang_arrivee, temps_secondes, id_cheval, id_course, id_jockey)
    VALUES
        (NULL, NULL, 7, 5, 6),
        (NULL, NULL, 8, 5, 4);

    -- Comptes fictifs. Le mot de passe de test est décrit dans le dossier technique.
    -- Stockage : pbkdf2-sha256$itérations$sel_base64$hachage_base64.
    DECLARE @hachage1 NVARCHAR(255) = N'pbkdf2-sha256$600000$aDkMfPwURNdFc+6NJNDlVQ==$'
        + N'AClE/xeNN9PnvltOVd8igtoqJdjhxSsnhsxXowVPquk=';
    DECLARE @hachage2 NVARCHAR(255) = N'pbkdf2-sha256$600000$bY4iBqx9YSd3/d1/KTSO3g==$'
        + N'r6RBotUdfgFMdk/qEYplqAkwSymi2p7gOLswNGaC9NE=';
    DECLARE @hachage3 NVARCHAR(255) = N'pbkdf2-sha256$600000$sOCBf/udHZNwRZ05v74a3g==$'
        + N'HjmWozpvUoy3B65sYSF0X5ioqbblrdofZNFd4N9GjCQ=';
    DECLARE @hachage4 NVARCHAR(255) = N'pbkdf2-sha256$600000$5glu7F4w1cqZ5nxVBopiCw==$'
        + N'wvJtZE+RY+njpVpdk5URIXGhsfVjHgifM1xiyQX8rxQ=';

    INSERT INTO dbo.utilisateur
        (identifiant, mot_de_passe, role_utilisateur, compte_actif)
    VALUES
        (N'admin', @hachage1, N'administrateur', 1),
        (N'gestionnaire1', @hachage2, N'gestionnaire', 1),
        (N'consultant1', @hachage3, N'consultant', 1),
        (N'ancien_user', @hachage4, N'consultant', 0);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
