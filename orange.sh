#!/usr/bin/env bash

## Get token
function getToken {
	raw=$(curl 'http://couverture-mobile.orange.fr/mapV3/fibre/json/config.json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: http://couverture-mobile.orange.fr/mapV3/fibre/index.html?geosignet=true&groupegeosignet=caraibeindien' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/55.0.2883.11 Chrome/55.0.2883.11 Safari/537.36' -sS --compressed)

	echo $(echo "$raw" | jq .configuration.token | tr -d "\"")
}

## Read token from tmp file, if it exists, else get it and create the file
if [[ -f /tmp/orange_token.txt ]]; then
	token=$(cat /tmp/orange_token.txt)
else
	token=$(getToken)
	echo $token > /tmp/orange_token.txt
fi

## Parameters
pm_sr="3857" # Default: 102100

## Cook geometry, the QnD way already urlencoded
g_xmin="$1"
g_ymin="$2"
g_xmax="$3"
g_ymax="$4"
p_geometry="%7B%22xmin%22%3A$g_xmin%2C%22ymin%22%3A$g_ymin%2C%22xmax%22%3A$g_xmax%2C%22ymax%22%3A$g_ymax%2C%22spatialReference%22%3A%7B%22wkid%22%3A$pm_sr%7D%7D"

# Cook parameters for the GET request
p_format="json"
p_where="(etape%3D%270%27%20AND%20sous_etape%20not%20in%20(%27A%27%2C%27B%27))%20or%20(etape%3C%3E%270%27)%20or%20(etape%3D%27%27%20AND%20sous_etape%20not%20in%20(%27A%27%2C%27B%27))"
p_returnGeometry="true"
p_spatialRel="esriSpatialRelIntersects"
p_geometryType="esriGeometryEnvelope"
p_inSR="$pm_sr"
p_outFields="OBJECTID%2Ctype_logement%2Cetat%2Coperateur%2Cadresse%2Cno_dossier%2Cetape%2Csous_etape%2Cstatut_syndic"
p_outSR="$pm_sr"

cp_url="http://couverture-mobile.orange.fr/arcsig/rest/services/extern/optimum_ftth/MapServer/0/query?token=$token&f=$p_format&where=$p_where&returnGeometry=$p_returnGeometry&spatialRel=$p_spatialRel&geometry=$p_geometry&geometryType=$p_geometryType&inSR=$p_inSR&outFields=$p_outFields&outSR=$p_outSR"

cp_referer="Referer: http://couverture-mobile.orange.fr/mapV3/fibre/index.html?geosignet=true&groupegeosignet=caraibeindien"

data=$(curl "$cp_url" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H "$cp_referer" -H 'X-Requested-With: XMLHttpRequest' -H 'X-CookiesOK: I explicitly accept all cookies' -H 'Connection: keep-alive' -sS --compressed)

echo $(echo $data | jq ${5:-.})
