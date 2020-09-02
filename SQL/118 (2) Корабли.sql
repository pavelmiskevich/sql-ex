--Выборы Директора музея ПФАН проводятся только в високосный год, в первый вторник апреля после первого понедельника апреля.
--Для каждой даты из таблицы Battles определить дату ближайших (после этой даты) выборов Директора музея ПФАН.
--Вывод: сражение, дата сражения, дата выборов. Даты выводить в формате "yyyy-mm-dd".
--    Функция @@DATEFIRST
--    Оператор CASE
--    Подзапросы
--    Генерация числовой последовательности
-- Процесс -------------------------------------------------------------
select @@DATEFIRST
SET DATEFIRST 7;
select DATEFROMPARTS(YEAR('19620305'), MONTH('19620305'), DAY('19620305'))
SELECT @@DATEFIRST;
SET LANGUAGE russian;
select DATEFROMPARTS(YEAR('19620305'), MONTH('19620305'), DAY('19620305'))
SELECT @@DATEFIRST;
select b.[name], b.[date] from Battles b
select b.[name], b.[date], DATENAME(dw, b.[date]) week_day from Battles b

select b.[name], b.[date], YEAR(b.[date]),
case
    when YEAR(b.[date]) % 4 = 0 and YEAR(b.[date]) % 100 != 0 then 1
    when YEAR(b.[date]) % 400 = 0 then 1
    else 0
end 'isVis'
from Battles b

WITH num(n) AS(
SELECT 1 
UNION ALL
SELECT n+1 FROM num 
WHERE n < 3)

WITH T AS (
	select b.[name], b.[date], YEAR(b.[date]) 'year',
	case
		when YEAR(b.[date]) % 4 = 0 and YEAR(b.[date]) % 100 != 0 then 1
		when YEAR(b.[date]) % 400 = 0 then 1
		else 0
	end 'isVis',
	0 'rcount'
	from Battles b
	union all	
	select b.[name], b.[date], YEAR(b.[date]) + b.rcount + 1,
	case
		when (YEAR(b.[date]) + b.rcount + 1) % 4 = 0 and (YEAR(b.[date]) + b.rcount + 1) % 100 != 0 then 1
		when (YEAR(b.[date]) + b.rcount + 1) % 400 = 0 then 1
		else 0
	end 'isVis',
	b.rcount + 1
	from T b
	where b.rcount < 3
)
select T.[name], DATEFROMPARTS(YEAR(T.[date]), MONTH(T.[date]), DAY(T.[date])) 'battle_dt', T.[year],
case
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 1
		then DATEFROMPARTS(T.[year], 4, 2)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 3
		then DATEFROMPARTS(T.[year], 4, 7)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 4
		then DATEFROMPARTS(T.[year], 4, 6)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 5
		then DATEFROMPARTS(T.[year], 4, 5)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 6
		then DATEFROMPARTS(T.[year], 4, 4)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 7
		then DATEFROMPARTS(T.[year], 4, 3)
	else DATEFROMPARTS(T.[year], 4, 8)
end 'election_dt'
from T where T.isVis = 1 order by T.[name]

select DATEPART ( dw, '1964-04-01')
select DATEPART ( dw, '1964-04-07')
select DATEPART ( dw, '1944-04-01')

WITH T AS (
select b.[name], b.[date], YEAR(b.[date]) 'year',
	case
		when YEAR(b.[date]) % 4 = 0 and YEAR(b.[date]) % 100 != 0 then 1
		when YEAR(b.[date]) % 400 = 0 then 1
		else 0
	end 'isVis',
	0 'rcount'
	from Battles b
),
T1 AS (
	select b.[name], b.[date], 
	case when T.isVis = 1 then
		else T.[year]
	end  'year'
	from T
)
select * from T1 /*where T.isVis = 1*/ order by T1.[name]

--SET LANGUAGE russian;
SET DATEFIRST 7;
WITH T AS (
	select b.[name], b.[date], b.[year] 'year',
	case
		when b.[year] % 4 = 0 and b.[year] % 100 != 0 then 1
		when b.[year] % 400 = 0 then 1
		else 0
	end 'isVis',
	0 'rcount'
	from (
		select [name], [date],
		case when MONTH([date]) > 3 then YEAR([date]) + 1
			else YEAR([date])
		end 'year'
		from Battles
	) b
	union all	
	select b.[name], b.[date], YEAR(b.[date]) + b.rcount + 1,
	case
		when (b.[year] + b.rcount + 1) % 4 = 0 and (b.[year] + b.rcount + 1) % 100 != 0 then 1
		when (b.[year] + b.rcount + 1) % 400 = 0 then 1
		else 0
	end 'isVis',
	b.rcount + 1
	from T b
	where b.rcount < 3
)
select * from T /*where T.isVis = 1*/ order by T.[name]
select T.[name], DATEFROMPARTS(YEAR(T.[date]), MONTH(T.[date]), DAY(T.[date])) 'battle_dt',
case
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 1
		then DATEFROMPARTS(T.[year], 4, 3)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 2
		then DATEFROMPARTS(T.[year], 4, 2)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 4
		then DATEFROMPARTS(T.[year], 4, 7)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 5
		then DATEFROMPARTS(T.[year], 4, 6)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 6
		then DATEFROMPARTS(T.[year], 4, 5)
	when DATEPART ( dw, DATEFROMPARTS(T.[year], 4, 1)) = 7
		then DATEFROMPARTS(T.[year], 4, 4)
	else DATEFROMPARTS(T.[year], 4, 8)
end 'election_dt'
from T where T.isVis = 1 order by T.[name]

--список вторых вторников для годов с минимального до максимального 
WITH T AS (
	select YEAR(b.[date]) 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 1
			then DATEFROMPARTS(YEAR(b.[date]), 4, 3)
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 2
			then DATEFROMPARTS(YEAR(b.[date]), 4, 2)
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 4
			then DATEFROMPARTS(YEAR(b.[date]), 4, 7)
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 5
			then DATEFROMPARTS(YEAR(b.[date]), 4, 6)
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 6
			then DATEFROMPARTS(YEAR(b.[date]), 4, 5)
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 7
			then DATEFROMPARTS(YEAR(b.[date]), 4, 4)
		else DATEFROMPARTS(YEAR(b.[date]), 4, 8)
	end 'election_dt',
	case
		when YEAR(b.[date]) % 4 = 0 and YEAR(b.[date]) % 100 != 0 then 1
		when YEAR(b.[date]) % 400 = 0 then 1
		else 0
	end 'isVis',
	0 'rcount',
	(select MAX(YEAR([date])) - MIN(YEAR([date])) from Battles) 'ycount'
	from Battles b where b.[date] = (select MIN([date]) from Battles)
	union all
	select b.[year] + 1 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 1
			then DATEFROMPARTS(b.[year] + 1, 4, 3)
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 2
			then DATEFROMPARTS(b.[year] + 1, 4, 2)
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 4
			then DATEFROMPARTS(b.[year] + 1, 4, 7)
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 5
			then DATEFROMPARTS(b.[year] + 1, 4, 6)
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 6
			then DATEFROMPARTS(b.[year] + 1, 4, 5)
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 7
			then DATEFROMPARTS(b.[year] + 1, 4, 4)
		else DATEFROMPARTS(b.[year] + 1, 4, 8)
	end 'election_dt',
	case
		when (b.[year] + 1) % 4 = 0 and (b.[year] + 1) % 100 != 0 then 1
		when (b.[year]) + 1 % 400 = 0 then 1
		else 0
	end 'isVis',
	b.rcount + 1 'rcount',
	b.ycount
	from T b where b.rcount < b.ycount + 3
)
select * from T
-- не работает на проверочной БД, так как там DATEFIRST 1

SET DATEFIRST 1;
--SET DATEFIRST 7;
select @@DATEFIRST
select 1 + (8 - @@DATEFIRST) % 7

WITH T AS (
	select YEAR(b.[date]) 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 1
			then DATEFROMPARTS(YEAR(b.[date]), 4, 1 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 2
			then DATEFROMPARTS(YEAR(b.[date]), 4, 1 + (8 - @@DATEFIRST) % 7)
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 4
			then DATEFROMPARTS(YEAR(b.[date]), 4, 5 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 5
			then DATEFROMPARTS(YEAR(b.[date]), 4, 4 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 6
			then DATEFROMPARTS(YEAR(b.[date]), 4, 3 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = 7
			then DATEFROMPARTS(YEAR(b.[date]), 4, 2 + (1 + (8 - @@DATEFIRST) % 7))
		else DATEFROMPARTS(YEAR(b.[date]), 4, 6 + (1 + (8 - @@DATEFIRST) % 7))
	end 'election_dt',
	case
		when YEAR(b.[date]) % 4 = 0 and YEAR(b.[date]) % 100 != 0 then 1
		when YEAR(b.[date]) % 400 = 0 then 1
		else 0
	end 'isVis',
	0 'rcount',
	(select MAX(YEAR([date])) - MIN(YEAR([date])) from Battles) 'ycount'
	from Battles b where b.[date] = (select MIN([date]) from Battles)
	union all
	select b.[year] + 1 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 1
			then DATEFROMPARTS(b.[year] + 1, 4, 1 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 2
			then DATEFROMPARTS(b.[year] + 1, 4, 1 + (8 - @@DATEFIRST) % 7)
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 4
			then DATEFROMPARTS(b.[year] + 1, 4, 5 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 5
			then DATEFROMPARTS(b.[year] + 1, 4, 4 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 6
			then DATEFROMPARTS(b.[year] + 1, 4, 3 + (1 + (8 - @@DATEFIRST) % 7))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = 7
			then DATEFROMPARTS(b.[year] + 1, 4, 2 + (1 + (8 - @@DATEFIRST) % 7))
		else DATEFROMPARTS(b.[year] + 1, 4, 6 + (1 + (8 - @@DATEFIRST) % 7))
	end 'election_dt',
	case
		when (b.[year] + 1) % 4 = 0 and (b.[year] + 1) % 100 != 0 then 1
		when (b.[year]) + 1 % 400 = 0 then 1
		else 0
	end 'isVis',
	b.rcount + 1 'rcount',
	b.ycount
	from T b where b.rcount < b.ycount + 3
)
select * from T
select b.[name], 
	DATEFROMPARTS(YEAR(b.[date]), MONTH(b.[date]), DAY(b.[date])) 'battle_dt',
	(select top 1 T.election_dt from T where b.[date] < T.election_dt and T.isVis = 1) 'election_dt'	
from Battles b

SET DATEFIRST 1;
select @@DATEFIRST, 1 + (8-@@DATEFIRST) % 7
SET DATEFIRST 7;
select @@DATEFIRST, 1 + (8-@@DATEFIRST) % 7
select DATENAME(dw, '19000101')
select DATEPART(dw, '19000101')

SET DATEFIRST 1;
SET DATEFIRST 7;
select DATEPART(dw, '19000101')
WITH num(n) AS(
SELECT 0 
UNION ALL
SELECT n+1 FROM num 
WHERE n < 6),
dat AS (
SELECT DATEADD(dd,  n,  CAST('2013-01-01' AS DATETIME)) AS day FROM num
)
select * from dat
SELECT day, DATENAME(dw, day) week_day FROM dat  WHERE DATEPART(dw, day) = 
2+(8-@@DATEFIRST) % 7;

declare  @anchor_date datetime
declare  @reference_date datetime
SELECT @anchor_date='19000101', @reference_date='19440401'
SELECT DATEADD(day, DATEDIFF(day, @anchor_date,
DATEADD(year, DATEDIFF(year, '19000101', @reference_date), '19000101') - 1) /7*7 + 7,
@anchor_date);

SET DATEFIRST 1;
SET DATEFIRST 7;
WITH T AS (
	select YEAR(b.[date]) 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		--else DATEFROMPARTS(YEAR(b.[date]), 4, 8)
	end 'election_dt',
	case
		when YEAR(b.[date]) % 4 = 0 and YEAR(b.[date]) % 100 != 0 then 1
		when YEAR(b.[date]) % 400 = 0 then 1
		else 0
	end 'isVis',
	0 'rcount',
	(select MAX(YEAR([date])) - MIN(YEAR([date])) from Battles) 'ycount'
	from Battles b where b.[date] = (select MIN([date]) from Battles)
	union all
	select b.[year] + 1 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2 + (8 - @@DATEFIRST) % 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		--else DATEFROMPARTS(b.[year] + 1, 4, 6 + (1 + (8 - @@DATEFIRST) % 7))
	end 'election_dt',
	case
		when (b.[year] + 1) % 4 = 0 and (b.[year] + 1) % 100 != 0 then 1
		when (b.[year]) + 1 % 400 = 0 then 1
		else 0
	end 'isVis',
	b.rcount + 1 'rcount',
	b.ycount
	from T b where b.rcount < b.ycount + 3
)
select b.[name], 
	DATEFROMPARTS(YEAR(b.[date]), MONTH(b.[date]), DAY(b.[date])) 'battle_dt',
	(select top 1 T.election_dt from T where b.[date] < T.election_dt and T.isVis = 1) 'election_dt'	
from Battles b

SET DATEFIRST 1;
--SET DATEFIRST 7;
WITH T AS (
	select YEAR(b.[date]) 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(YEAR(b.[date]), 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2, DATEFROMPARTS(YEAR(b.[date]), 4, 1))
		--else DATEFROMPARTS(YEAR(b.[date]), 4, 8)
	end 'election_dt',
	case
		when YEAR(b.[date]) % 4 = 0 and YEAR(b.[date]) % 100 != 0 then 1
		when YEAR(b.[date]) % 400 = 0 then 1
		else 0
	end 'isVis',
	0 'rcount',
	(select MAX(YEAR([date])) - MIN(YEAR([date])) from Battles) 'ycount'
	from Battles b where b.[date] = (select MIN([date]) from Battles)
	union all
	select b.[year] + 1 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3, DATEFROMPARTS(b.[year] + 1, 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year] + 1, 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2, DATEFROMPARTS(b.[year] + 1, 4, 1))
		--else DATEFROMPARTS(b.[year] + 1, 4, 6 + (1 + (8 - @@DATEFIRST) % 7))
	end 'election_dt',
	case
		when (b.[year] + 1) % 4 = 0 and (b.[year] + 1) % 100 != 0 then 1
		when (b.[year]) + 1 % 400 = 0 then 1
		else 0
	end 'isVis',
	b.rcount + 1 'rcount',
	b.ycount
	from T b where b.rcount < b.ycount + 8
)
select * from T
select b.[name], 
	DATEFROMPARTS(YEAR(b.[date]), MONTH(b.[date]), DAY(b.[date])) 'battle_dt',
	(select top 1 T.election_dt from T where b.[date] < T.election_dt and T.isVis = 1) 'election_dt'	
from Battles b
WITH Years AS (
select 
	case 
		when (YEAR(b.[date])) % 4 = 0 and (YEAR(b.[date])) % 100 != 0 then YEAR(b.[date])
		when (YEAR(b.[date])) % 400 = 0 then YEAR(b.[date])
		else 
			case
				when (YEAR(b.[date]) + 1) % 4 = 0 and (YEAR(b.[date]) + 1) % 100 != 0 then YEAR(b.[date]) + 1
				when (YEAR(b.[date]) + 1) % 400 = 0 then YEAR(b.[date]) + 1
				else 
					case
						when (YEAR(b.[date]) + 2) % 4 = 0 and (YEAR(b.[date]) + 2) % 100 != 0 then YEAR(b.[date]) + 2
						when (YEAR(b.[date]) + 2) % 400 = 0 then YEAR(b.[date]) + 2
						else 
							case
								when (YEAR(b.[date]) + 3) % 4 = 0 and (YEAR(b.[date]) + 3) % 100 != 0 then YEAR(b.[date]) + 3
								when (YEAR(b.[date]) + 3) % 400 = 0 then YEAR(b.[date]) + 3
								else YEAR(b.[date]) + 4
							end
					end
			end
	end 'year'
from Battles b
)
, T AS (
	select y.[year] 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2, DATEFROMPARTS(y.[year], 4, 1))
		--else DATEFROMPARTS(y.[year], 4, 8)
	end 'election_dt'
	from Years y
)
--select * from T
, T1 AS (
	select distinct T.[year] from T
	union
	select
	case 
		when DATEDIFF(dd, b.[date], T.[election_dt]) < 0 then 
			case
				when (YEAR(b.[date]) + 1) % 4 = 0 and (YEAR(b.[date]) + 1) % 100 != 0 then YEAR(b.[date]) + 1
				when (YEAR(b.[date]) + 1) % 400 = 0 then YEAR(b.[date]) + 1
				else 
					case
						when (YEAR(b.[date]) + 2) % 4 = 0 and (YEAR(b.[date]) + 2) % 100 != 0 then YEAR(b.[date]) + 2
						when (YEAR(b.[date]) + 2) % 400 = 0 then YEAR(b.[date]) + 2
						else 
							case
								when (YEAR(b.[date]) + 3) % 4 = 0 and (YEAR(b.[date]) + 3) % 100 != 0 then YEAR(b.[date]) + 3
								when (YEAR(b.[date]) + 3) % 400 = 0 then YEAR(b.[date]) + 3
								else YEAR(b.[date]) + 4
							end
					end
			end
		else T.[year]
	end 'year'
	from Battles b 
	join T on YEAR(b.[date]) = T.[year]
)
--select * from T1
, election AS (
select b.[year] 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2, DATEFROMPARTS(b.[year], 4, 1))
		--else DATEFROMPARTS(b.[year], 4, 8)
	end 'election_dt'
	from (select distinct T1.[year] from T1) b
)
--select distinct * from election
select b.[name], 
	DATEFROMPARTS(YEAR(b.[date]), MONTH(b.[date]), DAY(b.[date])) 'battle_dt',
	(select top 1 election.election_dt from election where b.[date] < election.election_dt) 'election_dt'	
from Battles b

-- собираем года, которые
--SET DATEFIRST 1;
SET DATEFIRST 7;
WITH VYears AS (
	select 1980 'year', 1 'isVis'
	union all
	select [year] - 1,
		case
			when ([year] - 1) % 4 = 0 and ([year] - 1) % 100 != 0 then 1
			when ([year] - 1) % 400 = 0 then 1
			else 0
		end
	from VYears
	where [year] - 1 > 1880
)
--select * from VYears
, T AS (
	select y.[year] 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3, DATEFROMPARTS(y.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(y.[year], 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2, DATEFROMPARTS(y.[year], 4, 1))
		--else DATEFROMPARTS(y.[year], 4, 8)
	end 'election_dt'
	from VYears y where y.isVis = 1
)
--select * from T
select b.[name], 
	DATEFROMPARTS(YEAR(b.[date]), MONTH(b.[date]), DAY(b.[date])) 'battle_dt',
	(select MIN(T.election_dt) from T where b.[date] < T.election_dt) 'election_dt'	
from Battles b

, T1 AS (
	select distinct T.[year] from T
	union
	select
	case 
		when DATEDIFF(dd, b.[date], T.[election_dt]) < 0 then 
			case
				when (YEAR(b.[date]) + 1) % 4 = 0 and (YEAR(b.[date]) + 1) % 100 != 0 then YEAR(b.[date]) + 1
				when (YEAR(b.[date]) + 1) % 400 = 0 then YEAR(b.[date]) + 1
				else 
					case
						when (YEAR(b.[date]) + 2) % 4 = 0 and (YEAR(b.[date]) + 2) % 100 != 0 then YEAR(b.[date]) + 2
						when (YEAR(b.[date]) + 2) % 400 = 0 then YEAR(b.[date]) + 2
						else 
							case
								when (YEAR(b.[date]) + 3) % 4 = 0 and (YEAR(b.[date]) + 3) % 100 != 0 then YEAR(b.[date]) + 3
								when (YEAR(b.[date]) + 3) % 400 = 0 then YEAR(b.[date]) + 3
								else YEAR(b.[date]) + 4
							end
					end
			end
		else T.[year]
	end 'year'
	from Battles b 
	join T on YEAR(b.[date]) = T.[year]
)
--select * from T1
, election AS (
select b.[year] 'year',
	case
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000101')
			then DATEADD(dd, 1, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000102')
			then DATEADD(dd, 7, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000103')
			then DATEADD(dd, 6, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000104')
			then DATEADD(dd, 5, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000105')
			then DATEADD(dd, 4, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000106')
			then DATEADD(dd, 3, DATEFROMPARTS(b.[year], 4, 1))
		when DATEPART ( dw, DATEFROMPARTS(b.[year], 4, 1)) = DATEPART(dw, '19000107')
			then DATEADD(dd, 2, DATEFROMPARTS(b.[year], 4, 1))
		--else DATEFROMPARTS(b.[year], 4, 8)
	end 'election_dt'
	from (select distinct T1.[year] from T1) b
)
--select distinct * from election
select b.[name], 
	DATEFROMPARTS(YEAR(b.[date]), MONTH(b.[date]), DAY(b.[date])) 'battle_dt',
	(select top 1 election.election_dt from election where b.[date] < election.election_dt) 'election_dt'	
from Battles b

-----------------
with D(d) as (
	select d FROM
	(
		SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
		UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
		UNION ALL SELECT 8 UNION ALL SELECT 9
	) D
)
, electionY as (
	select distinct YEAR(b.[date]) + D.d  'year' from Battles b, D
	where ((YEAR(b.[date]) + D.d) % 4 = 0 and (YEAR(b.[date]) + D.d) % 100 > 0 ) OR (YEAR(b.[date]) + D.d) % 400 = 0
)
, electionD as (
	select DATEADD(dd, D.d, DATEFROMPARTS(e.[year], 4, 1)) 'election_dt' from electionY e, D
	where D.d > 0 and D.d < 8 and DATEPART(dw, DATEADD(dd, D.d, DATEFROMPARTS(e.[year], 4, 1))) = 2 + (8-@@DATEFIRST) % 7
)
--select * from electionD
--select * from electionY
--select b.[name], DATEFROMPARTS(YEAR(b.[date]), MONTH(b.[date]), DAY(b.[date])) 'battle_dt',
--select b.[name], convert(char(10),b.[date],120) 'battle_dt',
select b.[name], 
	DATENAME(YEAR,b.[date]) + '-' + 
	case
		when MONTH(b.[date]) >= 10 then CAST(MONTH(b.[date]) as char(2))
		else '0' + CAST(MONTH(b.[date]) as char(1))
	end +
	case
		when DAY(b.[date]) >= 10 then '-' + CAST(DAY(b.[date]) as char(2))
		else '-0' + CAST(DAY(b.[date]) as char(1))
	end 'battle_dt',
	DATENAME(YEAR,(select MIN(e.election_dt) from electionD e where e.election_dt >= b.[date])) + '-' + 
	case
		when MONTH((select MIN(e.election_dt) from electionD e where e.election_dt >= b.[date])) >= 10 
		then CAST(MONTH((select MIN(e.election_dt) from electionD e where e.election_dt >= b.[date])) as char(2))
		else '0' + CAST(MONTH((select MIN(e.election_dt) from electionD e where e.election_dt >= b.[date])) as char(1))
	end +
	case
		when DAY((select MIN(e.election_dt) from electionD e where e.election_dt >= b.[date])) >= 10 
		then '-' + CAST(DAY((select MIN(e.election_dt) from electionD e where e.election_dt >= b.[date])) as char(2))
		else '-0' + CAST(DAY((select MIN(e.election_dt) from electionD e where e.election_dt >= b.[date])) as char(1))
	end 'election_dt'
from Battles b
-----------------
-- Решение -------------------------------------------------------------
with D(d) as (
	select d FROM
	(
		SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
		UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
		UNION ALL SELECT 8 UNION ALL SELECT 9
	) D
)
, electionY as (
	select distinct YEAR(b.[date]) + D.d  'year' from Battles b, D
	where ((YEAR(b.[date]) + D.d) % 4 = 0 and (YEAR(b.[date]) + D.d) % 100 > 0 ) OR (YEAR(b.[date]) + D.d) % 400 = 0
)
, electionD as (
	select DATEADD(dd, D.d, DATEFROMPARTS(e.[year], 4, 1)) 'election_dt' from electionY e, D
	where D.d > 0 and D.d <= 8 and DATEPART(dw, DATEADD(dd, D.d, DATEFROMPARTS(e.[year], 4, 1))) = 2 + (8-@@DATEFIRST) % 7
)
select b.[name], convert(char(10),b.[date],120) 'battle_dt',
	convert(char(10),(select MIN(e.election_dt) from electionD e where e.election_dt > b.[date]),120) 'election_dt'
from Battles b 

--cost	0.39867132902145
--operations	14

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=118#20
WITH 
num(n) AS
(SELECT 0 UNION ALL SELECT n+1 FROM num WHERE n < 6)
,
battles_y as
(select name, cast(date as date) date
, case when ((year(date)%4=0 and year(date)%100> 0) or year(date)%400=0) 
  then 
    case 
      when month(date)<4 then 0
      when month(date)=4 and datepart(dd,date)<iif(datepart(dw,date-1)=1,7,datepart(dw,date-1)) then 0 
      else 1 
    end
  else 1
  end as flag
, case when ((year(date)+(4-year(date)%4))%100=0 and (year(date)+(4-year(date)%4))%400> 0) then (8-year(date)%4) else (4-year(date)%4) end as to_y_vis
, year(date) y
from battles)

select name, date, 
DATEADD(dd,n+1,DATEFROMPARTS(y+flag*to_y_vis,4,1)) AS election_dt 
FROM battles_y, num
where datename(dw,DATEADD(dd,n,DATEFROMPARTS(y+flag*to_y_vis,4,1)))='monday'

--cost 0.0041459142230451
--operations 15

with tab as (select name, date,
                    iif(year(e_date) % 4 = 0 and (year(e_date) % 100 <>  0 or year(e_date) % 400 = 0), e_date, dateadd(dd, (((15 - (@@datefirst + datepart(dw, dateadd(mm, 3, dateadd(yy, datediff(yy, 0, e_date) + 4 - (year(e_date) % 4), 0)))) + 1) % 7) + 1), dateadd(mm, 3, dateadd(yy, datediff(yy, 0, e_date) + 4 - (year(e_date) % 4), 0)))) e_date
             from (select name, date,
                          iif((year(e_date) % 4 = 0 and (year(e_date) % 100 <>  0 or year(e_date) % 400 = 0)) and date < e_date, e_date, dateadd(dd, (((15 - (@@datefirst + datepart(dw, dateadd(mm, 3, dateadd(yy, datediff(yy, 0, e_date) + 4 - (year(e_date) % 4), 0)))) + 1) % 7) + 1), dateadd(mm, 3, dateadd(yy, datediff(yy, 0, e_date) + 4 - (year(e_date) % 4), 0)))) e_date
                   from (select name, date,
                                dateadd(dd, (((15 - (@@datefirst + datepart(dw, dateadd(mm, 3, dateadd(yy, datediff(yy, 0, date), 0)))) + 1) % 7) + 1), dateadd(mm, 3, dateadd(yy, datediff(yy, 0, date), 0))) e_date
                         from battles) a) b)

select name,
       replace(convert(varchar, date, 102), '.', '-'),
       replace(convert(varchar, e_date, 102), '.', '-')
from tab

cost 0.0033120000734925
operations 2