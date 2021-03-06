--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--Замечания.
--1) A - B и B - A считать РАЗНЫМИ маршрутами.
--2) Использовать только таблицу Trip
--    Предложение GROUP BY
--    Предложение HAVING
--    Использование ключевых слов ANY, ALL с предикатами сравнения
-- Процесс -------------------------------------------------------------
--select max(t.c) from (
select town_from, town_to, count(trip_no) c from Trip
group by town_from, town_to
union
select town_to, town_from, count(trip_no) c from Trip
group by town_to, town_from
--) t

select town_from, town_to, count(trip_no) c from Trip
group by town_from, town_to

select distinct count(trip_no) c from Trip
group by town_from, town_to
having count(trip_no) >= ALL (
select distinct max(t.c) from (
select town_from, town_to, count(trip_no) c from Trip
group by town_from, town_to
) t
)

select max(t.c) from ( 
select ID_comp, plane, town_from, town_to, count(trip_no) c from Trip
group by ID_comp, plane, town_from, town_to
) t

select max(t.c) from ( 
select plane, town_from, town_to, count(trip_no) c from Trip
group by plane, town_from, town_to
) t

select max(t.c) from ( 
select ID_comp, town_from, town_to, count(trip_no) c from Trip
group by ID_comp, town_from, town_to
) t

select max(t.c) from ( 
select plane, town_from, town_to, count(trip_no) c from Trip
group by plane, town_from, town_to
) t

select max(t.c) from ( 
select ID_comp, town_from, town_to, count(trip_no) c from Trip
group by ID_comp, town_from, town_to
) t


select ID_comp, plane, town_from, town_to, time_out, time_in, count(trip_no) c from Trip
group by ID_comp, plane, town_from, town_to, time_out, time_in

select max(t.c) from ( 
select ID_comp, plane, town_from, town_to, count(time_out) c from Trip
group by ID_comp, plane, town_from, town_to
) t

SELECT TOP 1 WITH TIES count(*) count, town_from, town_to FROM trip
	GROUP BY town_from, town_to 
	ORDER BY count DESC

SELECT count(*) FROM (
	SELECT TOP 1 WITH TIES count(*) count, town_from, town_to FROM trip
	GROUP BY town_from, town_to 
	ORDER BY count DESC
) as R
-- Решение -------------------------------------------------------------
select count(1) from (
	select town_from, town_to, count(trip_no) c from Trip
	group by town_from, town_to
	having count(trip_no) >= ALL (
		select max(t.c) from (
			select town_from, town_to, count(trip_no) c from Trip
			group by town_from, town_to
		) t
	)
)o

--cost	0.031705226749182
--operations	12

-- GIT HUB
SELECT count(*) FROM (
	SELECT TOP 1 WITH TIES count(*) count, town_from, town_to FROM trip
	GROUP BY town_from, town_to 
	ORDER BY count DESC
) as R

--cost	0.027809374034405
--operations	8

--FORUM
https://www.sql-ex.ru/forum/Lforum.php?F=3&N=67#20