using System;

namespace CoursesHippiques.BO
{
    public sealed class Jockey : Personne
    {


        public Jockey(int id, string nom, string prenom,
            DateTime dateNaissance, string civilite)
            : base(id, nom, prenom, dateNaissance, civilite)
        {

        }
    }
}
