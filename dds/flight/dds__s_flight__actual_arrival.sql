DROP TABLE IF EXISTS adm_dds.s_flight__actual_arrival;

CREATE TABLE adm_dds.s_flight__actual_arrival (
    flight__hk     			varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	actual_arrival			timestamp
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.s_flight__actual_arrival
SELECT
	MD5(concat(fl.flight_no, ':', TO_CHAR(fl.scheduled_departure, 'YYYY/MM/DD HH12:MM:SS'))) AS flight__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	fl.actual_arrival AS actual_arrival
FROM bookings.flights AS fl
WHERE 1=1;

SELECT current_timestamp(1) AT TIME ZONE 'Europe/Moscow';;