namespace CoursesHippiques.BO
{
    public class Utilisateur
    {
        public int Id { get; private set; }
        public string Identifiant { get; private set; }
        public string MotDePasseHache { get; private set; }
        public string Role { get; private set; }
        public bool CompteActif { get; private set; }

        public Utilisateur(
            int id,
            string identifiant,
            string motDePasseHache,
            string role,
            bool compteActif)
        {
            Id = id;
            Identifiant = identifiant;
            MotDePasseHache = motDePasseHache;
            Role = role;
            CompteActif = compteActif;
        }
    }
}