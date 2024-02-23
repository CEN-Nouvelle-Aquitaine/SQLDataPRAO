WITH stations_lal AS (

SELECT 'Leucorrhinia albifrons (Burmeister, 1839)' AS nom_latin,classement_station,count(*) AS nb_station
FROM bilan.bilan_stationnel_2021_lal
GROUP BY classement_station),

stations_lca AS (

SELECT 'Leucorrhinia caudalis (Charpentier, 1840)' AS nom_latin,classement_station,count(*) AS nb_station
FROM bilan.bilan_stationnel_2021_lca
GROUP BY classement_station),

stations_lpe AS (

SELECT 'Leucorrhinia pectoralis (Charpentier, 1825)' AS nom_latin,classement_station,count(*) AS nb_station
FROM bilan.bilan_stationnel_2021_lpe
GROUP BY classement_station)

SELECT * FROM stations_lal
UNION
SELECT * FROM stations_lca
UNION
SELECT * FROM stations_lpe
ORDER BY nom_latin,classement_station