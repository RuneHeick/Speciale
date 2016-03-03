(SELECT 
  homes_meterport.name,
  homes_meterport.unit,
  homes_meterport.id,
  homes_appliance.name
FROM 
  ((public.homes_submeter JOIN homes_meterport ON homes_submeter.id = homes_meterport.submeter_id)
  LEFT JOIN homes_energyconsumptionperiod ON homes_meterport.energy_consumption_period_id = homes_energyconsumptionperiod.id)
  LEFT JOIN homes_appliance ON homes_energyconsumptionperiod.appliance_id = homes_appliance.id
WHERE 
  homes_submeter.residential_home_id = 4

UNION

SELECT  
  homes_meterport.name,
  homes_meterport.unit,
  homes_meterport.id,
  coalesce(homes_appliance.name, 'Main Meter') as name
FROM 
  ((public.homes_mainmeter INNER JOIN homes_meterport ON homes_mainmeter.id = homes_meterport.mainmeter_id)
  LEFT JOIN homes_energyconsumptionperiod ON homes_meterport.energy_consumption_period_id = homes_energyconsumptionperiod.id)
  LEFT JOIN homes_appliance ON homes_energyconsumptionperiod.appliance_id = homes_appliance.id
WHERE 
  homes_mainmeter.residential_home_id = 4
  
);