# Layer des batiments

## Informations generales
Ce layer est le layer (a mon humble avis) le plus interessant, puisqu'il contient tous les batiments (immeubles et maisons) individuellement, avec pas mal d'infos

* L'url de ce layer est `http://couverture-mobile.orange.fr/arcsig/rest/services/extern/optimum_ftth/MapServer/0`
* Le nom interne est "optimum", allez savoir...
* A priori il supporte le json et l'AMF comme formats
* MaxRecordCount = 1000
* La map d'Orange le query toujours avec where = `(etape='0' AND sous_etape not in ('A','B')) or (etape<>'0') or (etape='' AND sous_etape not in ('A','B'))`

## Informations du layer
(NOTE: j'omet OBJECTID et Shape ici, etant des elements d'ArcGIS)

* no_dossier: a priori un numero interne a Orange
* adresse: l'adresse postale, avec code postal et ville
* type_logement: peux contenir `"imm" ou "pav"`, soit "immeuble" et "pavillon"
* etat: "etat d'avancement fibre", peux contenir `"commercialisable", "signe", "raccordable", "adressable", "_"` (indisponible)
* operateur: l'operateur (je suppose l'operateur qui a pose la fibre)
* etape: `1,2,3,4`; comme sur la map, respectivement `"fibre dans la ville", "fibre dans le quartier", "pres du logement", "eligible"`, en pratique, ca a l'air de se traduire par "la fibre est posee, pt'et l'armoire de raccordement aussi", "l'armoire est equipee", "l'armoire est active", "on a lance la commercialisation"
* sous_etape: `A, B ou C`, aucune idee (**HELP NEEDED**)
* statut_syndic: le status du syndic de l'immeuble, ou "PS" par defaut pour les pavillons, semble pouvoir contenir `"OK", "EC" (En Cours), "PS" (Pas Signe), "BD" (...?)`

## Remarques

* Si `type_logement=pav`, etat semble juste contenir "adressable", je devine que la difference entre "adressable" et "raccordable" est que l'un concerne le batiment, l'autre est specifique pour les appartements d'un immeuble
* J'ai aucune idee de ce que veux dire "BD" dans statut_syndic, logiquement, ca devrait traduire le fait que le syndic a refuse de signer? (tres rare de rencontrer "BD" sur la map)
* Aucune idee non plus de ce qu'est sous_etape, mais ce qui est sur, c'est que le sens de A, B et C depend de etape, `etape=1 sous_etape=B` n'aura pas le meme sens que `etape=3 sous_etape=B`. Orange semble degager tout ce qui est `etape=0 et sous_etape=A ou B` (avec le parametre where)
* "commercialisable" semble etre specifique a l'etape 4, "signe" semble se recontrer a l'etape 2 et 3, "raccordable" et "adressable" semblent se rencontrer qu'a l'etape 2