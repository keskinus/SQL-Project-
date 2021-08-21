-- 1a. Busiest Airport in US with Most Arrivals & Departures.
select 
row_number() over (order by count(*) desc,ORIGIN_CITY_NAME, ORIGIN_STATE_NM) as Sno,
rank() over (order by count(*) desc,ORIGIN_CITY_NAME, ORIGIN_STATE_NM) as SRank,
dense_rank() over (order by count(*) desc,ORIGIN_CITY_NAME, ORIGIN_STATE_NM) as SDRank,
ORIGIN_CITY_NAME, ORIGIN_STATE_NM, count(*) countofflights 
FROM dbda3.ontime_reporting
group by ORIGIN_CITY_NAME, ORIGIN_STATE_NM
limit 10;


-- 2a.  Busiest Airport in US with Most Delayed + Cancelled + Diverted
select 
row_number() over (order by count(*) desc,ORIGIN_CITY_NAME, ORIGIN_STATE_NM) as Sno,
rank() over (order by count(*) desc, ORIGIN_CITY_NAME, ORIGIN_STATE_NM) as SRank,
dense_rank() over (order by count(*) desc, ORIGIN_CITY_NAME, ORIGIN_STATE_NM) as SDRank,
ORIGIN_CITY_NAME, count(*) countofflights,
count(if(arr_delay>1,1,NULL)) countdelay,
round(count(if(arr_delay>1,1,NULL))*100/count(*),2) delaypct,
sum(arr_delay),
sum(dep_delay),
sum(NAS_DELAY),
sum(WEATHER_DELAY) weather_delay,
sum(LATE_AIRCRAFT_DELAY) aircraft_delay,
sum(cancelled),
sum(diverted)
FROM dbda3.ontime_reporting
group by ORIGIN_CITY_NAME, ORIGIN_STATE_NM
limit 10;

-- 2a Carriers -Most Operated Flight for Carrier
select 
row_number() over (order by count(*) desc,op_unique_carrier) as Sno,
rank() over (order by count(*) desc,op_unique_carrier) as SRank,
dense_rank() over (order by count(*) desc,op_unique_carrier) as DenseRank,
op_unique_carrier, count(*)
FROM dbda3.ontime_reporting
group by op_unique_carrier 
limit 10;

-- 2b Carriers -Most Operated Flight for Carrier Most Delayed + Cancelled + Diverted.   
select row_number() over (order by count(*) desc,op_unique_carrier) as Sno,
       rank() over (order by count(*) desc,op_unique_carrier) as Rno,
       dense_rank() over (order by count(*) desc,op_unique_carrier) as DRno,
       op_unique_carrier, 
     count(*) numflights,
     sum(arr_delay) sumarrdelay, 
     sum(dep_delay) sumdepdelay,
     sum(cancelled),
     sum(diverted),
     sum(count(*)) over () totals -- show totals 
from dbda3.ontime_reporting
group by op_unique_carrier
order by 4 desc
limit 10;


#3.a  First _arriving_flight_of_day for airport

select row_number() over ( order by e.first_arrival desc, e.ORIGIN_CITY_NAME) as Sno,
rank() over (order by e.first_arrival desc,e.ORIGIN_CITY_NAME) as  Rno,
dense_rank() over (order by e.first_arrival desc,e.ORIGIN_CITY_NAME) as DRno,
e.dest_city_name,e.op_unique_carrier,e.op_carrier_fl_num,e.crs_arr_time, e.origin_city_name
from
(	select lag(a.crs_arr_time) over (partition by a.dest_city_name order by a.crs_arr_time) as first_arrival,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.first_arrival is null
order by 1,2,3
limit 10; 

-- 3.b to select only the first_departing_flight_of_day for airport
select row_number() over ( order by e.first_departure desc, e.ORIGIN_CITY_NAME) as Sno,
rank() over (order by e.first_departure desc,e.ORIGIN_CITY_NAME) as  Rno,
dense_rank() over (order by e.first_departure desc,e.ORIGIN_CITY_NAME) as DRno, 
e.origin_city_name origin_city,e.op_unique_carrier op_uni_car,e.op_carrier_fl_num,e.crs_dep_time, e.dest_city_name
from
(	select lag(a.crs_dep_time) over (partition by a.origin_city_name order by a.crs_dep_time) as first_departure,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.first_departure is null
order by e.origin_city_name,e.op_unique_carrier,e.op_carrier_fl_num,e.crs_dep_time, e.dest_city_name
limit 10; 

 -- 3.c to select only the last_arriving_flight_of_day for airport
select 
row_number() over ( order by e.last_arrival desc, e.ORIGIN_CITY_NAME) as Sno,
rank() over (order by e.last_arrival desc,e.ORIGIN_CITY_NAME) as  Rno,
dense_rank() over (order by e.last_arrival desc,e.ORIGIN_CITY_NAME) as DRno, 
 e.dest_city_name,e.op_unique_carrier,e.op_carrier_fl_num,e.crs_arr_time, e.origin_city_name
from
(	select lead(a.crs_arr_time) over (partition by a.dest_city_name order by a.crs_arr_time) as last_arrival,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.last_arrival is null
order by e.dest_city_name,e.op_unique_carrier,e.op_carrier_fl_num,e.crs_dep_time, e.origin_city_name
limit 10; 

-- 3.d.to select only the last_departing_flight_of_day for airport
select 
row_number() over ( order by e.last_departure desc, e.ORIGIN_CITY_NAME) as Sno,
rank() over (order by e.last_departure desc,e.ORIGIN_CITY_NAME) as  Rno,
dense_rank() over (order by e.last_departure desc,e.ORIGIN_CITY_NAME) as DRno, 
e.origin_city_name,e.op_unique_carrier,e.op_carrier_fl_num,e.crs_dep_time, e.dest_city_name
from
(	select lead(a.crs_dep_time) over (partition by a.origin_city_name order by a.crs_dep_time) as last_departure,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.last_departure is null
order by e.origin_city_name,e.op_unique_carrier,e.op_carrier_fl_num,e.crs_dep_time, e.dest_city_name
limit 10;











