--Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.
--    Явные операции соединения
--    Объединение
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct cl.class from Classes cl
join (
	select distinct ship from Outcomes where result = 'sunk') m on cl.class = m.ship
where cl.class not in (select distinct sh.class from Ships sh
join (
	select distinct ship from Outcomes where result = 'sunk') m on sh.name = m.ship) 
	and cl.class not in (select name from Ships)
union all
select distinct sh.class from Ships sh
join (
	select distinct ship from Outcomes where result = 'sunk') m on sh.name = m.ship

--cost	0.048281621187925
--operations	17

-- GIT HUB
SELECT cl.class 
  FROM Classes cl 
  LEFT JOIN Ships s ON s.class = cl.class 
 WHERE cl.class IN (SELECT ship FROM Outcomes WHERE result = 'sunk') OR 
         s.name IN (SELECT ship FROM Outcomes WHERE result = 'sunk') 
 GROUP BY cl.class;

--cost	0.032315377146006
--operations	8

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=48#20
SELECT
  t4.class
FROM Classes t4
INNER JOIN (
  SELECT
    /*t1.ship,*/
    COALESCE(t2.class, t1.ship) class
  FROM Outcomes t1
  LEFT JOIN Ships t2
  ON t1.ship = t2.name
  WHERE result = 'sunk') t3
ON t3.class = t4.class
GROUP BY t4.class

--cost 0.026974806562066
--operations 6