
WITH obs_lal AS (

SELECT id_station,nom_latin,date1,effectif_total,
    CASE
        WHEN effectif_total = 1 THEN '1'
        WHEN effectif_total >= 2 AND effectif_total <= 5 THEN '2-5'
        WHEN effectif_total >= 6 AND effectif_total <= 20 THEN '6-20'
        WHEN effectif_total >= 21 AND effectif_total <= 50 THEN '21-50'
        WHEN effectif_total > 50 THEN '>50'
        ELSE 'erreur'
    END AS classe_effectif
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia albifrons (Burmeister, 1839)'
GROUP BY id_station,nom_latin,date1,effectif_total),

bilan_station_lal AS (
SELECT obs_lal.id_station,obs_lal.nom_latin,bslal.classement_station,obs_lal.classe_effectif,
    count(*) AS nbre_obs
   FROM obs_lal
LEFT JOIN bilan.bilan_stationnel_2021_lal bslal ON obs_lal.id_station = bslal.id_station
  GROUP BY obs_lal.id_station,obs_lal.nom_latin,bslal.classement_station,obs_lal.classe_effectif
  ORDER BY obs_lal.id_station,obs_lal.nom_latin,bslal.classement_station,obs_lal.classe_effectif),

obs_lca AS (

SELECT id_station,nom_latin,date1,effectif_total,
    CASE
        WHEN effectif_total = 1 THEN '1'
        WHEN effectif_total >= 2 AND effectif_total <= 5 THEN '2-5'
        WHEN effectif_total >= 6 AND effectif_total <= 20 THEN '6-20'
        WHEN effectif_total >= 21 AND effectif_total <= 50 THEN '21-50'
        WHEN effectif_total > 50 THEN '>50'
        ELSE 'erreur'
    END AS classe_effectif
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia caudalis (Charpentier, 1840)'
GROUP BY id_station,nom_latin,date1,effectif_total),

bilan_station_lca AS (
SELECT obs_lca.id_station,obs_lca.nom_latin,bslca.classement_station,obs_lca.classe_effectif,
    count(*) AS nbre_obs
   FROM obs_lca
LEFT JOIN bilan.bilan_stationnel_2021_lca bslca ON obs_lca.id_station = bslca.id_station
  GROUP BY obs_lca.id_station,obs_lca.nom_latin,bslca.classement_station,obs_lca.classe_effectif
  ORDER BY obs_lca.id_station,obs_lca.nom_latin,bslca.classement_station,obs_lca.classe_effectif),

obs_lpe AS (

SELECT id_station,nom_latin,date1,effectif_total,
    CASE
        WHEN effectif_total = 1 THEN '1'
        WHEN effectif_total >= 2 AND effectif_total <= 5 THEN '2-5'
        WHEN effectif_total >= 6 AND effectif_total <= 20 THEN '6-20'
        WHEN effectif_total >= 21 AND effectif_total <= 50 THEN '21-50'
        WHEN effectif_total > 50 THEN '>50'
        ELSE 'erreur'
    END AS classe_effectif
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia pectoralis (Charpentier, 1825)'
GROUP BY id_station,nom_latin,date1,effectif_total),

bilan_station_lpe AS (
SELECT obs_lpe.id_station,obs_lpe.nom_latin,bslpe.classement_station,obs_lpe.classe_effectif,
    count(*) AS nbre_obs
   FROM obs_lpe
LEFT JOIN bilan.bilan_stationnel_2021_lpe bslpe ON obs_lpe.id_station = bslpe.id_station
  GROUP BY obs_lpe.id_station,obs_lpe.nom_latin,bslpe.classement_station,obs_lpe.classe_effectif
  ORDER BY obs_lpe.id_station,obs_lpe.nom_latin,bslpe.classement_station,obs_lpe.classe_effectif)



SELECT nom_latin,classement_station,classe_effectif ,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lal
GROUP BY nom_latin,classement_station,classe_effectif
UNION
SELECT nom_latin,classement_station,classe_effectif,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lca
GROUP BY nom_latin,classement_station,classe_effectif
UNION
SELECT nom_latin,classement_station,classe_effectif,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lpe
GROUP BY nom_latin,classement_station,classe_effectif
ORDER BY nom_latin,classement_station,classe_effectif

