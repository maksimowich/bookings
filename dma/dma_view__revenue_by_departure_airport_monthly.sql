CREATE OR REPLACE VIEW adm_dma.revenue_by_departure_airport_monthly AS
WITH s_ticket_flight__amount AS (
    SELECT
        *
    FROM (
        SELECT
            row_number()  over(partition by ticket_flight__hk order by load_date desc) as rn,
            ticket_flight__hk,
            amount
        FROM adm_dds.s_ticket_flight__amount
         ) tfa
    WHERE rn = 1
), s_airport__city_en AS (
    SELECT
        *
    FROM (
        SELECT
            row_number()  over(partition by airport__hk order by load_date desc) as rn,
            airport__hk,
            city_en
        FROM adm_dds.s_airport__city_en
         ) ac
    WHERE rn = 1
)
SELECT
    date_trunc('day', tf.scheduled_departure) AS scheduled_departure_day,
    ac.city_en AS city,
    sum(tfa.amount) AS renevue_monthly
FROM adm_dds.h_ticket_flight AS tf
LEFT JOIN s_ticket_flight__amount AS tfa
    ON tf.ticket_flight__hk = tfa.ticket_flight__hk
LEFT JOIN adm_dds.l_flight__ticket_flight AS fll
    ON tf.ticket_flight__hk = fll.ticket_flight__hk
LEFT JOIN adm_dds.l_flight__departure_airport AS fldep
    ON fll.flight__hk = fldep.flight__hk
LEFT JOIN s_airport__city_en AS ac
    ON fldep.airport__hk == ac.airport__hk
GROUP BY 1, 2;

DROP VIEW adm_dma.revenue_by_departure_airport_monthly;