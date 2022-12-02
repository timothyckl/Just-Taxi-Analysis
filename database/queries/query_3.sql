-- This query shows the total rides, unsafe rides and the percentage of unsafe rides to total rides.
-- The insight is that both genders have the same unsafe rides percentage.


select 
	d.gender,
	count(t.booking_id) "total_rides",
	max(x.unsafe) "unsafe rides",
	round(
        (cast(max(x.unsafe)as float) / cast(count(y.total)as float)) * 100, 3
    ) 'Unsafe rides percantage'

from	
	trips t,  drivers d,
	(
	select d.gender, count(t.booking_id) "unsafe"
	from trips  t, drivers  d 
	where t.safety_label = 1
	group by d.gender
	) x join
	(
	select d.gender, count(t.booking_id) "total"
	from trips  t, drivers  d 
	group by d.gender
	) y on x.gender = y.gender
where d.gender = x.gender

group by d.gender
 
