#!/usr/bin/env bash

ORANGE_PATH="./script.sh"
HOME_X="your_home_x"
HOME_Y="your_home_y"
RAW=$($ORANGE_PATH "$HOME_X" "$HOME_Y" "$HOME_X" "$HOME_Y" '.features|.[0].attributes')

etat=$(echo "$RAW" | jq .etat | tr -d "\"")
etape=$(echo "$RAW" | jq .etape | tr -d "\"")
statut=$(echo "$RAW" | jq .statut_syndic | tr -d "\"")

echo -n "Etat: "
if [[ "$etat" == "_" ]]; then
	echo "pas disponible"
else
	echo "$etat"
fi

echo -n "Etape: "
if [[ "$etape" == "1" ]]; then
	echo "armoire non activee"
elif [[ "$etape" == "2" ]]; then
	echo "amoire activee"
elif [[ "$etape" == "3" ]]; then
	echo "raccordement possible"
elif [[ "$etape" == "4" ]]; then
	echo "immeuble raccorde"
fi

echo -n "Accord: "
if [[ "$statut" == "PS" ]]; then
	echo "non"
elif [[ "$statut" == "EC" ]]; then
	echo "negociations en cours"
elif [[ "$statut" == "OK" ]]; then
	echo "oui"
else
	echo "N/A"
fi
