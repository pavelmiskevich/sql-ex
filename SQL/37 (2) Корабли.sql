--Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
--    Объединение
--    Явные операции соединения
--    Предложение HAVING
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select cl.class from Classes cl
join Outcomes ou on cl.class = ou.ship
where ou.ship not in (
	select name from Ships)
and not exists (
	select 'x' from Ships where class = cl.class)
union
select cl.class from Classes cl
join Ships sh on cl.class = sh.class
group by cl.class
having count(sh.name) = 1
and not exists(
	select 'y' from Classes c
	join Outcomes ou on c.class = ou.ship
	where ou.ship not in (
		select name from Ships) and c.class = cl.class)

--cost	0.068220011889935
--operations	22

-- GIT HUB
SELECT c.class 
    FROM classes c 
        LEFT JOIN ( 
            SELECT class, name FROM ships 
            UNION 
            SELECT ship, ship  FROM outcomes 
        ) AS s ON s.class = c.class 
    GROUP BY c.class 
    HAVING COUNT(s.name) = 1;

--cost	0.043236702680588
--operations	10

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=37#20
SELECT CLASS FROM CLASSES WHERE CLASS IN (
  SELECT CLASS FROM (
    SELECT NAME, CLASS FROM SHIPS
    UNION
    SELECT SHIP, SHIP FROM OUTCOMES
  ) AS ALL_SHIPS GROUP BY CLASS
    HAVING COUNT(*)=1
)

--cost 0.028612241148949
--operations 11

WITH res AS (
SELECT class, name nm
FROM Ships
UNION
SELECT c.class, ship nm
FROM Classes c, Outcomes o
WHERE c.class = o.ship
)
SELECT class
FROM res
GROUP BY class
HAVING COUNT(nm) = 1

--cost 0.027945596724749
--operations 9