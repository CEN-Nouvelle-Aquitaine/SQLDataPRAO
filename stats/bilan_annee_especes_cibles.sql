--Nombre d'observations par année toutes espèces confondues

SELECT extract(year FROM date_obs) AS annee,count(*) AS nb_obs
FROM bilan.observations_bilan_carto
WHERE extract(year FROM date_obs) IS NOT NULL
GROUP BY annee
ORDER BY annee ASC