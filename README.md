# orangefiber-tool
[FR] Un outil pour recuperer les donnees sur le reseau fibre optique d'orange

`jq` et `curl` sont requis :

- Sous Ubuntu `sudo apt-get install jq curl`
- Sous macOS `brew install jq curl`

# API
Voir la documentation

# Usage

* Recuperer les coordonees xmin, ymin, xmax, ymax avec [http://twcc.fr/](http://twcc.fr/).  
  Pour ce faire :
  1. sur twcc.fr, placez-vous en mode **WGS84 Web Mercator (Auxiliary Sphere)** (note : dans le script, c'est la variable `spatialref="3857"`)
  2. placez le curseur "Déplacez-moi" sur une position au sud-ouest de votre maison. Notez le X et le Y, ce sont les `X_min` et `Y_min`
  3. placez le curseur sur une position au nord-est de votre maison. Les X et Y sont les `X_max` et `Y_max`
  4. faites un test avec `./orange X_min Y_min X_max Y_max` et testez que votre maison apparait bien dans la liste

* Le script demande curl et jq, les filtres sont ceux de jq, man jq pour plus d'infos

orange.sh xmin ymin xmax ymax [jq filter]
