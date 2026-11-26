# Courses hippiques

Projet C# du groupe 4 : Adem Daouadi, Enzo Belo et Axel Rivas.

## État actuel

Socle initial du sprint 2 : solution en quatre couches, première fenêtre de connexion vide, objets Personne/Entraineur/Proprietaire/Jockey et fabrique de connexions SQL. La BLL est prête à recevoir les services ; aucun service d'authentification ni CRUD n'est encore développé. Aucun script SQL n'a été exécuté.

## Ouvrir le projet

- Dans VS Code : ouvrir le dossier qui contient ce README, `.git` et `CoursesHippiques.sln`. Tes extensions et tes opérations Git restent dans VS Code.
- Dans Visual Studio : ouvrir `CoursesHippiques.sln` depuis ce même dossier. Définir `CoursesHippiques.GUI` comme projet de démarrage si nécessaire.
- Les deux éditeurs travaillent sur les mêmes sources. Éviter les modifications simultanées du même fichier, notamment les fichiers `.Designer.cs`.

## Prérequis

Windows, Visual Studio avec la charge Développement Desktop .NET et les références de développement .NET Framework 4.8. SQL Server 2019 minimum et SSMS seront nécessaires pour la base. Le SDK .NET moderne seul ne remplace pas ces outils .NET Framework.

## Structure

```text
CoursesHippiques.sln
src/
  CoursesHippiques.GUI/  fenêtres et futurs contrôleurs
  CoursesHippiques.BO/   objets métier
  CoursesHippiques.BLL/  futurs services, règles et droits
  CoursesHippiques.DAL/  fabrique de connexions et futurs DAO
sql/                    scripts fournis par le dossier technique
scripts/Build.ps1        compilation avec MSBuild de Visual Studio
.vscode/tasks.json       tâches de compilation et lancement
```

Références : GUI vers BLL et BO ; BLL vers DAL et BO ; DAL vers BO. BO n'accède ni à SQL ni à l'interface. La GUI ne référence pas la DAL. Les contrôleurs seront dans GUI et appelleront les services BLL.

## Compiler et lancer

Dans Visual Studio : Générer la solution, puis F5. Une fenêtre vide intitulée « Courses hippiques - Connexion » doit apparaître.

Dans VS Code : `Ctrl+Maj+B` lance la compilation. La commande « Tâches : Exécuter la tâche », puis « Lancer CoursesHippiques », compile et ouvre l'application. Le débogage avec points d'arrêt reste configuré dans Visual Studio pour ce socle.

Le script de compilation recherche automatiquement MSBuild via `vswhere`, sans imposer la version ni le chemin personnel de Visual Studio d'un membre.

Les projets utilisent le format .NET Framework classique. Pour ajouter une classe ou un formulaire, utiliser Visual Studio afin de mettre à jour le `.csproj`, ou ajouter explicitement son entrée `<Compile Include="..." />` si le fichier est créé dans VS Code.

## Git et GitHub

Un dépôt local sur la branche `main` est initialisé à la livraison. Les dossiers `bin`, `obj` et `.vs` sont exclus. La configuration VS Code du projet est versionnée ; aucune extension personnelle n'est modifiée.

Pour publier depuis VS Code : ouvrir le contrôle de code source, utiliser « Publier la branche » ou « Publier sur GitHub » selon l'état du dépôt et choisir un dépôt privé pour commencer. Une connexion GitHub pourra être demandée. Aucun dépôt distant n'est encore configuré par ce socle.

Chaque membre utilise sa propre identité Git et sa propre connexion GitHub. Ne pas partager de jeton. Ne pas ajouter de mot de passe SQL réel à `App.config` avant un commit.

## Prochain travail

1. Choisir l'instance SQL et charger la base sur un environnement dédié en suivant `sql/README.md`.
2. Ajouter Utilisateur et SessionUtilisateur dans BO.
3. Développer UtilisateurDAO avec requête paramétrée dans DAL.
4. Développer la vérification PBKDF2 et les droits dans BLL.
5. Concevoir le formulaire de connexion et le relier aux services.
6. Réaliser ensuite les listes et les opérations sur chevaux et entraîneurs, avec la recette croisée prévue.
