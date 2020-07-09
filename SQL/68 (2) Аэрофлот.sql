--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--Замечания.
--1) A - B и B - A считать ОДНИМ И ТЕМ ЖЕ маршрутом.
--2) Использовать только таблицу Trip
--    Предложение GROUP BY
--    Предложение HAVING
--    Использование ключевых слов ANY, ALL с предикатами сравнения
--    Оператор CASE
-- Процесс -------------------------------------------------------------
--select max(t.c) from (
select town_from, town_to, count(trip_no) c from Trip
group by town_from, town_to
union
select town_to, town_from, count(trip_no) c from Trip
group by town_to, town_from
--) t

select distinct t1.town_from, t2.town_to from Trip t1
cross join (select town_to from Trip) t2

select distinct t1.town_from, t1.town_to, count(t1.trip_no) from Trip t1
where t1.town_from + t1.town_to IN (select town_to + town_from from Trip)
group by t1.town_from, t1.town_to

select t1.town_from, t1.town_to, count(t1.trip_no) c from Trip t1
where t1.town_from > t1.town_to
group by t1.town_from, t1.town_to
union
select t1.town_to, t1.town_from, count(t1.trip_no) c from Trip t1
where t1.town_to > t1.town_from
group by t1.town_from, t1.town_to


select count(1) from (
select t2.town_from, t2.town_to, count(t2.c) c from (
select t1.town_from, t1.town_to, count(t1.trip_no) c from Trip t1
where t1.town_from > t1.town_to
group by t1.town_from, t1.town_to
union
select t1.town_to, t1.town_from, count(t1.trip_no) c from Trip t1
where t1.town_to > t1.town_from
group by t1.town_from, t1.town_to
) t2
group by t2.town_from, t2.town_to
having count(t2.c) >= ALL (
select max(t.c) from (
select t1.town_from, t1.town_to, count(t1.trip_no) c from Trip t1
where t1.town_from > t1.town_to
group by t1.town_from, t1.town_to
union
select t1.town_to, t1.town_from, count(t1.trip_no) c from Trip t1
where t1.town_to > t1.town_from
group by t1.town_from, t1.town_to
) t
)
)o



select count(1) from (

select t1.town_from, t1.town_to, count(t1.trip_no) c from Trip t1
where t1.town_from > t1.town_to
group by t1.town_from, t1.town_to
union
select t1.town_to, t1.town_from, count(t1.trip_no) c from Trip t1
where t1.town_to > t1.town_from
group by t1.town_from, t1.town_to

) t3 where t3.c = (

select max(t2.c) from (
select t1.town_from, t1.town_to, count(t1.trip_no) c from Trip t1
where t1.town_from > t1.town_to
group by t1.town_from, t1.town_to
union
select t1.town_to, t1.town_from, count(t1.trip_no) c from Trip t1
where t1.town_to > t1.town_from
group by t1.town_from, t1.town_to
) t2

)

-- Попробовать COALESCE
--http://www.sql-tutorial.ru/ru/book_explicit_join_operations/page3.html
-- Решение -------------------------------------------------------------
select sum(1) from (
	select top 1 WITH TIES o.town_from from (
		select t.town_from, count(1) c from (
			select
				case when town_from >  town_to then town_from else town_to end town_from,
				case when town_from >  town_to then town_to else town_from end town_to
			from Trip 
		) t
		group by t.town_from, t.town_to
	) o order by o.c desc
) f

--cost	0.027850061655045
--operations	9

-- GIT HUB
SELECT count(*) FROM (
	SELECT TOP 1 WITH TIES sum(counts) sums, first, second FROM (
		SELECT count(*) counts, town_from first, town_to second FROM Trip WHERE town_from > town_to
		GROUP BY town_from, town_to

		UNION ALL

		SELECT count(*) counts, town_to, town_from FROM Trip WHERE town_to > town_from
		GROUP BY town_from, town_to
	) as r GROUP BY first, second ORDER BY sums DESC
) as R

--cost	0.047389391809702
--operations	15

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=68#20
select count(*) 
from
(
 select  count(*) cnt, max(count(*)) over() mx from trip 
 group by 
	case when town_from >  town_to then town_from else town_to end,
	case when town_from >  town_to then town_to else town_from end
) T 
where cnt = mx

--cost	0.017239969223738
--operations	15