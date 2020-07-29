--Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
--    Объединение
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct sh.name from Ships sh where sh.name = sh.class
union all
select distinct o.Ship from Outcomes o
join Classes cl on o.ship = cl.class
where o.Ship not in (
	select distinct sh.name from Ships sh where sh.name = sh.class)

--cost	0.024420326575637
--operations	8

-- GIT HUB
SELECT name FROM ships WHERE class = name 
  UNION 
  SELECT ship as name FROM classes, outcomes 
      WHERE classes.class = outcomes.ship;

--cost	0.021003682166338
--operations	6

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=36#20