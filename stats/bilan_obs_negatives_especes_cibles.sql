-- Nombre de données d'absence par espèce pour montrer la pression d'observation sur les espèces faisant l'objet de données négatives

WITH obs_point AS
(
SELECT 'point' As geom_source, cdref, nom_latin, date1, libsource
FROM observations.especes_point
WHERE etat_biologique = 'Non observé'
AND (doublon IS NULL OR doublon = false)
AND (douteux IS NULL OR douteux = false)
GROUP BY cdref, nom_latin, date1, libsource
),
obs_lineaire AS
(
SELECT 'lineaire' As geom_source, cdref, nom_latin, date1, libsource
FROM observations.especes_lineaire
WHERE etat_biologique = 'Non observé'
AND (doublon IS NULL OR doublon = false)
AND (douteux IS NULL OR douteux = false)
GROUP BY cdref, nom_latin, date1, date1, libsource
),
obs_polygone AS
(
SELECT 'polygone' As geom_source, cdref, nom_latin, date1, libsource
FROM observations.especes_polygone
WHERE etat_biologique = 'Non observé'
AND (doublon IS NULL OR doublon = false)
AND (douteux IS NULL OR douteux = false)
GROUP BY cdref, nom_latin, date1, libsource
),
obs_union AS
(
SELECT * FROM obs_point
UNION
SELECT * FROM obs_lineaire
UNION
SELECT * FROM obs_polygone
)

SELECT nom_latin, count(*) AS nb_obs
FROM obs_union
GROUP BY nom_latin
ORDER BY nom_latin ASC

