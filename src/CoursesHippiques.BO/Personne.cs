using System;

namespace CoursesHippiques.BO
{
    // Classe commune aux personnes du domaine, sans table SQL supplémentaire.
    public abstract class Personne
    {
        public int Id { get; private set; }
        public string Nom { get; private set; }
        public string Prenom { get; private set; }
        public DateTime DateNaissance { get; private set; }
        public string Civilite { get; private set; }

        protected Personne(int id, string nom, string prenom,
            DateTime dateNaissance, string civilite)
        {
            Id = id;
            Nom = nom;
            Prenom = prenom;
            DateNaissance = dateNaissance.Date;
            Civilite = civilite;
        }
    }
}
