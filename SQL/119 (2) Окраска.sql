--Сгруппировать все окраски по дням, месяцам и годам. Идентификатор каждой группы должен иметь вид "yyyy" для года, "yyyy-mm" для месяца и "yyyy-mm-dd" для дня.
--Вывести только те группы, в которых количество различных моментов времени (b_datetime), когда выполнялась окраска, более 10.
--Вывод: идентификатор группы, суммарное количество потраченной краски.
--    Конкатенация строк символов
--    Преобразoвание типов
--    Функция DATEPART
--    Предложение GROUP BY
-- Процесс -------------------------------------------------------------
select Q_ID, Q_NAME from utQ --квадраты
select V_ID, V_NAME, V_COLOR from utV --балончики
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB

select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB

select B_DATETIME, DATEPART(YYYY, B_DATETIME) 'year', DATEPART(MM, B_DATETIME) 'month', DATEPART(DD, B_DATETIME) 'day',  B_VOL from utB
select count(B_DATETIME), DATEPART(YYYY, B_DATETIME) 'year', DATEPART(MM, B_DATETIME) 'month', DATEPART(DD, B_DATETIME) 'day',  sum(B_VOL) from utB
group by B_DATETIME

WITH T AS (
	select distinct B_DATETIME,
		DATEPART(YEAR, B_DATETIME) 'year',
		DATEPART(MONTH, B_DATETIME) 'month',
		DATEPART(DAY, B_DATETIME) 'day',
		B_VOL from utB
)
--select * from T
select CAST(CAST(CONCAT(T.[year], '-', T.[month], '-', T.[day]) as date) as varchar(10)) 'period',
	SUM(T.B_VOL) 'vol' from T
group by T.[year], T.[month], T.[day]
having count(distinct T.B_DATETIME) > 10
union
select CAST(CAST(CONCAT(T.[year], '-', T.[month], '-01') as date) as varchar(7)), SUM(T.B_VOL) from T
group by T.[year], T.[month]
having count(distinct T.B_DATETIME) > 10
union
select CAST(T.[year] as varchar), SUM(T.B_VOL) from T
group by T.[year]
having count(distinct T.B_DATETIME) > 10
-- Решение -------------------------------------------------------------
select CAST(CAST(CONCAT(DATEPART(YEAR, B_DATETIME), '-', DATEPART(MONTH, B_DATETIME), '-', DATEPART(DAY, B_DATETIME)) as date) as varchar(10)) 'period',
	SUM(B_VOL) 'vol' from utB
group by CAST(CAST(CONCAT(DATEPART(YEAR, B_DATETIME), '-', DATEPART(MONTH, B_DATETIME), '-', DATEPART(DAY, B_DATETIME)) as date) as varchar(10))
having count(distinct B_DATETIME) > 10
union
select CAST(CAST(CONCAT(DATEPART(YEAR, B_DATETIME), '-', DATEPART(MONTH, B_DATETIME), '-01') as date) as varchar(7)),
	SUM(B_VOL) from utB
group by DATEPART(YEAR, B_DATETIME), DATEPART(MONTH, B_DATETIME)
having count(distinct B_DATETIME) > 10
union
select CAST(DATEPART(YEAR, B_DATETIME) as varchar), SUM(B_VOL) from utB
group by DATEPART(YEAR, B_DATETIME)
having count(distinct B_DATETIME) > 10

--cost	0.067744381725788
--operations	25

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=119#20
SELECT FORMAT(b_datetime, 'yyyy-MM-dd') period, SUM(b_vol) vol
FROM utb
GROUP BY FORMAT(b_datetime, 'yyyy-MM-dd')
HAVING COUNT(DISTINCT b_datetime) >  10
UNION ALL
SELECT FORMAT(b_datetime, 'yyyy-MM'), SUM(b_vol) 
FROM utb
GROUP BY FORMAT(b_datetime, 'yyyy-MM')
HAVING COUNT(DISTINCT b_datetime) >  10
UNION ALL
SELECT FORMAT(b_datetime, 'yyyy'), SUM(b_vol) 
FROM utb
GROUP BY FORMAT(b_datetime, 'yyyy')
HAVING COUNT(DISTINCT b_datetime) >  10

--cost 0.0567044056952
--operations 22