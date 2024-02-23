CREATE VIEW bilan.stats_generales_nb_obs AS
WITH obs_leuco AS (
SELECT id_station,nom_latin,date1,CASE WHEN effectif_total IS NULL THEN 1 ELSE effectif_total END AS effectif_total
FROM bilan.bilan_obs_leucorrhinia
GROUP BY id_station,nom_latin,date1,effectif_total)

SELECT nom_latin,
       count(*) AS nbre_obs,
       sum(effectif_total) as effectif_total,
       sum(effectif_total) / count(*) AS nbre_individus_par_obs
FROM obs_leuco
GROUP BY nom_latin
ORDER BY nom_latin;
