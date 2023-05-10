DROP TABLE IF EXISTS adm_dds.s_flight__actual_departure;

CREATE TABLE adm_dds.s_flight__actual_departure (
    flight__hk     			varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	actual_departure		timestamp
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.s_flight__actual_departure
SELECT
	MD5(concat(fl.flight_no, ':', TO_CHAR(fl.scheduled_departure, 'YYYY/MM/DD HH12:MM:SS'))) AS flight__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	fl.actual_departure AS actual_departure
FROM bookings.flights AS fl
WHERE 1=1;

SELECT current_timestamp(1) AT TIME ZONE 'Europe/Moscow';;