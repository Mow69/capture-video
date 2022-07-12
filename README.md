<a href="https://aimeos.org/">
    <img src="https://res.cloudinary.com/it-akademy/image/upload/f_auto,q_auto,h_60/logo_2x_feoygs.png" alt="IT-Akademy logo" title="IT-Akademy" align="right" height="60" />
</a>

# Open Project IoT

![Project](https://img.shields.io/badge/Projet_type-IoT-blue.svg)
![Project](https://img.shields.io/badge/Projet_mode-Hackathon/sprint-orange.svg)
![Session](https://img.shields.io/badge/Session-EMSI-brightgreen.svg)
![Session](https://img.shields.io/badge/Session-DFS21-brightgreen.svg)
![Session](https://img.shields.io/badge/Session-DFS24-brightgreen.svg)

---

📝 NOTE : Ce repository est la suite de [celui-ci](https://github.com/Mow69/capture-video) qui a servi pour commencer.

---

## <img src="./images/vjing-logo-seul.png" alt="vjing-logo-seul" width="15"/> Pitch

Presentation rapide du concept de votre projet

<img src="./images/vjing-bg.png" alt="vjing-logo-bg" width="100%"/>

<p style="text-align: center; font-style: italic; font-size: 1.5em;">
    <b>
        <i>
            <span style="color: #ff045d;">VJ</span>
            <span style="color: #1c18cb;">'</span>
            <span style="color: #ffc101;">IT</span>
            <span style="color: #1c18cb;">!</span>
        </i>
    </b>
</p>






<b><i>VJ'IT!</i></b> est l'invité vedette de tes meilleures soirées. 

Grâce à ses filtres vidéos hyper stylés, deviens toi aussi un VJ légendaire.

Balance tes filtres sur la foule dansante sur le rythme endiablé des meilleurs tubes.

---

## <img src="./images/vjing-logo-seul.png" alt="vjing-logo-seul" width="15"/> Stack

Liste des technologies et outils employés dans votre projet

- <b>Technologies :</b>
    - Front-end mobile :
        - Dart
        - Flutter     
    - Back-end :
        - MariaDB
        - TypeScrypt
        - NestJs
        - npm
    - Raspberry Pi (partie IoT) :
        - Python 3
        - pip 3 
        - Blue Dot pour la connexion Bluetooth   

---

- <b>Matériel utilisé :</b>
    - 1 Kit complet [Raspberry Pi 4](https://fr.rs-online.com/web/p/raspberry-pi/1822096) Modèle B 4G RAM+64G SD avec [boitier](https://www.amazon.fr/GeeekPi-Raspberry-Ventilateur-40X40X10mm-Dissipateurs/dp/B07XCKNM8J/) écran tactile  
    - [Un écran](https://www.amazon.fr/Moniteur-Portable-Raspberry-capacitif-1024x600/dp/B087GFY4KL) LCD HDMI (non tactile)
    - Un clavier sans fil Rii K12
    - Piles, cables jumper, multiprises, 2 [cables](https://www.amazon.fr/UGREEN-Supporte-Ethernet-Zenbook-UX330UA/dp/B015GR44CG/)  micro HDMI vers HDMI
    - 1 multiprise 220V + USB  
    - 1 [Webcam](https://www.amazon.fr/Logitech-int%C3%A9gr%C3%A9-compatible-Youtube-Facebook/dp/B006A2Q81M)  HD 1080px
    - 1 [Vidéo projecteur](https://www.amazon.fr/Videoprojecteur-Vamvo-Projecteur-Retroprojecteur-Compatibles/dp/B07RB49JSM/) 

---

## <img src="./images/vjing-logo-seul.png" alt="vjing-logo-seul" width="15"/> Fonctionnement
Deviens le VJ de la soirée avec l'application mobile VJ'IT!

Depuis l'application installée sur ton smartphone, tu choisis les filtres à afficher sur la ou les sortie(s) que tu veux : écran et/ou rétroprojecteur.

Avec la webcam haute définition branchée au Raspberry, capture des moments inoubliables avec tes amis en train de faire la fête et qui serviront à superposer les filtres.

---

<u>Page d'accueil de l'app mobile de VJ'IT!</u>
![alt vjing-home](./images/vjing-home.png?raw=true "VJ'IT! Home Page")

---

<u>Page de sélection des filtres dans l'app mobile de VJ'IT!</u>
![alt vjing-filters](./images/vjing-filters.png?raw=true "VJ'IT! Filters Page")


---

<u>Schéma UML de la base de donnée de VJ'IT!</u>
![alt vjing-schema-bdd](./images/vjing-schema-bdd.png?raw=true "VJ'IT! Database Schema")

---

## <img src="./images/vjing-logo-seul.png" alt="vjing-logo-seul" width="15"/> Team

Liste des membres de l'équipe projet

EMSI :
- [Marine Gillet](https://github.com/marine2002) (Cheffe de Projet)

DFS21A :
- [Mouaz Saadaoui](https://github.com/Mow69) (Back-end Developer)


DFS24A :
- [Claude Buisson](https://github.com/claude-bssn) (Lead Front-end Developer)
- [Adrien Charrier](https://github.com/4dr1en) (Front-end Developper)
- [Aurélien De Cillia](https://github.com/Ade-cillia) (Back-end Developer)
- [Malek Medjoudj](https://github.com/MAlykylam) (Front-end Developer)

---

## <img src="./images/vjing-logo-seul.png" alt="vjing-logo-seul" width="15"/> Demo

[Lien vers la video de la demonstration](https://youtu.be/iZ2nCDYJfRk) 

👉 Plus d'infos dans notre magnifique documentation qui se compose 👈 :
+ d'un [Manuel d'utilisation 📜](./documentation/notice-utilisateur/documentation_utilisateur.pdf) : le nécessaire pour exécuter l'app pas à pas 👣

+ et d'un [Slide de présentation 📽](./documentation/slide-presentation/VJIT_Visual-Tacos.pdf) : si on ne vous a pas encore convaincu d'emmener VJ'IT avec vous à la prochaine  soirée 🕺🪩


---

## <img src="./images/vjing-logo-seul.png" alt="vjing-logo-seul" width="15"/> Angle d'amélioration

La réalisation du projet a été pensée afin de faciliter les améliorations futures. 

En vue d'une prochaine version nous prévoyons:

- la personnalisation de la liste des filtres par utilisateur
- l'achat de filtres par Stripe
- optimisation de l'app sur iOS
- automatisation de la connexion par Bluetooth au boitier VJ'IT
- optimisation plein écran automatique
- optimisation de l'utilisation du boîtier en mode "One Screen"
- optimisation du lag de la vidéo 
- utilisation du produit en "full" hors-ligne
- double authentification par e-mail à la création du compte et au changement du mot de passe.
- intégration continue du projet
- adapter le code Flutter pour le rafraîchissement du token (déjà en place sur l'API, cf: le [fichier de collection Postman](./api/postman/VJing.postman_collection.json) joint au projet)
- déplacement de l'attribut is_downloaded (dans la table Order des commandes) dans une table secondaire
- créer une commande (order) à un instant T pour les utilisateurs
- création d'un panier de plusieurs filtres.
- réactivité du filtre en fonction du son (comme un ["vizualizer"](https://en.wikipedia.org/wiki/Music_visualization))
- réactivité du filtre à l'aide d'un thérémine (ajout de son 🎵 à la détection de mouvement à la caméra)

