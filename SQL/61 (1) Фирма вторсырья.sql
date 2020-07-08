--Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.
--    Получение итоговых значений
--    Подзапросы
-- Процесс -------------------------------------------------------------
select sum(inc) - sum(out) from Income_o, Outcome_o
select sum(inc) from Income_o
select sum(out) from Outcome_o

select (select sum(ISNULL(inc, 0)) from Income_o where date < '2001-04-15') - (select sum(ISNULL(out, 0)) from Outcome_o where date < '2001-04-15')

select sum(summa) from
select sum(ISNULL(inc, 0)) as summa from Income_o
union
select -sum(ISNULL(out, 0)) from Outcome_o
)
-- Решение -------------------------------------------------------------
select sum(t.summa) from (
	select sum(inc) as summa from Income_o
	union
	select -sum(out) as summa from Outcome_o
) t

--cost	0.012228599749506
--operations	10

-- GIT HUB
SELECT sum(SUMA) FROM (
	SELECT sum(inc) as SUMA FROM income_o 

	UNION 

	SELECT -sum(out) as SUMA FROM outcome_o 
) as R

--cost	0.012228599749506
--operations	10