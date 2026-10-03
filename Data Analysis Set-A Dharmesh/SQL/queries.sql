----- S2a — Total delay days by service type -----

SELECT r.service_type, SUM(
	CASE
		WHEN d.actual_days - d.promised_days > 0
		THEN d.actual_days - d.promised_days
	ELSE 0
	END
) AS total_delay_days
FROM deliveries d JOIN routes r ON d.route_id = r.route_id
GROUP BY r.service_type ORDER BY total_delay_days DESC;


-- S2b — Routes with significant delay

SELECT d.route_id, SUM(
	CASE
		WHEN d.actual_days - d.promised_days > 0
		THEN d.actual_days - d.promised_days
		ELSE 0
	END
) AS total_delay_days FROM deliveries d GROUP BY d.route_id 
HAVING total_delay_days > 3 ORDER BY total_delay_days DESC;


-- S2c — Top two hubs by delay

SELECT hub, SUM(
	CASE
		WHEN actual_days - promised_days > 0
		THEN actual_days - promised_days
		ELSE 0
	END
) AS total_delay_days FROM deliveries GROUP BY hub
ORDER BY total_delay_days DESC, hub ASC LIMIT 2;



SELECT d.record_id, d.route_id FROM deliveries d
LEFT JOIN routes r ON d.route_id = r.route_id
WHERE r.route_id IS NULL;