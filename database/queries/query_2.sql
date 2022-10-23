-- number of dangerous trips, total trips, and percentage of dangerous trips
select 
	x.driver_id, 
	x.num_danger, 
	y.num_rides, 
	round(
        cast(x.num_danger as float) / cast(y.num_rides as float) * 100, 3
    ) 'danger_pct'
from 
	(
		select convert(int, driver_id) 'driver_id', count(*) 'num_danger'
		from trips
		where safety_label = 1
		group by convert(int, driver_id) 
	) x join
	(
		select convert(int, driver_id) 'driver_id', count(*) 'num_rides'
		from trips
		group by convert(int, driver_id)
	) y on x.driver_id = y.driver_id
order by 
x.driver_id;