DROP TABLE IF EXISTS adm_dds.s_ticket_flight__amount;

CREATE TABLE adm_dds.s_ticket_flight__amount (
    ticket_flight__hk     	varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	amount					numeric(10, 2)
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.s_ticket_flight__amount
SELECT
	MD5(concat(fl.flight_no, ':', TO_CHAR(fl.scheduled_departure, 'YYYY/MM/DD HH12:MM:SS'), ':', tfl.ticket_no)) AS ticket_flight__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	tfl.amount AS amount
FROM bookings.ticket_flights AS tfl
LEFT JOIN bookings.flights AS fl ON tfl.flight_id = fl.flight_id
WHERE 1=1;
