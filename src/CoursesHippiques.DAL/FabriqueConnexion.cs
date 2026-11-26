using System;
using System.Data.SqlClient;

namespace CoursesHippiques.DAL
{
    // Crée une connexion fermée : chaque DAO devra l'ouvrir et la libérer avec using.
    public sealed class FabriqueConnexion
    {
        private readonly string chaineConnexion;

        public FabriqueConnexion(string chaineConnexion)
        {
            if (string.IsNullOrWhiteSpace(chaineConnexion))
                throw new ArgumentException("La connexion SQL doit être configurée.", nameof(chaineConnexion));

            this.chaineConnexion = chaineConnexion;
        }

        public SqlConnection CreerConnexion()
        {
            return new SqlConnection(chaineConnexion);
        }
    }
}
