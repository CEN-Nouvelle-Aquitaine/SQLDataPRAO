WITH obs_lal AS (
SELECT id_station,nom_latin,date1,effectif_total,CASE WHEN id_autochtonie IS NULL THEN 0 ELSE id_autochtonie END AS id_autochtonie
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia albifrons (Burmeister, 1839)'
GROUP BY id_station,nom_latin,date1,effectif_total,id_autochtonie),

bilan_station_lal AS (
    SELECT obs_lal.nom_latin, obs_lal.id_station, max(id_autochtonie) AS id_autochtonie
    FROM obs_lal
    GROUP BY obs_lal.id_station, obs_lal.nom_latin
    ORDER BY obs_lal.id_station, obs_lal.nom_latin),

bilan_lal AS (
SELECT nom_latin,bslal.classement_station,ref_autochtonie.lib_autochtonie,count(*) AS nb_stations
FROM bilan_station_lal
LEFT JOIN bilan.bilan_stationnel_2021_lal bslal ON bilan_station_lal.id_station = bslal.id_station
LEFT JOIN ref.ref_autochtonie ON bilan_station_lal.id_autochtonie = ref_autochtonie.id_ref_autochtonie
GROUP BY nom_latin,bslal.classement_station,ref_autochtonie.lib_autochtonie),

obs_lca AS (
SELECT id_station,nom_latin,date1,effectif_total,CASE WHEN id_autochtonie IS NULL THEN 0 ELSE id_autochtonie END AS id_autochtonie
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia caudalis (Charpentier, 1840)'
GROUP BY id_station,nom_latin,date1,effectif_total,id_autochtonie),

bilan_station_lca AS (
    SELECT obs_lca.nom_latin, obs_lca.id_station, max(id_autochtonie) AS id_autochtonie
    FROM obs_lca
    GROUP BY obs_lca.id_station, obs_lca.nom_latin
    ORDER BY obs_lca.id_station, obs_lca.nom_latin),

bilan_lca AS (
SELECT nom_latin,bslca.classement_station,ref_autochtonie.lib_autochtonie,count(*) AS nb_stations
FROM bilan_station_lca
LEFT JOIN bilan.bilan_stationnel_2021_lca bslca ON bilan_station_lca.id_station = bslca.id_station
LEFT JOIN ref.ref_autochtonie ON bilan_station_lca.id_autochtonie = ref_autochtonie.id_ref_autochtonie
GROUP BY nom_latin,bslca.classement_station,ref_autochtonie.lib_autochtonie),

obs_lpe AS (
SELECT id_station,nom_latin,date1,effectif_total,CASE WHEN id_autochtonie IS NULL THEN 0 ELSE id_autochtonie END AS id_autochtonie
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia pectoralis (Charpentier, 1825)'
GROUP BY id_station,nom_latin,date1,effectif_total,id_autochtonie),

bilan_station_lpe AS (
    SELECT obs_lpe.nom_latin, obs_lpe.id_station, max(id_autochtonie) AS id_autochtonie
    FROM obs_lpe
    GROUP BY obs_lpe.id_station, obs_lpe.nom_latin
    ORDER BY obs_lpe.id_station, obs_lpe.nom_latin),

bilan_lpe AS (
SELECT nom_latin,bslpe.classement_station,ref_autochtonie.lib_autochtonie,count(*) AS nb_stations
FROM bilan_station_lpe
LEFT JOIN bilan.bilan_stationnel_2021_lpe bslpe ON bilan_station_lpe.id_station = bslpe.id_station
LEFT JOIN ref.ref_autochtonie ON bilan_station_lpe.id_autochtonie = ref_autochtonie.id_ref_autochtonie
GROUP BY nom_latin,bslpe.classement_station,ref_autochtonie.lib_autochtonie)

SELECT * FROM bilan_lal
UNION
SELECT * FROM bilan_lca
UNION
SELECT * FROM bilan_lpe
ORDER BY nom_latin,classement_station,lib_autochtonie
