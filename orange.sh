#!/usr/bin/env bash

## Get JSON (with correct Referer)
getJson() {
	echo $(curl -sS -H "Referer: http://couverture-mobile.orange.fr/mapV3/fibre/index.html" $1)
}

## Urlencode (from https://gist.github.com/cdown/1163649)
urlencode() {
	old_lc_collate=$LC_COLLATE
	LC_COLLATE=C
	local length="${#1}"
	for (( i = 0; i < length; i++ )); do
		local c="${1:i:1}"
		case $c in
			[a-zA-Z0-9.~_-]) printf "$c" ;;
			*) printf '%%%02X' "'$c" ;;
		esac
	done
	LC_COLLATE=$old_lc_collate
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
where=$(urlencode "(etape<>'0') or ((etape='0' or etape='') and sous_etape not in ('A','B'))")
geometry="$1,$2,$3,$4" # xmin,ymin,xmax,ymax

# Read http://resources.arcgis.com/en/help/rest/apiref/query.html for info on this
request_url="http://couverture-mobile.orange.fr/arcsig/rest/services/extern/optimum_ftth/MapServer/0/query?"
request_url+="token=$token&f=json&where=$where&geometry=$geometry&inSR=$spatialref&ourSR=$spatialref&outFields=*"
echo $(getJson $request_url) | jq ${5:-.}
