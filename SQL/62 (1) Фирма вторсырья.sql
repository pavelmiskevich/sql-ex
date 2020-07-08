--Посчитать остаток денежных средств на всех пунктах приема на начало дня 15/04/01 для базы данных с отчетностью не чаще одного раза в день.
--    Получение итоговых значений
--    Подзапросы
-- Процесс -------------------------------------------------------------
select sum(inc) - sum(out) from Income_o, Outcome_o
select sum(inc) from Income_o
select sum(out) from Outcome_o

select (select sum(ISNULL(inc, 0)) from Income_o where date < '2001-04-15') - (select sum(ISNULL(out, 0)) from Outcome_o where date < '2001-04-15')
-- Решение -------------------------------------------------------------
select (select sum(ISNULL(inc, 0)) from Income_o where date < '2001-04-15') - (select sum(ISNULL(out, 0)) from Outcome_o where date < '2001-04-15')

--cost	0.0066347802057862
--operations	8

-- GIT HUB
SELECT (
	SELECT sum(inc) FROM Income_o 
	WHERE date<'2001-04-15') - ( SELECT sum(out) FROM Outcome_o WHERE date<'2001-04-15' )

--cost	0.0066347802057862
--operations	8