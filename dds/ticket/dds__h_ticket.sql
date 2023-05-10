DROP TABLE IF EXISTS adm_dds.h_ticket;

CREATE TABLE adm_dds.h_ticket (
    ticket__hk     			varchar not null,
    load_date      			timestamp,
  	record_source       	varchar,
  	ticket_no				varchar
);-- PARTITION BY aircraft_hk;


INSERT INTO adm_dds.h_ticket
SELECT
	MD5(t.ticket_no) AS ticket__hk,
	current_timestamp(1) AT TIME ZONE 'Europe/Moscow' AS load_date,
	'1' AS record_source,
	t.ticket_no AS ticket_no
FROM bookings.tickets AS t
WHERE 1=1;
