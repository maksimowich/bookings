DROP TABLE IF EXISTS  adm_dds.h_flight;

CREATE TABLE adm_dds.h_flight (
    flight__hk     			varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	flight_no				varchar,
	scheduled_departure		timestamp
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.h_flight
SELECT
	MD5(concat(fl.flight_no, ':', TO_CHAR(fl.scheduled_departure, 'YYYY/MM/DD HH12:MM:SS'))) AS flight__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	fl.flight_no AS flight_no,
	fl.scheduled_departure AS scheduled_departure
FROM bookings.flights AS fl
WHERE 1=1;
