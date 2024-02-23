CREATE VIEW bilan.bilan_obs_leucorrhinia AS
(
WITH obs_lal_point AS (
    SELECT
        especes_point.id_station,
        idespeces_point AS idobs,
        nom_latin,
        idsource,
        libsource,
        'point' AS type_geom,
        date1,
        extract(year FROM date1) AS annee,
        effectif1,
        CASE WHEN effectif2 IS NULL THEN effectif1 ELSE effectif2 END AS effectif2,
        (effectif1::integer + CASE WHEN effectif2 IS NULL THEN effectif1 ELSE effectif2 END::integer) / 2::integer AS effectif_total,
        id_autochtonie
    FROM observations.especes_point
    JOIN localite.station ON especes_point.id_station = station.id_station
        WHERE ("nom_latin" LIKE '%Leucorrhinia%')
        AND especes_point.id_station IS NOT NULL
        --AND effectif1 IS NOT NULL
        AND (doublon IS NULL OR doublon = false)
        AND especes_point.etat_biologique::text = 'Observé vivant'::text
        AND station.iddep IN ('24','33','40','47','64')
    ORDER BY especes_point.id_station, date1),
obs_lal_poly AS (
    SELECT
        especes_polygone.id_station,
        idespeces_polygone AS idobs,
        nom_latin,
        idsource,
        libsource,
        'polygone' AS type_geom,
        date1,
        extract(year FROM date1) AS annee,
        effectif1,
        CASE WHEN effectif2 IS NULL THEN effectif1 ELSE effectif2 END AS effectif2,
        (effectif1::integer + CASE WHEN effectif2 IS NULL THEN effectif1 ELSE effectif2 END::integer) / 2::integer AS effectif_total,
        id_autochtonie
    FROM observations.especes_polygone
     JOIN localite.station ON especes_polygone.id_station = station.id_station
        WHERE
            ("nom_latin" LIKE '%Leucorrhinia%')
            AND especes_polygone.id_station IS NOT NULL
            --AND effectif1 IS NOT NULL
            AND (doublon IS NULL OR doublon = false)
            AND especes_polygone.etat_biologique::text = 'Observé vivant'::text
            AND station.iddep IN ('24','33','40','47','64')
    ORDER BY especes_polygone.id_station, date1),
obs_lal_lineaire AS (
    SELECT
        especes_lineaire.id_station,
        idespeces_lineaire AS idobs,
        nom_latin,
        idsource,
        libsource,
        'lineaire' AS type_geom,
        date1,
        extract(year FROM date1) AS annee,
        effectif1,
        CASE WHEN effectif2 IS NULL THEN effectif1 ELSE effectif2 END AS effectif2,
        (effectif1::integer + CASE WHEN effectif2 IS NULL THEN effectif1 ELSE effectif2 END::integer) / 2::integer                                                    AS effectif_total,
        id_autochtonie
    FROM observations.especes_lineaire
    JOIN localite.station ON especes_lineaire.id_station = station.id_station
        WHERE
            ("nom_latin" LIKE '%Leucorrhinia%')
            AND especes_lineaire.id_station IS NOT NULL
            --AND effectif1 IS NOT NULL
            AND (doublon IS NULL OR doublon = false)
            AND especes_lineaire.etat_biologique::text = 'Observé vivant'::text
            AND station.iddep IN ('24','33','40','47','64')
    ORDER BY especes_lineaire.id_station, date1)
        SELECT *
        FROM obs_lal_point
    UNION
        SELECT *
        FROM obs_lal_poly
    UNION
        SELECT *
        FROM obs_lal_lineaire
    ORDER BY id_station, nom_latin,date1
)