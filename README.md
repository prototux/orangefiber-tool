# orangefiber-tool
[FR] Un outil pour recuperer les donnees sur le reseau fibre optique d'orange

# Why
Mon appartement actuel est loin du DSLAM, j'ai du 1mbps, c'est chiant, orange/l'agglo a promis la fibre d'ici la fin de l'annee, je suis impatient, j'ai la flemme d'aller voir les MaJ au niveau de la ville sur le site d'orange, j'ai remarque que y'avais plus d'info que affiche dans l'API pour leur map... et j'arrive pas a dormir cette nuit.

# How
Petites remarques sur l'API, dans le desordre, selon ce que je remarque (**NB: ne vous fiez pas a ce que j'ai ecris, c'est purement ce que je devine**):

* A priori si on omet le parametre "where", ca renvoit la liste des villes, avec leur codes INSEE (j'ai pas ete creuser ce que ca renvoit precisement)
* Ce meme parametre semble contenir **DU PUTAIN DE SQL**, serieusement orange? (j'ai pas test avec sqlmap, mais ca semble mal parti)
* L'api semble avoir code de maniere generique
* * Il y a un parametre pour definir ce qu'on veux en sortie, pratique (a priori, y'a "type_logement", "etat", "operateur", "adresse", "no_dossier", "etape", "sous_etape", "statut_syndic")
* * outFields peux aussi contenir "*", ce a quoi il semble cracher tout ce qu'il a de disponible
* * Il ne semble pas y avoir de limitations sur la taille, visiblement, le truc donne gentilement toute une ville si on lui demande
* * Il y a des parametres pour definir le format de sortie, et les types d'entree (les esri*), en revanche, definir un format autre que json renvoit un 403
* Etape semble etre equivalent a l'etape de la map (1 = "la fibre est dans votre ville", 2 = "la fibre est dans votre quartier", 3 = "la fibre est pres de votre logement", 4 = "votre logement est eligible")
* Sous_etape semble toujours etre "A" ou "B", aucune idee de a quoi ca correspond
* Si etape est a 1, etat va seulement contenir "_", si etape est a 2, 3 ou 4, etat va contenir une string qui donne plus de details
* Etat semble pouvoir contenir "raccordable" (etape 2), "adressable" (etape 2), "signe" (etape 2,3), "commercialisable" (etape 4), visiblement, les pavillons peuvent seulement etre "adressable", donc je devine que le "adressable" est pour savoir si le batiment (immeuble ou pavillon) est raccordable, et "raccordable" est uniquement pour preciser si les appartements d'un immeuble sont raccordable eux aussi?
* Type_logement semble contenir soir "pav" soit "imm", logiquement "pavillon" et "immeuble" (ca semble concorder avec les batiments qui se trouvent a ces adresses)
* Statut_syndic semble contenir une info bien interessante qui est pas sur la map: ou Orange en est avec le syndic d'immeuble, il semble contenir "PS", "OK", "EC" ou "BD"
* "PS" et "EC" semblent vouloir dire "Pas signe" et "En cours", aucune idee de ce qu'est "BD" (je l'ai rencontre qu'une fois), je devine que c'est un code pour dire que le syndic a refuse de signer?
* Si le batiment est un pavillon, visiblement, statut_syndic semble etre "PS", logique, vu que y'a pas de syndic.
* En plus de l'adresse, et des infos sur le raccordement, il semble y avoir l'operateur qui fait l'infra, mais aussi un "no_dossier", acucune idee a quoi ca correspond chez orange
* L'API ne semble pas avoir de problemes a donner qu'une seule adresse si xmax et ymax sont les meme que xmin et ymin, c'est ce que j'utilise pour avoir les donnees sur mon logement seulement
* Le systeme de coordonees par defaut est le ESRI:102100, mais a priori ArcGIS (le serveur de map qu'Orange utilise) supporte aussi EPSG:3857, aka WGS84, aka google|openstreet maps. c'est celui que j'utilise dans le script (plus d'infos ici: [https://en.wikipedia.org/wiki/Web_Mercator](https://en.wikipedia.org/wiki/Web_Mercator)


# Usage

* Je previens, le script est vraiment fait a l'arrache, et c'est du reverse engineering de l'API d'Orange (donc ca risque potentiellement de foirer, surtout si Orange apprecie pas ce repo)
* pm_sr defini la reference spatiale de la map, par defaut c'est ESRI-102100.
* le script demande un token, j'ai pas mis celui que j'avais dans mes requests parceque j'ai aucune idee de quelles infos ca contient pour le moment, idealement, faut faire un script qui recupere un nouveau token, mais pour le moment, sortez les devtool de votre browser favori pour en recuperer un
* Vu que les coordonnees suivent un format propre a Orange (voir #how), idem, sortez les devtoosl pour recuperer celles qui vous interesse
* Le script demande curl et jq, les filtres sont ceux de jq, man jq pour plus d'infos

orange.sh xmin xmax ymin ymax [jq filter]
