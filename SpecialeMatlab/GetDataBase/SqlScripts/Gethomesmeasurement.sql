SELECT 
    extract(epoch from  homes_measurement.timestamp),
    homes_measurement.value,
    homes_measurement.meter_port_id
FROM 
  public.homes_measurement
WHERE 
  homes_measurement.timestamp BETWEEN 'fromtime' AND 'totime' 
  AND homes_measurement.meter_port_id IN (SELECT 
  homes_meterport.id
FROM 
  public.homes_submeter
  INNER JOIN homes_meterport ON homes_submeter.id = homes_meterport.submeter_id
WHERE 
  homes_submeter.residential_home_id = 4
  
UNION

SELECT 
  homes_meterport.id
FROM 
  public.homes_mainmeter
  INNER JOIN homes_meterport ON homes_mainmeter.id = homes_meterport.mainmeter_id
WHERE 
  homes_mainmeter.residential_home_id = 4);