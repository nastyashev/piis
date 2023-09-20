-- 2 Розрахувати сумарну затримку по містах
select city, sum(airports_delay_group.delay_sum) from
(select airports_delay.airport as airport, sum(airports_delay.delay) as delay_sum from
(select origin as airport, dep_delay as delay from flights
union all
select dest as airport, arr_delay as delay from flights) as airports_delay
group by airport) as airports_delay_group
join airports on iata_code = airports_delay_group.airport
group by city
order by city;

-- 3 Порахувати кількість польотів по містах
select city, sum(airports_count_group.delay_sum) from
(select airports_all.airport as airport, count(airports_all.airport) as delay_sum from
(select origin as airport from flights
union all
select dest as airport from flights) as airports_all
group by airport) as airports_count_group
join airports on iata_code = airports_count_group.airport
group by city
order by city;

-- 4 Знайти місто з найменшою і найбільшою затримкою
select city, sum from
(select city, sum(airports_delay_group.delay_sum) as sum from
(select airports_delay.airport as airport, sum(airports_delay.delay) as delay_sum from
(select origin as airport, dep_delay as delay from flights
union all
select dest as airport, arr_delay as delay from flights) as airports_delay
group by airport) as airports_delay_group
join airports on iata_code = airports_delay_group.airport
group by city) as cities
order by sum
limit 1;

select city, sum from
(select city, sum(airports_delay_group.delay_sum) as sum from
(select airports_delay.airport as airport, sum(airports_delay.delay) as delay_sum from
(select origin as airport, dep_delay as delay from flights
union all
select dest as airport, arr_delay as delay from flights) as airports_delay
group by airport) as airports_delay_group
join airports on iata_code = airports_delay_group.airport
group by city) as cities
order by sum desc
limit 1;

-- 5 Знайти всі польоти з затримкою більше за середній час затримки
select * from flights
where (arr_delay + dep_delay) >
(select avg(arr_delay + dep_delay) from flights);

-- 6 Заміряти вбудованими методами об'єм БД та швидкість виконання запитів
select table_schema, round(sum(data_length + index_length) / power(2, 20), 2) AS total_mb
from information_schema.tables
where table_schema = 'innodb_bts';

call columnstore_info.table_usage('columnstore_bts', 'flights');