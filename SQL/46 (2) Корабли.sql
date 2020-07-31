--Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.
--    Внешние соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
SELECT o.Ship, 
	isnull(c.displacement,(SELECT top 1 displacement from Classes where class = o.Ship)) displacement, 
	isnull(c.numGuns, (SELECT top 1 NumGuns from Classes where class = o.Ship)) numGuns 
FROM outcomes o 
LEFT JOIN Ships s ON o.ship=s.Name 
LEFT JOIN classes c ON s.class=c.Class 
LEFT JOIN battles b ON b.Name=o.Battle 
WHERE (b.Name='Guadalcanal')
union all
select o.Ship, 
	isnull(c.displacement,(SELECT top 1 displacement from Classes where class = o.Ship)) displacement, 
	isnull(c.numGuns, (SELECT top 1 NumGuns from Classes where class = o.Ship)) numGuns 
from Outcomes o left join Classes c on c.class = o.ship
LEFT JOIN battles b ON b.Name=o.Battle 
WHERE (b.Name='Guadalcanal') and o.ship not in (SELECT o.Ship 
FROM outcomes o 
LEFT JOIN Ships s ON o.ship=s.Name 
LEFT JOIN classes c ON s.class=c.Class 
LEFT JOIN battles b ON b.Name=o.Battle 
WHERE (b.Name='Guadalcanal'))

--cost	0.052734963595867
--operations	31

-- GIT HUB
SELECT o.ship, displacement, numGuns 
  FROM (SELECT name AS ship, displacement, numGuns 
          FROM ships s JOIN classes c ON c.class = s.class 
        UNION 
        SELECT class AS ship, displacement, numGuns 
          FROM classes c) AS a 
RIGHT JOIN outcomes o ON o.ship = a.ship 
WHERE battle = 'Guadalcanal';

--cost	0.028119741007686
--operations	8

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=46#20
SELECT
   t4.ship
  ,t3.displacement
  ,t3.numGuns
FROM (
  SELECT
     t1.ship
    ,COALESCE (t2.class, t1.ship) class
    ,t1.battle
   FROM Outcomes t1
   LEFT JOIN Ships t2
   ON t1.ship = t2.name
   WHERE t1.battle = 'Guadalcanal'
) t4
LEFT JOIN Classes t3
ON t3.class= t4.class

--cost 0.01227368041873
--operations 5  