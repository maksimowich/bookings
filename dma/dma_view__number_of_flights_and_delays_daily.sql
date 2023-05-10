CREATE OR REPLACE VIEW adm_dma.number_of_flights_and_delays_daily AS
WITH s_flight__actual_departure AS (
    SELECT
        *
    FROM (
        SELECT
            row_number()  over(partition by flight__hk order by load_date desc) as rn,
            flight__hk,
            actual_departure
        FROM adm_dds.s_flight__actual_departure
         )  fap
    WHERE rn = 1
)
SELECT
    date_trunc('day', f.scheduled_departure) AS scheduled_departure_day,
    count(*) AS number_of_scheduled_flights,
    count(CASE WHEN f.scheduled_departure < fap.actual_departure THEN 1 END) AS number_of_delays,
    (count(CASE WHEN EXTRACT(EPOCH FROM (fap.actual_departure - f.scheduled_departure)) > 30  THEN 1 END)
        /
    count(*)::float)::numeric(5, 4) AS fraction_of_more_than_30_sec_delays,

    (count(CASE WHEN EXTRACT(EPOCH FROM (fap.actual_departure - f.scheduled_departure)) > 300  THEN 1 END)
        /
    count(*)::float)::numeric(5, 4) AS fraction_of_more_than_5_min_delays,
    (count(CASE WHEN EXTRACT(EPOCH FROM (fap.actual_departure - f.scheduled_departure)) > 9800  THEN 1 END)
        /
    count(*)::float)::numeric(5, 4) AS fraction_of_more_than_3_hours_delays,
    (count(CASE WHEN EXTRACT(EPOCH FROM (fap.actual_departure - f.scheduled_departure)) > 86400  THEN 1 END)
        /
    count(*)::float)::numeric(5, 4) AS fraction_of_more_than_1_day_delays
FROM adm_dds.h_flight AS f
LEFT JOIN s_flight__actual_departure AS fap
    ON f.flight__hk = fap.flight__hk
GROUP BY 1;

DROP VIEW adm_dma.number_of_flights_and_delays_daily