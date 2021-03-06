--Найдите названия всех кораблей в базе данных, начинающихся с буквы R.
--    Объединение
--    Предикат LIKE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select sh.name from Ships sh
where sh.name LIKE 'R%'
union all
select o.ship from Outcomes o
--join Classes cl on o.ship = cl.class
where o.ship LIKE 'R%' and o.ship not in (
	select sh.name from Ships sh where sh.name LIKE 'R%'
)

--cost	0.010561649687588
--operations	5

-- GIT HUB
SELECT name FROM ships 
 WHERE name LIKE 'R%' 
UNION 
SELECT ship FROM outcomes 
 WHERE ship LIKE 'R%';

--cost	0.01223062351346
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=44#20