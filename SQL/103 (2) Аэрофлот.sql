--Выбрать три наименьших и три наибольших номера рейса. Вывести их в шести столбцах одной строки, расположив в порядке от наименьшего к наибольшему.
--Замечание: считать, что таблица Trip содержит не менее шести строк.
--    Получение итоговых значений
--    Предикат IN
-- Процесс -------------------------------------------------------------
select top 3 trip_no from Trip order by trip_no
select top 3 trip_no from Trip order by trip_no desc
-- Решение -------------------------------------------------------------
select 
(select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no) t) 'min1',
(
	select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no) t
	where t.trip_no NOT IN (
		select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no) t
	)
) 'min2',
(select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no) t order by t.trip_no desc) 'min3',
(select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no desc) t order by t.trip_no) 'max3',
(
	select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no desc) t
	where t.trip_no NOT IN (
		select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no desc) t
	)
) 'max2',
(select top 1 t.trip_no from (select top 3 trip_no from Trip order by trip_no desc) t) 'max1'

--cost	0.049208357930183
--operations	39

WITH T AS (
	select top 3 trip_no from Trip order by trip_no
	union
	select top 3 trip_no from Trip order by trip_no desc
),
T1 AS (
	select trip_no, row_number() over(ORDER BY trip_no) num from T
)
--select * from T1
select 
(select trip_no from T1 where num = 1) 'min1',
(select trip_no from T1 where num = 2) 'min2',
(select trip_no from T1 where num = 3) 'min3',
(select trip_no from T1 where num = 4) 'max3',
(select trip_no from T1 where num = 5) 'max2',
(select trip_no from T1 where num = 6) 'max1'

--cost	0.10782190412283
--operations	80

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=103
SELECT SUM(CASE WHEN num = 1 THEN Trip_no ELSE 0 END),
       SUM(CASE WHEN num = 2 THEN Trip_no ELSE 0 END),
       SUM(CASE WHEN num = 3 THEN Trip_no ELSE 0 END),
       SUM(CASE WHEN num = 6 THEN Trip_no ELSE 0 END),
       SUM(CASE WHEN num = 5 THEN Trip_no ELSE 0 END),
       SUM(CASE WHEN num = 4 THEN Trip_no ELSE 0 END)

FROM (SELECT TOP 3 ROW_NUMBER() OVER(ORDER BY Trip_no ASC) num, Trip_no
      FROM Trip
      UNION ALL
      SELECT TOP 3 ROW_NUMBER() OVER(ORDER BY Trip_no DESC)+3 num, Trip_no
      FROM Trip) AS R

--cost	0.006576799787581
--operations	12

SELECT min(T.Trip_no), min(T2.Trip_no), min(T3.Trip_no),
       max(T.Trip_no), max(T2.Trip_no), max(T3.Trip_no)
FROM Trip T JOIN Trip T2 ON  T.Trip_no  < T2.Trip_no
            JOIN Trip T3 ON T2.Trip_no < T3.Trip_no

--cost	1.4118266105652
--operations	6
