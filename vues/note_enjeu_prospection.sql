CREATE VIEW bilan.note_enjeu_prospection AS
WITH bilan_annee AS (
    SELECT bol.id_station,
           bol.nom_latin,
           bol.annee AS annee_obs
    FROM bilan.bilan_obs_leucorrhinia bol
    GROUP BY bol.id_station, bol.nom_latin, bol.annee
    ORDER BY bol.id_station, bol.nom_latin, bol.annee
),
     bilan_espece_station AS (
         SELECT bol.id_station,
                bol.nom_latin
         FROM bilan.bilan_obs_leucorrhinia bol
         GROUP BY bol.id_station, bol.nom_latin
         ORDER BY bol.id_station, bol.nom_latin
     ),
     nbre_espece_station AS (
         SELECT bilan_espece_station.id_station,
                count(bilan_espece_station.nom_latin) AS nbre_espece
         FROM bilan_espece_station
         GROUP BY bilan_espece_station.id_station
         ORDER BY bilan_espece_station.id_station
     )
SELECT bilan_annee.id_station,
       nbre_espece_station.nbre_espece,
       bilan_annee.nom_latin AS espece,
       date_part('year'::text, now()) AS annee_courante,
       '2021' AS annee_reference,
       max(bilan_annee.annee_obs) AS annee_derniere_obs,
       max(bilan_annee.annee_obs)::double precision - (2021 - 5::double precision) AS calcul_annee,
       CASE
           WHEN (max(bilan_annee.annee_obs)::double precision -
                 (2021 - 5::double precision)) > 0::double precision
               THEN 2::double precision
           ELSE max(bilan_annee.annee_obs)::double precision -
                (2021 - 5::double precision)
           END                                                                                                    AS note_annee_derniere_obs,
       count(bilan_annee.annee_obs)                                                                               AS note_nbre_annee,
       count(bilan_annee.annee_obs)::double precision +
       CASE
           WHEN (max(bilan_annee.annee_obs)::double precision -
                 (2021 - 5::double precision)) > 0::double precision
               THEN 2::double precision
           ELSE max(bilan_annee.annee_obs)::double precision -
                (2021 - 5::double precision)
           END                                                                                                    AS note_enjeu_prospection
FROM bilan_annee
         LEFT JOIN nbre_espece_station ON nbre_espece_station.id_station = bilan_annee.id_station
GROUP BY bilan_annee.id_station, nbre_espece_station.nbre_espece, bilan_annee.nom_latin, annee_reference
ORDER BY bilan_annee.id_station, bilan_annee.nom_latin;
