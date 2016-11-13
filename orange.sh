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
pm_sr="3857" # Default: 102100

## Cook geometry, the QnD way already urlencoded
# xmin="$1", ymin="$2",xmax="$3",ymax="$4"
p_geometry="%7B%22xmin%22%3A$1%2C%22ymin%22%3A$2%2C%22xmax%22%3A$3%2C%22ymax%22%3A$4%2C%22spatialReference%22%3A%7B%22wkid%22%3A$pm_sr%7D%7D"

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

echo $(echo $(getJson $cp_url) | jq ${5:-.})
