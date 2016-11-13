# Documentation generale

## URLs
Selon la doc ArcGIS, les URL de l'API (pour les layers) sont sous la forme http://$host/$root/services/$folderName/$serviceName/MapServer/$layerId

* $host = couverture-mobile.orange.fr
* $root = arcsig/rest
* $folderName = extern
* $serviceName selon la liste:
* * optimum_ftth (pour le layer de la couverture FTTH par batiments)
* * ftth_cache_V3 (pour le layer de la couverture FTTH par zone)
* * dsl_cache_V3 (pour le layer des informations sur les communes)
* * ftth_ponctuels (pour le layer des boutiques Orange et de la couverture par ville)
* $layerId = 0 pour le layer des batiments, des villes, des communes, et des zones, 1 pour le layer des boutiques

Soit, avec les URL completes

* Pour la couverture par batiment (celle qui apparait avec le max de zoom, chaque batiment ayant une couleur selon l'etape en cours): `http://couverture-mobile.orange.fr/arcsig/rest/services/extern/optimum_ftth/MapServer/0`
* Pour la couverture par zone (celle qui apparait avec un peu de zoom, les zones fibrees etant en orange): `http://couverture-mobile.orange.fr/arcsig/rest/services/extern/ftth_cache_V3/MapServer/0`
* Pour la couverture par ville (celle qui apparait au debut, avec les villes commercialisables): `http://couverture-mobile.orange.fr/arcsig/rest/services/extern/ftth_ponctuels/MapServer/0`
* Pour la liste des communes supportes par Orange: `http://couverture-mobile.orange.fr/arcsig/rest/services/extern/dsl_cache_V3/MapServer/0`
* Pour la liste des boutiques Orange: `http://couverture-mobile.orange.fr/arcsig/rest/services/extern/ftth_ponctuels/MapServer/1`

## Univers
Orange defini des univers selon les differentes zones

* Metropole: `xmin=-893167.67 ymin=4866693.70 xmax=1432678.58 ymax=6938442.92`
* Guadeloupe: `xmin=-6887474.84 ymin=1762395.11 xmax=-6774959.54 ymax=1884694.36`
* Iles du nord: `xmin=-7036665.85 ymin=2004464.15 xmax=-6980408.20 ymax=2065613.77`
* Martinique: `xmin=-6820055.95 ymin=1617213.69 xmax=-6763798.30 ymax=1678363.31`
* Guyane: `xmin=-6123103.13 ymin=188911.38 xmax=-5714623.65 ymax=678108.36`
* Reunion: `xmin=6145867.68 ymin=-2438113.21 xmax=6217259.86 ymax=-2376963.59`
* Mayotte: `xmin=4992784.10 ymin=-1472233.07 xmax=5059284.31 ymax=-1411083.45`
* *Note*: ces coordonnees sont selon le referentiel ESRI:102100, mais semblent compatible avec le systeme EPSG:3857

## Token & Referer
A savoir, l'API demande un token et un Referer, si ces elements ne sont pas defini, vous aurez une erreur:
```
{
 "error": {
  "code": 499,
  "message": "Token Required",
  "details": []
 }
}
```

Ce token peux etre recupere dans `http://couverture-mobile.orange.fr/mapV3/fibre/json/config.json`  
**Note**: il semble avoir plusieurs tokens, `token`, `token_https`, `token_geocoder` et `token_geocoder_https`, a priori les tokens geocoder sont utilise pour la recherche de ville.

le Referer doit etre `http://couverture-mobile.orange.fr/mapV3/fibre/index.html`

## Parametres
Pour ca, faut voir la doc d'ArcGIS, notemment pour [les MapServer](http://resources.arcgis.com/en/help/rest/apiref/mapserver.htm), [les layers](http://resources.arcgis.com/en/help/rest/apiref/layer.html) et [pour query un layer](http://resources.arcgis.com/en/help/rest/apiref/query.html)

