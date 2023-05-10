DROP TABLE IF EXISTS adm_dds.h_ticket_flight;

CREATE TABLE adm_dds.h_ticket_flight (
    ticket_flight__hk     	varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	flight_no				varchar,
	scheduled_departure		timestamp,
  	ticket_no				varchar
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.h_ticket_flight
SELECT
	MD5(concat(fl.flight_no, ':', TO_CHAR(fl.scheduled_departure, 'YYYY/MM/DD HH12:MM:SS'), ':', tfl.ticket_no)) AS ticket_flight__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	fl.flight_no AS flight_no,
	fl.scheduled_departure AS scheduled_departure,
	tfl.ticket_no AS ticket_no
FROM bookings.ticket_flights AS tfl
LEFT JOIN bookings.flights AS fl ON tfl.flight_id = fl.flight_id
WHERE 1=1;