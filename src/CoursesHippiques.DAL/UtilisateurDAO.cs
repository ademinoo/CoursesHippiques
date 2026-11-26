using System;
using System.Data;
using System.Data.SqlClient;
using CoursesHippiques.BO;

namespace CoursesHippiques.DAL
{
    public class UtilisateurDAO
    {
        private readonly FabriqueConnexion fabriqueConnexion;

        public UtilisateurDAO(FabriqueConnexion fabriqueConnexion)
        {
            if (fabriqueConnexion == null)
                throw new ArgumentNullException(nameof(fabriqueConnexion));

            this.fabriqueConnexion = fabriqueConnexion;
        }

        public Utilisateur RechercherParIdentifiant(string identifiant)
        {
            if (string.IsNullOrWhiteSpace(identifiant)
                || identifiant.Length > 80)
            {
                throw new ArgumentException("Identifiant invalide.");
            }

            using (SqlConnection connexion =
                fabriqueConnexion.CreerConnexion())
            using (SqlCommand commande = connexion.CreateCommand())
            {
                commande.CommandText = @"
                    SELECT id_utilisateur,
                           identifiant,
                           mot_de_passe,
                           role_utilisateur,
                           compte_actif
                    FROM dbo.utilisateur
                    WHERE identifiant = @identifiant;";

                commande.Parameters.Add(
                    "@identifiant",
                    SqlDbType.NVarChar,
                    80
                ).Value = identifiant;

                connexion.Open();

                using (SqlDataReader lecteur = commande.ExecuteReader())
                {
                    if (!lecteur.Read())
                        return null;

                    return new Utilisateur(
                        lecteur.GetInt32(0),
                        lecteur.GetString(1),
                        lecteur.GetString(2),
                        lecteur.GetString(3),
                        lecteur.GetBoolean(4)
                    );
                }
            }
        }
    }
}