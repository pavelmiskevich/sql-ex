--Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
--Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.
--    Объединение
--    Предикат LIKE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct sh.name from Ships sh
where (
	select CHARINDEX(' ', ltrim(rtrim(sh.name)), CHARINDEX(' ', ltrim(rtrim(sh.name))) + 1)) > 0
union all
select distinct o.ship from Outcomes o
--join Classes cl on o.ship = cl.class
where o.ship not in (select sh.name from Ships sh
) and (
	select CHARINDEX(' ', ltrim(rtrim(o.ship)), CHARINDEX(' ', ltrim(rtrim(o.ship))) + 1)) > 0

--cost	0.013179617002606
--operations	6

-- GIT HUB
SELECT name FROM ships 
 WHERE name LIKE '% % %' 
UNION 
SELECT ship FROM outcomes 
 WHERE ship LIKE '% % %';

--cost	0.012523947283626
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=45#20