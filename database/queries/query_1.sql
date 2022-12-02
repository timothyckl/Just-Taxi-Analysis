SELECT 
	y.car_model,
	CAST(x.unsafe AS DECIMAL) / y.total * 100 'Danger_Pct'

FROM
(
	SELECT car_model, count(t.safety_label) 'total' FROM drivers d
	LEFT JOIN trips t ON d.driver_id = t.driver_id
	GROUP BY car_model
) as y
JOIN
(
	SELECT car_model, count(t.safety_label) 'unsafe' FROM drivers d
	LEFT JOIN trips t ON d.driver_id = t.driver_id
	WHERE safety_label = 1
	GROUP BY car_model
) as x

ON y.car_model = x.car_model
