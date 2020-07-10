--Для каждого сражения определить первый и последний день
--месяца,
--в котором оно состоялось.
--Вывод: сражение, первый день месяца, последний
--день месяца.
--Замечание: даты представить без времени в формате "yyyy-mm-dd".
--    Функция CONVERT
--    Функции T-SQL для работы c датами
-- Процесс -------------------------------------------------------------
select [name], CONVERT(nvarchar(10), [date], 103), DATEPART(day, [date]) from Battles

SELECT [name], 
	DATEFROMPARTS(YEAR([date]), MONTH([date]), 1) firstD,
	DATEFROMPARTS(YEAR([date]), (MONTH([date]) + 1), 1) lastD from Battles
-- Решение -------------------------------------------------------------
SELECT [name], 
	DATEFROMPARTS(YEAR([date]), MONTH([date]), 1) firstD,
	DATEADD(day, -1, DATEADD(month, 1, DATEFROMPARTS(YEAR([date]), MONTH([date]), 1))) lastD 
from Battles

--cost	0.0033120000734925
--operations	2

-- GIT HUB
SELECT name, REPLACE(CONVERT(CHAR(12), DATEADD(m, DATEDIFF(m,0,date),0), 102),'.','-') AS first_day,
             REPLACE(CONVERT(CHAR(12), DATEADD(s,-1,DATEADD(m, DATEDIFF(m, 0, date) + 1,0)), 102), '.', '-') AS last_day
FROM Battles

--cost	0.0033120000734925
--operations	2

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=78#20
WITH A AS (SELECT b.name
                              ,CONVERT(char(25), DATEADD(mm, 0, b.date), 23) date
                              ,CONVERT(char(25), DATEADD(dd, -DATEPART(d, b.date)+1, b.date), 23) firstD
                   FROM Battles b)

SELECT A.name
           ,A.firstD
           ,CONVERT(char(25), DATEADD(dd, -DATEPART(d, (SELECT CONVERT(char(25), DATEADD(mm, 1, A.firstD), 23) date1)), (SELECT CONVERT(char(25), DATEADD(mm, 1, A.firstD), 23) date1)), 23) lastD
FROM A

--cost 0.0033120000734925
--operations 2