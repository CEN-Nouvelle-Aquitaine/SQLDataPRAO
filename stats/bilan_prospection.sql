--POur chaque station, date de dernière obs vs date de dernière prospection

WITH bilan_station_lal AS (
SELECT bslal.id_station,'Leucorrhinia albifrons (Burmeister, 1839)' AS nom_latin,bslal.classement_station, bslal.derniere_annee_total,
       station.date_derniere_prosp,station.geom
FROM bilan.bilan_stationnel_2021_lal bslal
LEFT JOIN localite.station ON bslal.id_station = station.id_station
WHERE (classement_station = 'Station ancienne' OR classement_station = 'Station historique')
 ),

bilan_non_obs_lal_ponctuel AS (
SELECT especes_point.id_station,max(date1) AS date_non_obs
FROM observations.especes_point
LEFT JOIN bilan_station_lal ON bilan_station_lal.id_station = especes_point.id_station
WHERE especes_point.nom_latin = 'Leucorrhinia albifrons (Burmeister, 1839)' AND etat_biologique = 'Non observé' AND bilan_station_lal.classement_station != 'Station récente'
GROUP BY especes_point.id_station ),

bilan_non_obs_lal_polygone AS (
SELECT especes_polygone.id_station,max(date1) AS date_non_obs
FROM observations.especes_polygone
LEFT JOIN bilan_station_lal ON bilan_station_lal.id_station = especes_polygone.id_station
WHERE especes_polygone.nom_latin = 'Leucorrhinia albifrons (Burmeister, 1839)' AND etat_biologique = 'Non observé' AND bilan_station_lal.classement_station != 'Station récente'
GROUP BY especes_polygone.id_station ),

bilan_non_obs_lal_lineaire AS (
SELECT especes_lineaire.id_station,max(date1) AS date_non_obs
FROM observations.especes_lineaire
LEFT JOIN bilan_station_lal ON bilan_station_lal.id_station = especes_lineaire.id_station
WHERE especes_lineaire.nom_latin = 'Leucorrhinia albifrons (Burmeister, 1839)' AND etat_biologique = 'Non observé' AND bilan_station_lal.classement_station != 'Station récente'
GROUP BY especes_lineaire.id_station ),

bilan_non_obs_lal_union AS (SELECT *
                        FROM bilan_non_obs_lal_ponctuel
                        UNION
                        SELECT *
                        FROM bilan_non_obs_lal_polygone
                        UNION
                        SELECT *
                        FROM bilan_non_obs_lal_lineaire),

bilan_non_obs_lal AS
(
SELECT id_station, max(date_non_obs) AS date_non_obs
FROM bilan_non_obs_lal_union
GROUP BY id_station),

bilan_lal AS (
SELECT bilan_station_lal.id_station,nom_latin,classement_station,derniere_annee_total,
       extract(year FROM date_derniere_prosp) AS annee_derniere_prosp,extract(year FROM date_non_obs) AS annee_non_obs,
       GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs)) AS derniere_annee_total,
       CASE
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer >= (2021 - 4) THEN 'Prospection récente'::text
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer >= (2021 - 8) THEN 'Prospection ancienne'::text
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer < (2021 - 8) THEN 'Prospection historique'::text
           ELSE 'Aucune prospection'::text
           END AS classement_prospection,bilan_station_lal.geom

       FROM bilan_station_lal
LEFT JOIN bilan_non_obs_lal ON bilan_station_lal.id_station = bilan_non_obs_lal.id_station
ORDER BY bilan_station_lal.id_station),

bilan_station_lca AS (
SELECT bslca.id_station,'Leucorrhinia caudalis (Charpentier, 1840)' AS nom_latin,bslca.classement_station, bslca.derniere_annee_total,
       station.date_derniere_prosp,station.geom
FROM bilan.bilan_stationnel_2021_lca bslca
LEFT JOIN localite.station ON bslca.id_station = station.id_station
WHERE (classement_station = 'Station ancienne' OR classement_station = 'Station historique')
 ),

bilan_non_obs_lca_ponctuel AS (
SELECT especes_point.id_station,max(date1) AS date_non_obs
FROM observations.especes_point
LEFT JOIN bilan_station_lca ON bilan_station_lca.id_station = especes_point.id_station
WHERE especes_point.nom_latin = 'Leucorrhinia caudalis (Charpentier, 1840)' AND etat_biologique = 'Non observé' AND bilan_station_lca.classement_station != 'Station récente'
GROUP BY especes_point.id_station ),

bilan_non_obs_lca_polygone AS (
SELECT especes_polygone.id_station,max(date1) AS date_non_obs
FROM observations.especes_polygone
LEFT JOIN bilan_station_lca ON bilan_station_lca.id_station = especes_polygone.id_station
WHERE especes_polygone.nom_latin = 'Leucorrhinia caudalis (Charpentier, 1840)' AND etat_biologique = 'Non observé' AND bilan_station_lca.classement_station != 'Station récente'
GROUP BY especes_polygone.id_station ),

bilan_non_obs_lca_lineaire AS (
SELECT especes_lineaire.id_station,max(date1) AS date_non_obs
FROM observations.especes_lineaire
LEFT JOIN bilan_station_lca ON bilan_station_lca.id_station = especes_lineaire.id_station
WHERE especes_lineaire.nom_latin = 'Leucorrhinia caudalis (Charpentier, 1840)' AND etat_biologique = 'Non observé' AND bilan_station_lca.classement_station != 'Station récente'
GROUP BY especes_lineaire.id_station ),

bilan_non_obs_lca_union AS (SELECT *
                        FROM bilan_non_obs_lca_ponctuel
                        UNION
                        SELECT *
                        FROM bilan_non_obs_lca_polygone
                        UNION
                        SELECT *
                        FROM bilan_non_obs_lca_lineaire),

bilan_non_obs_lca AS
(
SELECT id_station, max(date_non_obs) AS date_non_obs
FROM bilan_non_obs_lca_union
GROUP BY id_station),

bilan_lca AS (
SELECT bilan_station_lca.id_station,nom_latin,classement_station,derniere_annee_total,
       extract(year FROM date_derniere_prosp) AS annee_derniere_prosp,extract(year FROM date_non_obs) AS annee_non_obs,
       GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs)) AS derniere_annee_total,
       CASE
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer >= (2021 - 4) THEN 'Prospection récente'::text
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer >= (2021 - 8) THEN 'Prospection ancienne'::text
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer < (2021 - 8) THEN 'Prospection historique'::text
           ELSE 'Aucune prospection'::text
           END AS classement_prospection,bilan_station_lca.geom

       FROM bilan_station_lca
LEFT JOIN bilan_non_obs_lca ON bilan_station_lca.id_station = bilan_non_obs_lca.id_station
ORDER BY bilan_station_lca.id_station),

bilan_station_lpe AS (
SELECT bslpe.id_station,'Leucorrhinia pectoralis (Charpentier, 1825)' AS nom_latin,bslpe.classement_station, bslpe.derniere_annee_total,
       station.date_derniere_prosp,station.geom
FROM bilan.bilan_stationnel_2021_lpe bslpe
LEFT JOIN localite.station ON bslpe.id_station = station.id_station
WHERE (classement_station = 'Station ancienne' OR classement_station = 'Station historique')
 ),

bilan_non_obs_lpe_ponctuel AS (
SELECT especes_point.id_station,max(date1) AS date_non_obs
FROM observations.especes_point
LEFT JOIN bilan_station_lpe ON bilan_station_lpe.id_station = especes_point.id_station
WHERE especes_point.nom_latin = 'Leucorrhinia pectoralis (Charpentier, 1825)' AND etat_biologique = 'Non observé' AND bilan_station_lpe.classement_station != 'Station récente'
GROUP BY especes_point.id_station ),

bilan_non_obs_lpe_polygone AS (
SELECT especes_polygone.id_station,max(date1) AS date_non_obs
FROM observations.especes_polygone
LEFT JOIN bilan_station_lpe ON bilan_station_lpe.id_station = especes_polygone.id_station
WHERE especes_polygone.nom_latin = 'Leucorrhinia pectoralis (Charpentier, 1825)' AND etat_biologique = 'Non observé' AND bilan_station_lpe.classement_station != 'Station récente'
GROUP BY especes_polygone.id_station ),

bilan_non_obs_lpe_lineaire AS (
SELECT especes_lineaire.id_station,max(date1) AS date_non_obs
FROM observations.especes_lineaire
LEFT JOIN bilan_station_lpe ON bilan_station_lpe.id_station = especes_lineaire.id_station
WHERE especes_lineaire.nom_latin = 'Leucorrhinia pectoralis (Charpentier, 1825)' AND etat_biologique = 'Non observé' AND bilan_station_lpe.classement_station != 'Station récente'
GROUP BY especes_lineaire.id_station ),

bilan_non_obs_lpe_union AS (SELECT *
                        FROM bilan_non_obs_lpe_ponctuel
                        UNION
                        SELECT *
                        FROM bilan_non_obs_lpe_polygone
                        UNION
                        SELECT *
                        FROM bilan_non_obs_lpe_lineaire),

bilan_non_obs_lpe AS
(
SELECT id_station, max(date_non_obs) AS date_non_obs
FROM bilan_non_obs_lpe_union
GROUP BY id_station),

bilan_lpe AS (
SELECT bilan_station_lpe.id_station,nom_latin,classement_station,derniere_annee_total,
       extract(year FROM date_derniere_prosp) AS annee_derniere_prosp,extract(year FROM date_non_obs) AS annee_non_obs,
       GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs)) AS derniere_annee_total,
       CASE
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer >= (2021 - 4) THEN 'Prospection récente'::text
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer >= (2021 - 8) THEN 'Prospection ancienne'::text
           WHEN GREATEST (derniere_annee_total,extract(year FROM date_derniere_prosp),extract(year FROM date_non_obs))::integer < (2021 - 8) THEN 'Prospection historique'::text
           ELSE 'Aucune prospection'::text
           END AS classement_prospection,bilan_station_lpe.geom

       FROM bilan_station_lpe
LEFT JOIN bilan_non_obs_lpe ON bilan_station_lpe.id_station = bilan_non_obs_lpe.id_station
ORDER BY bilan_station_lpe.id_station)

SELECT * FROM bilan_lal
UNION
SELECT * FROM bilan_lca
UNION
SELECT * FROM bilan_lpe
ORDER BY id_station,nom_latin
