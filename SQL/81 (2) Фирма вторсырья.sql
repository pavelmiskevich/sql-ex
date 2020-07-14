--Из таблицы Outcome получить все записи за тот месяц (месяцы), с учетом года, в котором суммарное значение расхода (out) было максимальным.
--    Функция CONVERT
--    Получение итоговых значений
--    Предложение HAVING
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
SELECT ou.code, ou.point, ou.date, ou.out FROM Outcome ou
join (
SELECT TOP 1 WITH TIES t.month, t.year FROM (
select MONTH(o.date) month, YEAR(o.date) year, SUM(o.out) sum from Outcome o
group by MONTH(o.date), YEAR(o.date)
) t
order by t.sum DESC
) f on f.month = MONTH(ou.date) AND f.year = YEAR(ou.date)

--cost	0.047639921307564
--operations	9

-- GIT HUB
SELECT Outcome.* FROM Outcome
INNER JOIN (
	SELECT TOP 1 WITH TIES YEAR(date) AS Year, MONTH(date) AS Month, SUM(out) AS ALL_TOTAL
	FROM Outcome
	GROUP BY YEAR(date), MONTH(date)
	ORDER BY ALL_TOTAL DESC
) R ON YEAR(Outcome.date) = R.Year AND MONTH(Outcome.date) = R.Month

--cost	0.047639921307564
--operations	9

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=81#20
WITH outcome_sums AS (
SELECT
 DATEADD(day, 1 - DAY(o.date), o.date) AS dt,
 SUM(o.out) AS sum,
 MAX(SUM(o.out)) OVER () AS max_sum
FROM Outcome AS o
GROUP BY DATEADD(day, 1 - DAY(o.date), o.date)
)

SELECT o.*
FROM outcome_sums AS os
INNER JOIN Outcome AS o 
 ON o.date BETWEEN os.dt AND DATEADD(day, -1, DATEADD(month, 1, os.dt))
WHERE os.sum = os.max_sum

--cost 0.018832409754395
--operations 14