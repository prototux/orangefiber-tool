# orangefiber-tool
[FR] Un outil pour recuperer les donnees sur le reseau fibre optique d'orange

# Why
Mon appartement actuel est loin du DSLAM, j'ai du 1mbps, c'est chiant, orange/l'agglo a promis la fibre d'ici la fin de l'annee, je suis impatient, j'ai la flemme d'aller voir les MaJ au niveau de la ville sur le site d'orange, j'ai remarque que y'avais plus d'info que affiche dans l'API pour leur map... et j'arrive pas a dormir cette nuit.

# How
Petites remarques sur l'API, dans le desordre, selon ce que je remarque (**NB: ne vous fiez pas a ce que j'ai ecris, c'est purement ce que je devine**):

## Orange utilise ArcGIS (de ESRI) directement, les infos ci-dessous contiennent seulement les infos sur le layer d'infos sur la fibre d'orange (donc ni les infos generales sur ArcGIS, ni les autres layers, comme celui des boutiques)


* Etape semble etre equivalent a l'etape de la map (1 = "la fibre est dans votre ville", 2 = "la fibre est dans votre quartier", 3 = "la fibre est pres de votre logement", 4 = "votre logement est eligible")
* Sous_etape semble toujours etre "A", "B" ou "C", aucune idee de a quoi ca correspond, le sens etre dependant de etape
* Si etape est a 1, etat va seulement contenir "_", si etape est a 2, 3 ou 4, etat va contenir une string qui donne plus de details
* Etat semble pouvoir contenir "raccordable" (etape 2), "adressable" (etape 2), "signe" (etape 2,3), "commercialisable" (etape 4), visiblement, les pavillons peuvent seulement etre "adressable", donc je devine que le "adressable" est pour savoir si le batiment (immeuble ou pavillon) est raccordable, et "raccordable" est uniquement pour preciser si les appartements d'un immeuble sont raccordable eux aussi?
* Type_logement semble contenir soir "pav" soit "imm", logiquement "pavillon" et "immeuble" (ca semble concorder avec les batiments qui se trouvent a ces adresses)
* Statut_syndic semble contenir une info bien interessante qui est pas sur la map: ou Orange en est avec le syndic d'immeuble, il semble contenir "PS", "OK", "EC" ou "BD"
* "PS" et "EC" semblent vouloir dire "Pas signe" et "En cours", aucune idee de ce qu'est "BD" (je l'ai rencontre qu'une fois), je devine que c'est un code pour dire que le syndic a refuse de signer?
* Si le batiment est un pavillon, visiblement, statut_syndic semble etre "PS", logique, vu que y'a pas de syndic.
* En plus de l'adresse, et des infos sur le raccordement, il semble y avoir l'operateur qui fait l'infra, mais aussi un "no_dossier", acucune idee a quoi ca correspond chez orange
* Le systeme de coordonees par defaut est le ESRI:102100, mais a priori ArcGIS (le serveur de map qu'Orange utilise) supporte aussi EPSG:3857, aka WGS84, aka google|openstreet maps. c'est celui que j'utilise dans le script (plus d'infos ici: [https://en.wikipedia.org/wiki/Web_Mercator](https://en.wikipedia.org/wiki/Web_Mercator)
* Orange utilise donc ArcGIS de chez ESRI, avec des layers custom, a priori un pour les code INSEE, un "NOM_COM" (nom commune?), et un "no_dossier" (celui qui nous interesse)

# Usage

* Je previens, le script est vraiment fait a l'arrache, et c'est du reverse engineering de l'API d'Orange (donc ca risque potentiellement de foirer, surtout si Orange apprecie pas ce repo)
* Recuperer les coordonees avec [http://twcc.fr/](http://twcc.fr/)
* Le script demande curl et jq, les filtres sont ceux de jq, man jq pour plus d'infos

orange.sh xmin xmax ymin ymax [jq filter]
