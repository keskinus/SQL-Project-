-- Busiest Airport in US with Most Arrivals & Departures.

SELECT ORIGIN_CITY_NAME, ORIGIN_STATE_NM, count(*) countofflights 
FROM dbda3.ontime_reporting
group by 1,2
order by 3 desc
limit 10;

 -- Busiest Airport in US with Most Delayed + Cancelled + Diverted 
 select ORIGIN_CITY_NAME CITY, ORIGIN_STATE_ABR STATE,count(*) countofflights,
 sum(arr_delay) Arr_delay,        
 sum(dep_delay) Dep_delay,        
 sum(cancelled) Cancelled,
 sum(diverted) Diverted 
 from dbda3.ontime_reporting
 group by ORIGIN_CITY_NAME, ORIGIN_STATE_ABR
 order by 3 desc, 1
 limit 10;
 
-- Carriers  with Most Operated Flight for Carrier  
select op_unique_carrier, count(*) countofflights
 FROM dbda3.ontime_reporting
 group by op_unique_carrier 
 order by 2 desc
 limit 10;
 
 -- Carriers with Most Delayed + Cancelled + Diverted 
 select op_unique_carrier, count(*) countofflights,
	sum(arr_delay),
  sum(dep_delay),
  sum(cancelled),
  sum(diverted)
 FROM dbda3.ontime_reporting
 group by op_unique_carrier 
 order by 2 desc
 limit 10;
 -- Flights Most Between Cities
 SELECT ORIGIN_CITY_NAME, 
 DEST_CITY_NAME,
 count(*) countofflights
 from dbda3.ontime_reporting
 group by ORIGIN_CITY_NAME, DEST_CITY_NAME
 order by 3 desc,1
 limit 10;
 
 
 -- Longest Flights Most Between Cities
 
 select OP_UNIQUE_CARRIER,ORIGIN_CITY_NAME, dest_CITY_NAME, round(avg(distance),2) "Longest Flights",
 count(*) countofflights
 from dbda3.ontime_reporting
 group by OP_UNIQUE_CARRIER,ORIGIN_CITY_NAME, dest_CITY_NAME
 order by 4 desc,1
 limit 10;
 
 -- Shortest Flights Most Between Cities.
 select OP_UNIQUE_CARRIER,ORIGIN_CITY_NAME, dest_CITY_NAME, round(avg(distance),2) "Shortest Flights",
 count(*) countofflights
 from dbda3.ontime_reporting
 group by OP_UNIQUE_CARRIER,ORIGIN_CITY_NAME, dest_CITY_NAME
 order by 4 asc,1
 limit 10;
 
 -- Day of Week Most Operated
 
 select
  case day_of_week
     when 1 then "Monday"
     when 2 then "Tuesday"
     when 3 then "Wednesday"
     when 4 then "Thursday"
     when 5 then "Friday"
     when 6 then "Saturday"
     when 7 then "Sunday"
     when 9 then "Unknown"
   END as DayOfWeek,
       count(*) numflights
from dbda3.ontime_reporting
group by DAY_OF_WEEK
order by 2 desc;

select 
  case day_of_week
     when 1 then "Monday"
     when 2 then "Tuesday"
     when 3 then "Wednesday"
     when 4 then "Thursday"
     when 5 then "Friday"
     when 6 then "Saturday"
     when 7 then "Sunday"
     when 9 then "Unknown"
   END as DayOfWeek,
     count(*) numflights,
     sum(arr_delay) sumarrdelay, 
     sum(dep_delay) sumdepdelay, 
     sum(cancelled) sumCancelled,
     sum(diverted)	sumDiverted
from dbda3.ontime_reporting
group by DAY_OF_WEEK
order by day_of_week;

