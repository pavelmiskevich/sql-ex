--Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
--Замечание. Не учитывать пункты, информации о которых нет до указанной даты.
--    Явные операции соединения
--    Предложение GROUP BY
--    Оператор CASE
--    Использование значения NULL в условиях поиска
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select i.point, i.sum - (CASE  WHEN o.sum IS NULL THEN 0 
	ELSE o.sum
	END) from
(
	select point, sum(inc) as 'sum' from Income_o where date < '2001-04-15' group by point) i
left join (
	select point, sum(out) as 'sum' from Outcome_o where date < '2001-04-15' group by point
	) o on i.point = o.point

--cost	0.0070812809281051
--operations	7

-- GIT HUB
SELECT point1, sumInc- (
	CASE  WHEN sumOut IS NULL THEN 0 
	ELSE sumOut 
	END
) 
FROM (
	SELECT point point1, sum(inc) sumInc FROM income_o 
	WHERE date<'2001-04-15' 
	GROUP BY point
) as inc LEFT JOIN (
	SELECT point point2, sum(out) sumOut FROM outcome_o 
	WHERE date<'2001-04-15' 
	GROUP BY point
) as out ON point1=point2

--cost	0.0070812809281051
--operations	7