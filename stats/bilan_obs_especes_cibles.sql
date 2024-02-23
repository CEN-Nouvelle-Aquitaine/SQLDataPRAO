--Nombre d'observations par espèce ciblée

SELECT nom_latin,count(*) AS nb_obs
FROM bilan.observations_bilan_carto
GROUP BY nom_latin
ORDER BY nom_latin ASC