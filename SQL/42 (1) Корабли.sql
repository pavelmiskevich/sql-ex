--Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.
--    Простой оператор SELECT
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct o.ship, o.battle from Outcomes o
where o.result = 'sunk'

--cost	0.0033557000569999
--operations	1

-- GIT HUB
SELECT ship, battle 
  FROM outcomes 
 WHERE result = 'sunk';

--cost	0.0033557000569999
--operations	1

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=42#20