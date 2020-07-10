--Для каждой страны определить сражения, в которых не участвовали корабли данной страны.
--Вывод: страна, сражение
--    Традиционные операции над множествами и оператор SELECT
-- Процесс -------------------------------------------------------------
select c.country, o.battle from Classes c
left join Ships s on c.class = s.class
left join Outcomes o on o.ship = c.class

select c.country, o.battle from Classes c
cross join
Outcomes o

SELECT t.country, t.name, COUNT(o.ship) FROM (
SELECT DISTINCT c.country, b.name FROM Classes c
CROSS JOIN
Battles b
) t
left join Outcomes o on t.name = o.battle

GROUP BY  t.country, t.name
HAVING COUNT(o.ship) = 0

SELECT DISTINCT c.country, b.name FROM Classes c
CROSS JOIN
Battles b
EXCEPT
select c.country, o.battle from Classes c
join Ships s ON c.class = s.class
join Outcomes o ON s.name = o.ship
union
select c.country, o.battle from Classes c
join Outcomes o ON c.class = o. ship
where o.ship NOT IN (select name from Ships)
-- Решение -------------------------------------------------------------
SELECT DISTINCT c.country, b.name FROM Classes c
CROSS JOIN
Battles b
EXCEPT
(
	select c.country, o.battle from Classes c
	join Ships s ON c.class = s.class
	join Outcomes o ON s.name = o.ship
	union
	select c.country, o.battle from Classes c
	join Outcomes o ON c.class = o. ship
	where o.ship NOT IN (select name from Ships)
)

--cost	0.079584747552872
--operations	17

-- GIT HUB
SELECT DISTINCT Classes.country, Battles.name 
FROM Battles, Classes
EXCEPT
SELECT Classes.country, Outcomes.battle FROM Outcomes
LEFT JOIN Ships ON Ships.name = Outcomes.ship
LEFT JOIN Classes ON Outcomes.ship = Classes.class OR Ships.class = Classes.class
WHERE Classes.country IS NOT NULL
GROUP BY Classes.country, Outcomes.battle

--cost	0.073482625186443
--operations	11

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=73#20
SELECT DISTINCT COUNTRY, NAME
  FROM BATTLES
    CROSS JOIN CLASSES
MINUS
SELECT DISTINCT COUNTRY, BATTLE NAME
  FROM OUTCOMES O
    LEFT JOIN SHIPS S ON O.SHIP = S.NAME
    JOIN CLASSES C ON C.CLASS=O.SHIP OR S.CLASS=C.CLASS
  WHERE COUNTRY IS NOT NULL

--cost 0.02024776302278
--operations 11
--Это красиво и , главное, дёшево. Единственный минус - не даёт правильного результата.