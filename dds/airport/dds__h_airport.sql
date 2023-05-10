DROP TABLE IF EXISTS adm_dds.h_airport;

CREATE TABLE adm_dds.h_airport (
    airport__hk     		varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	airport_code			char(3)
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.h_airport
SELECT
	MD5(a.airport_code) AS airport__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	a.airport_code AS airport_code
FROM bookings.airports AS a
WHERE 1=1;
