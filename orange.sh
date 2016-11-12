#!/bin/zsh

## Parameters
pm_sr=${O_SR:-"3857"} # Default: 102100
pm_token=${O_TOK:-"your_token"} # API token

## Cook geometry, the QnD way already urlencoded
g_xmin="$1"
g_ymin="$2"
g_xmax="$3"
g_ymax="$4"

# Cook parameters for the GET request
p_format="json"
p_where="(etape%3D%270%27%20AND%20sous_etape%20not%20in%20(%27A%27%2C%27B%27))%20or%20(etape%3C%3E%270%27)%20or%20(etape%3D%27%27%20AND%20sous_etape%20not%20in%20(%27A%27%2C%27B%27))"
p_returnGeometry="true"
p_spatialRel="esriSpatialRelIntersects"
p_geometry="%7B%22xmin%22%3A$g_xmin%2C%22ymin%22%3A$g_ymin%2C%22xmax%22%3A$g_xmax%2C%22ymax%22%3A$g_ymax%2C%22spatialReference%22%3A%7B%22wkid%22%3A$pm_sr%7D%7D"
p_geometryType="esriGeometryEnvelope"
p_inSR="$pm_sr"
p_outFields="OBJECTID%2Ctype_logement%2Cetat%2Coperateur%2Cadresse%2Cno_dossier%2Cetape%2Csous_etape%2Cstatut_syndic"
p_outSR="$pm_sr"

cp_url="http://couverture-mobile.orange.fr/arcsig/rest/services/extern/optimum_ftth/MapServer/0/query?token=$pm_token&f=$p_format&where=$p_where&returnGeometry=$p_returnGeometry&spatialRel=$p_spatialRel&geometry=$p_geometry&geometryType=$p_geometryType&inSR=$p_inSR&outFields=$p_outFields&outSR=$p_outSR"

cp_cookie="Cookie: o-cookie-cnil=1; Orange_VU_PROD_B1=Version=5&data=vnaTOLuXpnd2AvYNFHiq1ltc/YRZq72EaO6tt0xiJSp7oLNoEUupV0lWcgDVbKpf2T07RY1TdckcQxF4ZN99uHgVzpKMokMzD7rDg/5ibzxnRhN61unyeOE3PokVoMhPnVKuc2HZ61TIYUd9XkBT24NkXsyq6PQYqXhAvlP6Im0=; ty=6; _gstat=1748096872.1475167334084"
cp_ua="User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/55.0.2883.11 Chrome/55.0.2883.11 Safari/537.36"
cp_referer="Referer: http://couverture-mobile.orange.fr/mapV3/fibre/index.html?geosignet=true&groupegeosignet=caraibeindien"

data=$(curl "$cp_url" -H "$cp_cookie" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,fr;q=0.6' -H "$cp_ua" -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H "$cp_referer" -H 'X-Requested-With: XMLHttpRequest' -H 'X-CookiesOK: I explicitly accept all cookies' -H 'Connection: keep-alive' -sS --compressed)

pretty=$(echo $data | jq --color-output ${5:-.})
echo $pretty
