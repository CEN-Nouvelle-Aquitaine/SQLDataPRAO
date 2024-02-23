WITH obs_lal AS (
SELECT id_station,nom_latin,date1,effectif_total,ref_autochtonie.lib_autochtonie
FROM bilan.bilan_obs_leucorrhinia
LEFT JOIN ref.ref_autochtonie ON bilan_obs_leucorrhinia.id_autochtonie = ref_autochtonie.id_ref_autochtonie
WHERE nom_latin = 'Leucorrhinia albifrons (Burmeister, 1839)'
GROUP BY id_station,nom_latin,date1,effectif_total,ref_autochtonie.lib_autochtonie),

bilan_station_lal AS (
SELECT obs_lal.nom_latin,bslal.classement_station,obs_lal.lib_autochtonie,
    count(*) AS nbre_obs
   FROM obs_lal
LEFT JOIN bilan.bilan_stationnel_2021_lal bslal ON obs_lal.id_station = bslal.id_station
  GROUP BY obs_lal.nom_latin,bslal.classement_station,obs_lal.lib_autochtonie
  ORDER BY obs_lal.nom_latin,bslal.classement_station,obs_lal.lib_autochtonie),

obs_lca AS (

SELECT id_station,nom_latin,date1,effectif_total,ref_autochtonie.lib_autochtonie
FROM bilan.bilan_obs_leucorrhinia
LEFT JOIN ref.ref_autochtonie ON bilan_obs_leucorrhinia.id_autochtonie = ref_autochtonie.id_ref_autochtonie
WHERE nom_latin = 'Leucorrhinia caudalis (Charpentier, 1840)'
GROUP BY id_station,nom_latin,date1,effectif_total,ref_autochtonie.lib_autochtonie),

bilan_station_lca AS (
SELECT obs_lca.nom_latin,bslca.classement_station,obs_lca.lib_autochtonie,
    count(*) AS nbre_obs
   FROM obs_lca
LEFT JOIN bilan.bilan_stationnel_2021_lca bslca ON obs_lca.id_station = bslca.id_station
  GROUP BY obs_lca.nom_latin,bslca.classement_station,obs_lca.lib_autochtonie
  ORDER BY obs_lca.nom_latin,bslca.classement_station,obs_lca.lib_autochtonie),


obs_lpe AS (

SELECT id_station,nom_latin,date1,effectif_total,ref_autochtonie.lib_autochtonie
FROM bilan.bilan_obs_leucorrhinia
LEFT JOIN ref.ref_autochtonie ON bilan_obs_leucorrhinia.id_autochtonie = ref_autochtonie.id_ref_autochtonie
WHERE nom_latin = 'Leucorrhinia pectoralis (Charpentier, 1825)'
GROUP BY id_station,nom_latin,date1,effectif_total,ref_autochtonie.lib_autochtonie),

bilan_station_lpe AS (
SELECT obs_lpe.nom_latin,bslpe.classement_station,obs_lpe.lib_autochtonie,
    count(*) AS nbre_obs
   FROM obs_lpe
LEFT JOIN bilan.bilan_stationnel_2021_lpe bslpe ON obs_lpe.id_station = bslpe.id_station
  GROUP BY obs_lpe.nom_latin,bslpe.classement_station,obs_lpe.lib_autochtonie
  ORDER BY obs_lpe.nom_latin,bslpe.classement_station,obs_lpe.lib_autochtonie)



SELECT nom_latin,classement_station,lib_autochtonie ,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lal
GROUP BY nom_latin,classement_station,lib_autochtonie
UNION
SELECT nom_latin,classement_station,lib_autochtonie,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lca
GROUP BY nom_latin,classement_station,lib_autochtonie
UNION
SELECT nom_latin,classement_station,lib_autochtonie,sum(nbre_obs) AS nbre_obs
FROM bilan_station_lpe
GROUP BY nom_latin,classement_station,lib_autochtonie
ORDER BY nom_latin,classement_station,lib_autochtonie
