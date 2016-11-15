# orangefiber-tool
[FR] Un outil pour recuperer les donnees sur le reseau fibre optique d'orange

# API
Voir la documentation

# Usage

* Recuperer les coordonees xmin, ymin, xmax, ymax avec [http://twcc.fr/](http://twcc.fr/)
* Le script demande curl et jq, les filtres sont ceux de jq, man jq pour plus d'infos

orange.sh xmin ymin xmax ymax [jq filter]
