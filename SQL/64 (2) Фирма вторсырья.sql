--Используя таблицы Income и Outcome, для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот.
--Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день.
--    Явные операции соединения
--    Использование значения NULL в условиях поиска
--    Оператор CASE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select u.point, u.date, u.operation, sum(u.sum) from (
select inc.point, inc.date, 'inc' as 'operation', inc.inc as 'sum' from Income inc
left join Outcome out on inc.point = out.point and inc.date = out.date
where out.out IS NULL
union all
select out.point, out.date, 'out' as 'operation', out.out as 'sum' from Outcome out
left join Income inc on out.point = inc.point and out.date = inc.date
where inc.inc IS NULL
) u
group by u.point, u.date, u.operation

--cost	0.033584874123335
--operations	13

-- GIT HUB
SELECT R.point, R.date, 'inc', sum(inc) FROM Income, (
	SELECT point, date FROM Income 
	EXCEPT 
	SELECT Income.point, Income.date FROM Income 
	iNNER JOIN Outcome ON (Income.point=Outcome.point) AND (Income.date=Outcome.date) 
) AS R WHERE R.point=Income.point AND R.date=Income.date 
GROUP BY R.point, R.date 

UNION 

SELECT R1.point, R1.date, 'out', sum(out) FROM Outcome, (
	SELECT point, date FROM Outcome 
	EXCEPT 
	SELECT Income.point, Income.date FROM Income 
	INNER JOIN Outcome ON (Income.point=Outcome.point) AND (Income.date=Outcome.date) 
) AS R1 
WHERE R1.point=Outcome.point AND R1.date=Outcome.date 
GROUP BY R1.point, R1.date

--cost	0.061342101544142
--operations	21