--Определить дни, когда было выполнено максимальное число рейсов из
--Ростова ('Rostov'). Вывод: число рейсов, дата.
--    Явные операции соединения
--    Получение итоговых значений
-- Процесс -------------------------------------------------------------
select count(t.trip_no) Qty, t.date from (
SELECT DISTINCT pit.date, pit.trip_no FROM Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no AND town_from = 'Rostov'
--group by pit.date
) t
group by t.date

SELECT TOP 1 WITH TIES f.Qty, f.date FROM (
select count(t.trip_no) Qty, t.date from (
SELECT DISTINCT pit.date, pit.trip_no FROM Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no AND town_from = 'Rostov'
--group by pit.date
) t
group by t.date
) f
order by f.Qty DESC
-- Решение -------------------------------------------------------------
SELECT TOP 1 WITH TIES f.Qty, f.date FROM (
	select count(t.trip_no) Qty, t.date from (
		SELECT DISTINCT pit.date, pit.trip_no FROM Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no AND town_from = 'Rostov'
		--group by pit.date
		) t
	group by t.date
) f
order by f.Qty DESC

--cost	0.032114550471306
--operations	9

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=77#20
SELECT c, date
FROM
(SELECT count( distinct trip.trip_no) as c, max(count( distinct trip.trip_no)) over() as m, date
FROM trip join pass_in_trip on pass_in_trip.trip_no = trip.trip_no
WHERE town_from LIKE 'Rostov'
GROUP BY date) as p
WHERE p.m=p.c

--cost 0.01827809214592
--operations 14