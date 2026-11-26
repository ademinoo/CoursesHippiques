using System;

namespace CoursesHippiques.BO
{
    public sealed class Proprietaire : Personne
    {


        public Proprietaire(int id, string nom, string prenom,
            DateTime dateNaissance, string civilite)
            : base(id, nom, prenom, dateNaissance, civilite)
        {

        }
    }
}
