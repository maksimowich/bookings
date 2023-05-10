DROP TABLE IF EXISTS adm_dds.s_airport__city_en;

CREATE TABLE adm_dds.s_airport__city_en (
    airport__hk     		varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	city_en					varchar
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.s_airport__city_en
SELECT
	MD5(a.airport_code) AS airport__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	a.city::jsonb->'en' AS city_en
FROM bookings.airports_data AS a
WHERE 1=1;
