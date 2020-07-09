--Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov.
--Вывод: дата, количество рейсов
--    Оператор CASE
--    Предложение GROUP BY
--    Явные операции соединения
--    Генерация числовой последовательности
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select d.[data], count(t.trip_no) from 
(select '2003-04-01 00:00:00.000' as [data]
union all
select '2003-04-02 00:00:00.000' as [data]
union all
select '2003-04-03 00:00:00.000' as [data]
union all
select '2003-04-04 00:00:00.000' as [data]
union all
select '2003-04-05 00:00:00.000' as [data]
union all
select '2003-04-06 00:00:00.000' as [data]
union all
select '2003-04-07 00:00:00.000' as [data]
) d
left join (select distinct pit.[date] as [data], pit.trip_no, tr.town_from from Pass_in_trip pit
join Trip tr on tr.trip_no = pit.trip_no
where tr.town_from = 'Rostov' and pit.[date] >= '2003-04-01 00:00:00.000' and pit.[date]  <= '2003-04-07 00:00:00.000') t on d.[data] = t.[data]
group by d.[data]

--cost	0.017363833263516
--operations	9

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=66#20
WITH dates (Date) AS 
(
    SELECT cast('20030401' as datetime) as Date
    UNION ALL
    SELECT DATEADD(d,1,[Date])
    FROM dates 
    WHERE DATE < '20030407'
),
trp (date, trip_no) as
(select date, trip_no from Pass_in_trip where trip_no  in 
(select distinct trip_no from Trip where town_from='Rostov') group by date, trip_no)
SELECT Date, isnull((select count (*) from trp where trp.date=d.Date),0) as Qty
FROM dates as d 

--cost 0.0096911350265145
--operations 19

SELECT t1.date, ISNULL(Qty, 0) AS Qty
FROM (SELECT CONVERT(DATETIME, CONCAT("day", '/04/2003'), 103) AS "date"
			FROM (SELECT 3*(a-1)+b AS "day"
						FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x
									CROSS JOIN
									(SELECT 1 b UNION ALL SELECT 2 UNION ALL SELECT 3) y
						WHERE 3*(a-1)+b < 8) t
			) AS t1
LEFT JOIN (
SELECT date, COUNT(DISTINCT trip.trip_no) AS Qty FROM Pass_in_trip
LEFT JOIN Trip ON Trip.trip_no = Pass_in_trip.trip_no
WHERE date BETWEEN CONVERT(DATE, '01/04/2003', 103) AND CONVERT(DATE, '07/04/2003', 103)
	AND town_from = 'Rostov'
GROUP BY date) AS t2
ON t1.date = t2.date

--cost 0.010963317006826
--operations 13