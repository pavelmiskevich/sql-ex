--Удалите классы, имеющие в базе данных менее трех кораблей (учесть корабли из Outcomes).
--    Оператор DELETE
-- Процесс -------------------------------------------------------------
delete Classes where class in (select class from Ships group by class
having count(name) < 3
union all SELECT class
FROM classes c, outcomes o
WHERE c.class = o.ship
AND
NOT EXISTS (SELECT 'x'
      FROM ships s
       WHERE o.ship = s.class)
group by c.class having count(o.ship) < 3
union all
select cl.class from Classes cl
where cl.class not in (select name from Ships) and cl.class not in (select
class from Ships) and cl.class not in (select ship from Outcomes)
union all
select o.ship from Outcomes o
join Classes cl on o.ship = cl.class
where not exists (select name from Ships where name = o.ship) and (select count(sh.name) from Ships sh where sh.class = o.ship and sh.class <> sh.name) < 2
)

delete Classes where class in (
	select t.class from (
		select distinct sh.class, sh.[name] from Ships sh
		union
		select cl.class, ou.ship from Outcomes ou
		join Classes cl on cl.class = ou.ship
		where ou.ship not in (select [name] from Ships)
	) t
	group by t.class
	having count(t.[name]) < 3
)
-- Решение -------------------------------------------------------------
delete Classes where class in (
	SELECT c.class 
		FROM classes c 
			LEFT JOIN ( 
				SELECT class, [name] FROM ships 
				UNION 
				SELECT ship, ship  FROM outcomes 
			) AS s ON s.class = c.class 
		GROUP BY c.class 
		HAVING COUNT(s.name) < 3
)

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/forum.php?F=2&N=14#17
