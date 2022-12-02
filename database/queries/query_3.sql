-- yes


 select 

 t.safety_label,
 d.driver_id,
  sqrt(square(sd.acceleration_x)+square(sd.acceleration_y)+square(sd.acceleration_z)) "magnittude" 

  

  from trips  as t, drivers as d, sensor_data as sd 
	

