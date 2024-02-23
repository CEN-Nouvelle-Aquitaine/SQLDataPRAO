--Vue qui permet d'afficher sous forme de point toutes les observations avec la date
CREATE VIEW bilan.observations_bilan_carto AS 
WITH obs_point AS
(
SELECT 'point' As geom_source, cdref, nom_latin, date1, geom
FROM observations.especes_point
WHERE etat_biologique = 'Observé vivant'
AND (doublon IS NULL OR doublon = false)
AND (douteux IS NULL OR douteux = false)
GROUP BY cdref, nom_latin, date1, geom
),

obs_lineaire AS
(
SELECT 'lineaire' As geom_source, cdref, nom_latin, date1, ST_Centroid(geom) AS geom
FROM observations.especes_lineaire
WHERE etat_biologique = 'Observé vivant'
AND (doublon IS NULL OR doublon = false)
AND (douteux IS NULL OR douteux = false)
GROUP BY cdref, nom_latin, date1, date1, geom
),

obs_polygone AS
(
SELECT 'polygone' As geom_source, cdref, nom_latin, date1, ST_Centroid(geom) AS geom
FROM observations.especes_polygone
WHERE etat_biologique = 'Observé vivant'
AND (doublon IS NULL OR doublon = false)
AND (douteux IS NULL OR douteux = false)
GROUP BY cdref, nom_latin, date1, geom
),

obs_union AS

(
SELECT * FROM obs_point
UNION
SELECT * FROM obs_lineaire
UNION
SELECT * FROM obs_polygone
)

SELECT ROW_NUMBER() over()::bigint as gid,obs_union.geom_source, cdref, nom_latin, date1 AS date_obs, geom
FROM obs_union
ORDER BY nom_latin,date1,geom_source ASC;

