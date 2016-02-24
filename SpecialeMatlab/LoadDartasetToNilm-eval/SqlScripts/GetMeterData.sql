SELECT 
  extract(epoch from  homes_measurement.timestamp), 
  homes_measurement.value
FROM 
  public.homes_measurement
WHERE 
  homes_measurement.timestamp > 'fromtime' AND 
  homes_measurement.timestamp < 'totime' AND 
  homes_measurement.meter_port_id = 4;
