using System;

namespace CoursesHippiques.BO
{
    public sealed class Entraineur : Personne
    {
        public string Localisation { get; private set; }

        public Entraineur(int id, string nom, string prenom,
            DateTime dateNaissance, string civilite, string localisation)
            : base(id, nom, prenom, dateNaissance, civilite)
        {
            Localisation = localisation;
        }
    }
}
