--Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
--    Явные операции соединения
--    Предложение GROUP BY
--    Оператор CASE
--    Использование значения NULL в условиях поиска
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select i.point, i.sum - (CASE  WHEN o.sum IS NULL THEN 0 
	ELSE o.sum
	END) from
(select point, sum(inc) as 'sum' from Income_o group by point) i
left join (
	select point, sum(out) as 'sum' from Outcome_o group by point
	) o on i.point = o.point

--cost	0.0072864750400186
--operations	7

-- GIT HUB
SELECT c1, c2 - (
	CASE WHEN o2 IS NULL THEN 0 
	ELSE o2 
	END
) 
FROM (
	SELECT point c1, sum(inc) c2 FROM income_o 
	GROUP BY point
) as t1 LEFT JOIN (
	SELECT point o1, sum(out) o2 FROM outcome_o 
	GROUP BY point
) as t2 ON c1=o1

--cost	0.0072864750400186
--operations	7