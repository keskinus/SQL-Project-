#HW10
#1.Busiest City in US  Most Arrivals + Departures
select
row_number()
over (order by count(ORIGIN_CITY_NAME) desc) as Row_numbers,
rank() over (order by count(DEST) desc) as RankNumbersDeparturesArrivials,
dense_rank() over (order by count(DEST) desc) as DenseRankDeparturesArrivials,
ORIGIN_CITY_NAME,count(*) as TotalDeparture
from dbda3.ontime_reporting
group by ORIGIN_CITY_NAME
limit 10;

#1b. Most Delayed + Cancelled + Diverted
select origin_city_name,sum(DEP_DELAY),sum( ARR_DELAY),sum(CANCELLED),
row_number()
over (order by sum(DEP_DELAY) desc,ORIGIN_CITY_NAME) as Most_Depature_Delay,
rank() over (order by sum( ARR_DELAY) desc,ORIGIN_CITY_NAME) as Most_ArrivialsDelay,
dense_rank() over (order by sum(CANCELLED)desc,ORIGIN_CITY_NAME) as Most_Cancelled,
dense_rank() over (order by sum(DIVERTED)desc,ORIGIN_CITY_NAME) as Most_Diverted,
dense_rank() over (order by sum(WEATHER_DELAY)desc,ORIGIN_CITY_NAME) as Most_WheatherDelay,
dense_rank() over (order by sum(NAS_DELAY)desc,ORIGIN_CITY_NAME) as Most_NasDelay,
dense_rank() over (order by sum(LATE_AIRCRAFT_DELAY)desc,ORIGIN_CITY_NAME) as Most_LATE_AIRCRAFT_DELAY
from dbda3.ontime_reporting
group by origin_city_name
order by 2
limit 10;

 #2a Carriers -Most Operated Flight for Carrier

select
row_number()
over (order by count(*) desc,OP_CARRIER_FL_NUM) as RowNumbers,
rank()
over (order by count(OP_UNIQUE_CARRIER) desc,OP_CARRIER_FL_NUM) as MostOperatedForCarriers,
OP_CARRIER_FL_NUM,OP_UNIQUE_CARRIER, count(*) totalFlights
 from dbda3.ontime_reporting
group by OP_UNIQUE_CARRIER,OP_CARRIER_FL_NUM
limit 10;

#2b) Most Delayed + Cancelled + Diverted
select OP_UNIQUE_CARRIER,
row_number()
over (order by sum(DEP_DELAY) desc,OP_UNIQUE_CARRIER) as MostDelaByCarriers,
rank() over (order by sum( ARR_DELAY) desc,OP_UNIQUE_CARRIER) as MostArrivialsDelayByCarriers,
dense_rank() over (order by sum(CANCELLED)desc,OP_UNIQUE_CARRIER) as MostCancelledByCarriers,
dense_rank() over (order by sum(DIVERTED)desc,OP_UNIQUE_CARRIER) as MostDivertedByCarriers
from dbda3.ontime_reporting
group by OP_UNIQUE_CARRIER
order by 2
limit 10;

#3.a  First arrival of the day  for an airport
select
row_number() over ( order by e.first_arrival desc, e.ORIGIN_CITY_NAME) as RowNumber,
rank() over (order by e.first_arrival desc,e.ORIGIN_CITY_NAME) as  FirstArrivalRank,
dense_rank() over (order by e.first_arrival desc,e.ORIGIN_CITY_NAME) as  FirstArrivalDenseRank,
e.ORIGIN_CITY_NAME,e.dest_city_name,e.crs_arr_time,e.op_carrier_fl_num
from
(select lag(a.crs_arr_time) over (partition by a.dest_city_name order by a.crs_arr_time) as first_arrival,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.first_arrival is null
order by 1,2,3
limit 10;

 #3b.First departure of the day  for an airport
select
row_number() over ( order by e.first_departure desc, e.ORIGIN_CITY_NAME) as RowNumber,
rank() over (order by e.first_departure desc,e.ORIGIN_CITY_NAME) as  FirstDepartureRank,
dense_rank() over (order by e.first_departure desc,e.ORIGIN_CITY_NAME) as  FirstDepartureDenseRank,
e.ORIGIN_CITY_NAME,e.dest_city_name,e.crs_dep_time,e.op_carrier_fl_num
from
(	select lag(a.crs_dep_time) over (partition by a.origin_city_name order by a.crs_dep_time) as first_departure,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.first_departure is null
order by 1,2,3
limit 10;

#3c. Last Arrivial of the day for an airport
select
row_number() over ( order by e.last_arrival desc, e.ORIGIN_CITY_NAME) as RowNumber,
rank() over (order by e.last_arrival desc,e.ORIGIN_CITY_NAME) as  LastArrivalRank,
dense_rank() over (order by e.last_arrival desc,e.ORIGIN_CITY_NAME) as  LastArrivalDenseRank,
e.ORIGIN_CITY_NAME,e.dest_city_name,e.crs_arr_time,e.op_carrier_fl_num
from
(select lead(a.crs_arr_time) over (partition by a.dest_city_name order by a.crs_arr_time) as last_arrival,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.last_arrival is null
order by 1,2,3
limit 10;

#3.d  Last Departure of the day for an airport
select
row_number() over ( order by e.last_departure desc, e.ORIGIN_CITY_NAME) as RowNumber,
rank() over (order by e.last_departure desc,e.ORIGIN_CITY_NAME) as  LastDepartureRank,
dense_rank() over (order by e.last_departure desc,e.ORIGIN_CITY_NAME) as  LastDepartureDenseRank,
e.ORIGIN_CITY_NAME,e.dest_city_name,e.crs_dep_time,e.op_carrier_fl_num
from
(	select lead(a.crs_dep_time) over (partition by a.origin_city_name order by a.crs_dep_time) as last_departure,
	   a.*
from  dbda3.ontime_reporting a
) e
where e.last_departure is null
order by 1,2,3
limit 10;
