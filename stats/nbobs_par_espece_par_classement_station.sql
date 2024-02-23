
WITH obs_lal AS (

SELECT id_station,nom_latin,date1,effectif_total
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia albifrons (Burmeister, 1839)'
GROUP BY id_station,nom_latin,date1,effectif_total),

bilan_station_lal AS (
SELECT obs_lal.id_station,obs_lal.nom_latin,bslal.classement_station,
    count(*) AS nbre_obs
   FROM obs_lal
LEFT JOIN bilan.bilan_stationnel_2021_lal bslal ON obs_lal.id_station = bslal.id_station
  GROUP BY obs_lal.id_station,obs_lal.nom_latin,bslal.classement_station
  ORDER BY obs_lal.id_station,obs_lal.nom_latin,bslal.classement_station),

obs_lca AS (

SELECT id_station,nom_latin,date1,effectif_total
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia caudalis (Charpentier, 1840)'
GROUP BY id_station,nom_latin,date1,effectif_total),

bilan_station_lca AS (
SELECT obs_lca.id_station,obs_lca.nom_latin,bslca.classement_station,
    count(*) AS nbre_obs
   FROM obs_lca
LEFT JOIN bilan.bilan_stationnel_2021_lca bslca ON obs_lca.id_station = bslca.id_station
  GROUP BY obs_lca.id_station,obs_lca.nom_latin,bslca.classement_station
  ORDER BY obs_lca.id_station,obs_lca.nom_latin,bslca.classement_station),

obs_lpe AS (

SELECT id_station,nom_latin,date1,effectif_total
FROM bilan.bilan_obs_leucorrhinia
WHERE nom_latin = 'Leucorrhinia pectoralis (Charpentier, 1825)'
GROUP BY id_station,nom_latin,date1,effectif_total),

bilan_station_lpe AS (
SELECT obs_lpe.id_station,obs_lpe.nom_latin,bslpe.classement_station,
    count(*) AS nbre_obs
   FROM obs_lpe
LEFT JOIN bilan.bilan_stationnel_2021_lpe bslpe ON obs_lpe.id_station = bslpe.id_station
  GROUP BY obs_lpe.id_station,obs_lpe.nom_latin,bslpe.classement_station
  ORDER BY obs_lpe.id_station,obs_lpe.nom_latin,bslpe.classement_station)



SELECT nom_latin,classement_station,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lal
GROUP BY nom_latin,classement_station
UNION
SELECT nom_latin,classement_station,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lca
GROUP BY nom_latin,classement_station
UNION
SELECT nom_latin,classement_station,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lpe
GROUP BY nom_latin,classement_station
ORDER BY nom_latin,classement_station