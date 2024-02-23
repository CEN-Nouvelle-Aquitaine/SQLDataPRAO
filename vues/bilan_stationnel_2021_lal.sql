CREATE VIEW bilan.bilan_stationnel_2021_lal AS
WITH
     max_annee_obs_lal_point AS (
         SELECT bol.id_station, max(bol.annee) AS derniere_annee_point
         FROM bilan.bilan_obs_leucorrhinia bol
         WHERE bol.nom_latin::text = 'Leucorrhinia albifrons (Burmeister, 1839)'::text
         AND type_geom = 'point'
         GROUP BY bol.id_station
         ORDER BY (max(bol.annee)) DESC
     ),

     max_annee_obs_lal_lineaire AS (
         SELECT bol.id_station, max(bol.annee) AS derniere_annee_lineaire
         FROM bilan.bilan_obs_leucorrhinia bol
         WHERE bol.nom_latin::text = 'Leucorrhinia albifrons (Burmeister, 1839)'::text
         AND type_geom = 'lineaire'
         GROUP BY bol.id_station
         ORDER BY (max(bol.annee)) DESC
     ),
     max_annee_obs_lal_poly AS (
         SELECT bol.id_station, max(bol.annee) AS derniere_annee_poly
         FROM bilan.bilan_obs_leucorrhinia bol
         WHERE bol.nom_latin::text = 'Leucorrhinia albifrons (Burmeister, 1839)'::text
         AND type_geom = 'polygone'
         GROUP BY bol.id_station
         ORDER BY (max(bol.annee)) DESC
     )
SELECT station.id_station,
       station.lib_station,
       mpoint.derniere_annee_point,
       mlin.derniere_annee_lineaire,
       mpoly.derniere_annee_poly,
       GREATEST(mpoint.derniere_annee_point, mlin.derniere_annee_lineaire,
                mpoly.derniere_annee_poly) AS derniere_annee_total,
       CASE
           WHEN GREATEST(mpoint.derniere_annee_point, mlin.derniere_annee_lineaire,
                         mpoly.derniere_annee_poly)::integer >= (2021 - 4) THEN 'Station récente'::text
           WHEN GREATEST(mpoint.derniere_annee_point, mlin.derniere_annee_lineaire,
                         mpoly.derniere_annee_poly)::integer < (2021 - 4) AND
                GREATEST(mpoint.derniere_annee_point, mlin.derniere_annee_lineaire,
                         mpoly.derniere_annee_poly)::integer >= (2021 - 8) THEN 'Station ancienne'::text
           WHEN GREATEST(mpoint.derniere_annee_point, mlin.derniere_annee_lineaire,
                         mpoly.derniere_annee_poly)::integer < (2021 - 8) THEN 'Station historique'::text
           ELSE 'Aucune observation'::text
           END                             AS classement_station,
       station.geom
FROM localite.station
         LEFT JOIN max_annee_obs_lal_point mpoint ON mpoint.id_station = station.id_station
         LEFT JOIN max_annee_obs_lal_lineaire mlin ON mlin.id_station = station.id_station
         LEFT JOIN max_annee_obs_lal_poly mpoly ON mpoly.id_station = station.id_station
WHERE station.iddep IN ('24','33','40','47','64')
ORDER BY station.id_station;
