CREATE OR REPLACE VIEW adm_dma.revenue_daily AS
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
)
SELECT
    date_trunc('day', tf.scheduled_departure) AS scheduled_departure_day,
    sum(tfa.amount) AS renevue_daily
FROM adm_dds.h_ticket_flight AS tf
LEFT JOIN s_ticket_flight__amount tfa
    ON tf.ticket_flight__hk = tfa.ticket_flight__hk
GROUP BY 1;

DROP VIEW adm_dma.revenue_daily;