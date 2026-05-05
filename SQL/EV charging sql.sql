---1. What are the busiest charging hours?
SELECT DATEPART(HOUR, charging_start_time) AS HourOfDay, COUNT(*) AS SessionCount
FROM ev_charging_dataset
GROUP BY DATEPART(HOUR, charging_start_time)
ORDER BY SessionCount DESC;

---2. Top 5 busiest stations by session count
SELECT station_id, COUNT(*) AS SessionCount,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS RankOrder
FROM ev_charging_dataset
GROUP BY station_id;

---3. Average waiting time by location type
SELECT location_type, AVG(waiting_time) AS AvgWaitingTime
FROM ev_charging_dataset
GROUP BY location_type;

---4. Energy consumed per vehicle type
SELECT vehicle_type, AVG(energy_consumed_kWh) AS AvgEnergy
FROM ev_charging_dataset
GROUP BY vehicle_type
;
---5. Which stations are most utilized?
SELECT station_id, AVG(station_load) AS AvgStationLoad
FROM ev_charging_dataset
GROUP BY station_id
ORDER BY AvgStationLoad DESC;

---6. Queue length distribution
SELECT queue_length, COUNT(*) AS Occurrences
FROM ev_charging_dataset
GROUP BY queue_length
ORDER BY queue_length;

---7. Charging duration by day of week
SELECT day_of_week, AVG(charging_duration) AS AvgDuration
FROM ev_charging_dataset
GROUP BY day_of_week
ORDER BY AvgDuration DESC;

---8. Average renewable energy ratio
SELECT AVG(renewable_energy_ratio) AS AvgRenewableShare
FROM ev_charging_dataset;

---9. Sessions grouped by electricity price
SELECT electricity_price, COUNT(*) AS SessionCount
FROM ev_charging_dataset
GROUP BY electricity_price
ORDER BY electricity_price;

---10. Traffic density impact on waiting time
SELECT traffic_density, AVG(waiting_time) AS AvgWait
FROM ev_charging_dataset
GROUP BY traffic_density;

---11. Longest waiting times per traffic condition
SELECT traffic_density, vehicle_id, waiting_time,
       RANK() OVER (PARTITION BY traffic_density ORDER BY waiting_time DESC) AS RankOrder
FROM ev_charging_dataset;

---12. Average charging duration per station, then rank
WITH StationDurations AS (
    SELECT station_id, AVG(charging_duration) AS AvgDuration
    FROM ev_charging_dataset
    GROUP BY station_id
)
SELECT station_id, AvgDuration,
       RANK() OVER (ORDER BY AvgDuration DESC) AS RankOrder
FROM StationDurations;

---13. Weather impact on charging demand
SELECT weather_condition, AVG(charging_demand) AS AvgDemand
FROM ev_charging_dataset
GROUP BY weather_condition;

---14. Average SOC increase per session
SELECT AVG(final_soc - initial_soc) AS AvgSOCIncrease
FROM ev_charging_dataset;

---15. Top stations by revenue
SELECT station_id, SUM(electricity_price * energy_consumed_kWh) AS TotalRevenue
FROM ev_charging_dataset
GROUP BY station_id
ORDER BY TotalRevenue DESC;

---16. Highest revenue sessions per day
SELECT CAST(timestamp AS DATE) AS Day,
       station_id,
       SUM(electricity_price * energy_consumed_kWh) AS DailyRevenue,
       RANK() OVER (PARTITION BY CAST(timestamp AS DATE) ORDER BY SUM(electricity_price * energy_consumed_kWh) DESC) AS RankOrder
FROM ev_charging_dataset
GROUP BY CAST(timestamp AS DATE), station_id;

---17. Charger utilization
SELECT assigned_charger_id, COUNT(*) AS SessionCount
FROM ev_charging_dataset
GROUP BY assigned_charger_id
ORDER BY SessionCount DESC;

---18. Top 5 chargers by utilization
SELECT assigned_charger_id, COUNT(*) AS SessionCount,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS RankOrder
FROM ev_charging_dataset
GROUP BY assigned_charger_id;

---19. Peak vs off-peak demand
SELECT time_slot, AVG(charging_demand) AS AvgDemand
FROM ev_charging_dataset
GROUP BY time_slot;

---20. Vehicle type distribution
SELECT vehicle_type, COUNT(*) AS TotalSessions
FROM ev_charging_dataset
GROUP BY vehicle_type;

---21. Top 3 vehicle types by average energy consumed
SELECT vehicle_type, AVG(energy_consumed_kWh) AS AvgEnergy,
       RANK() OVER (ORDER BY AVG(energy_consumed_kWh) DESC) AS RankOrder
FROM ev_charging_dataset
GROUP BY vehicle_type;

---22. Optimization reward by station
SELECT station_id, AVG(optimization_reward) AS AvgReward
FROM ev_charging_dataset
GROUP BY station_id
ORDER BY AvgReward DESC;

---23. Average charging power by vehicle type
SELECT vehicle_type, AVG(charging_power_kW) AS AvgPower
FROM ev_charging_dataset
GROUP BY vehicle_type;

---24. Queue length vs charging priority
SELECT charging_priority, AVG(queue_length) AS AvgQueueLength
FROM ev_charging_dataset
GROUP BY charging_priority;

---25. Daily energy consumption trend
SELECT CAST(timestamp AS DATE) AS Day, SUM(energy_consumed_kWh) AS TotalEnergy
FROM ev_charging_dataset
GROUP BY CAST(timestamp AS DATE)
ORDER BY Day;

---26. Station load vs traffic density
SELECT traffic_density, AVG(station_load) AS AvgLoad
FROM ev_charging_dataset
GROUP BY traffic_density;

---27. Daily total energy consumption trend
WITH DailyEnergy AS (
    SELECT CAST(timestamp AS DATE) AS Day, SUM(energy_consumed_kWh) AS TotalEnergy
    FROM ev_charging_dataset
    GROUP BY CAST(timestamp AS DATE)
)
SELECT Day, TotalEnergy,
       RANK() OVER (ORDER BY TotalEnergy DESC) AS RankOrder
FROM DailyEnergy;

---28. Identify top 3 busiest days of week
WITH DaySessions AS (
    SELECT day_of_week, COUNT(*) AS SessionCount
    FROM ev_charging_dataset
    GROUP BY day_of_week
)
SELECT day_of_week, SessionCount,
       DENSE_RANK() OVER (ORDER BY SessionCount DESC) AS DenseRankOrder
FROM DaySessions;


---29. Average renewable ratio per station
WITH RenewableShare AS (
    SELECT station_id, AVG(renewable_energy_ratio) AS AvgRenewable
    FROM ev_charging_dataset
    GROUP BY station_id
)
SELECT station_id, AvgRenewable,
       RANK() OVER (ORDER BY AvgRenewable ASC) AS RankOrder
FROM RenewableShare;



