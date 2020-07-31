--Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).
--    Явные операции соединения
--    Объединение
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct sh.name from Ships sh
join (select class from Classes
	where bore = 16) m on sh.class = m.class
where sh.name not in (select distinct o.ship from Outcomes o
join (select class from Classes
	where bore = 16) m on o.ship = m.class)
union all
select distinct o.ship from Outcomes o
join (select class from Classes
	where bore = 16) m on o.ship = m.class

--cost	0.034911654889584
--operations	13

-- GIT HUB
SELECT ships.name 
  FROM classes JOIN ships ON classes.class = ships.class 
 WHERE bore = 16 
UNION 
SELECT outcomes.ship 
  FROM outcomes JOIN classes ON classes.class = outcomes.ship 
 WHERE bore = 16 ; 

--cost	0.031208729371428
--operations	8

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=49#20
SELECT ship
FROM
(
SELECT ship, ship AS class
FROM outcomes
UNION
SELECT name, class
FROM ships
) s
JOIN classes c ON c.class = s.class
WHERE bore = 16

--cost 0.024889957159758
--operations 6