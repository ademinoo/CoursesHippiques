# Base SQL Server

Les deux scripts sont extraits sans modification des annexes A et B du dossier de spécifications techniques du groupe 4. Ils sont préparés, mais n'ont pas été exécutés lors de la création de ce socle.

1. Choisir une instance SQL Server 2019 ou ultérieure et un environnement dédié au projet.
2. Vérifier qu'aucune base existante nommée `courses_hippiques` ne contient de données à préserver.
3. Dans SSMS, exécuter `01_Creation_courses_hippiques.sql`, puis `02_Jeu_essai_courses_hippiques.sql`.

La création refuse les tables déjà présentes. Le jeu d'essai exige des tables neuves et n'est pas rejouable sur un jeu déjà chargé. Ne pas supprimer une base existante pour contourner ces contrôles.

Volumes attendus : 5 propriétaires, 4 entraîneurs, 6 jockeys, 12 chevaux, 6 courses, 23 engagements et 4 comptes.

Les comptes fictifs sont `admin`, `gestionnaire1`, `consultant1` et `ancien_user` (inactif). Le mot de passe de démonstration fourni est `PpeDemo2026!` ; la base stocke des hachages PBKDF2, pas ce texte en clair.

L'instance n'est pas encore choisie et la connexion de `App.config` est volontairement vide. L'application ne tente actuellement aucun accès SQL.
