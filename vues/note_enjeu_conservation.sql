CREATE VIEW bilan.note_enjeu_conservation AS
WITH bilan_max AS (
    SELECT bol.nom_latin,
           bol.id_station,
           max(bol.id_autochtonie) AS id_autochtonie,
           max(CASE WHEN bol.effectif_total IS NULL THEN 1 ELSE bol.effectif_total END) AS nbre_individus
    FROM bilan.bilan_obs_leucorrhinia bol
    GROUP BY bol.nom_latin, bol.id_station
    ORDER BY bol.id_station, bol.nom_latin
),
     nbre_espece_station AS (
         SELECT bilan_max_1.id_station,
                count(bilan_max_1.nom_latin) AS nbre_espece
         FROM bilan_max bilan_max_1
         GROUP BY bilan_max_1.id_station
         ORDER BY bilan_max_1.id_station
     )
SELECT bilan_max.id_station,
       bilan_max.nom_latin                                                                                                          AS espece,
       nbre_espece_station.nbre_espece,
       bilan_max.id_autochtonie,
       note_autochtonie.note_autochtonie,
       bilan_max.nbre_individus,
       sg.nbre_individus_par_obs,
       bilan_max.nbre_individus::double precision /
       sg.nbre_individus_par_obs::double precision                                                             AS nbre_tranches_brutes,
       ceil(bilan_max.nbre_individus::double precision /
            sg.nbre_individus_par_obs::double precision)                                                       AS note_effectif,
       note_autochtonie.note_autochtonie::double precision + ceil(bilan_max.nbre_individus::double precision /
                                                                  sg.nbre_individus_par_obs::double precision) AS note_enjeu_conservation
FROM bilan_max
         LEFT JOIN nbre_espece_station ON nbre_espece_station.id_station = bilan_max.id_station
         LEFT JOIN ref.note_autochtonie ON note_autochtonie.id_ref_autochtonie = bilan_max.id_autochtonie
         LEFT JOIN bilan.stats_generales_nb_obs sg
                   ON sg.nom_latin::text = bilan_max.nom_latin::text
ORDER BY bilan_max.id_station, bilan_max.nom_latin;


