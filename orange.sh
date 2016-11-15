#!/usr/bin/env bash

## Get JSON (with correct Referer)
function getJson {
	echo $(curl -sS -H "Referer: http://couverture-mobile.orange.fr/mapV3/fibre/index.html" $1)
}

## Read token from tmp file, if it exists, else get it and create the file
if [[ -f /tmp/orange_token.txt ]]; then
	token=$(cat /tmp/orange_token.txt)
else
	token_url='http://couverture-mobile.orange.fr/mapV3/fibre/json/config.json'
	token=$(echo "$(getJson $token_url)" | jq .configuration.token | tr -d "\"")
	echo $token > /tmp/orange_token.txt
fi

## Parameters
spatialref="3857" # Default: 102100

# Cook parameters for the GET request
where="(etape%3D%270%27%20AND%20sous_etape%20not%20in%20(%27A%27%2C%27B%27))%20or%20(etape%3C%3E%270%27)%20or%20(etape%3D%27%27%20AND%20sous_etape%20not%20in%20(%27A%27%2C%27B%27))"
geometry="$1,$2,$3,$4" # xmin,ymin,xmax,ymax

# Read http://resources.arcgis.com/en/help/rest/apiref/query.html for info on this
request_url="http://couverture-mobile.orange.fr/arcsig/rest/services/extern/optimum_ftth/MapServer/0/query?"
request_url+="token=$token&f=json&where=$where&geometry=$geometry&inSR=$spatialref&ourSR=$spatialref&outFields=*"

echo $(echo $(getJson $request_url) | jq ${5:-.})
