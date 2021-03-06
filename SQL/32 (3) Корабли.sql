--Одной из характеристик корабля является половина куба калибра его главных орудий (mw). С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных.
--    Явные операции соединения
--    Предложение GROUP BY
--    Объединение
--    Переименование столбцов и вычисления в результирующем наборе
--    Преобразoвание типов
--    Описание БД
-- Процесс -------------------------------------------------------------
SELECT DISTINCT Classes.country, ( SELECT AVG( pen.p ) FROM 
   ( 
    SELECT (c1.bore*c1.bore*c1.bore)/2 AS p FROM Classes AS c1, Ships AS s1 
         WHERE c1.class=s1.class AND c1.country = Classes.country 
            AND c1.bore IS NOT NULL
    UNION ALL 
    SELECT (c2.bore*c2.bore*c2.bore)/2 FROM Classes AS c2, (select distinct ship from Outcomes ) ou 
        WHERE c2.country = Classes.country AND c2.class=ou.ship 
            AND c2.bore IS NOT NULL 
            AND ou.ship NOT IN ( SELECT ss.name FROM Ships AS ss ) 
    ) AS pen 
    WHERE pen.p IS NOT NULL 
             ) AS weight 
FROM Classes 
WHERE Classes.country IS NOT NULL

SELECT DISTINCT Classes.country, CAST(( SELECT AVG( pen.p ) FROM 
   ( 
    SELECT (c1.bore*c1.bore*c1.bore)/2 AS p FROM Classes AS c1, Ships AS s1 
         WHERE c1.class=s1.class AND c1.country = Classes.country 
            AND c1.bore IS NOT NULL
    UNION ALL 
    SELECT (c2.bore*c2.bore*c2.bore)/2 FROM Classes AS c2, (select distinct ship from Outcomes ) ou 
        WHERE c2.country = Classes.country AND c2.class=ou.ship 
            AND c2.bore IS NOT NULL 
            AND ou.ship NOT IN ( SELECT ss.name FROM Ships AS ss ) 
    ) AS pen 
    WHERE pen.p IS NOT NULL 
             ) AS NUMERIC(6,2)) AS weight 
FROM Classes 
WHERE Classes.country IS NOT NULL

SELECT country, AVG(bore*bore*bore)/2 FROM (
select cl.country, bore from Ships sh
join Classes cl on sh.class = cl.class
WHERE bore IS NOT NULL
union all
select cl.country, bore from Outcomes o
join Classes cl on o.ship = cl.class
where o.ship NOT IN (select name from Ships) AND bore IS NOT NULL
)
GROUP BY country;

SELECT t.country, CAST(AVG(bore*bore*bore)/2 AS NUMERIC(6,2)) FROM (
select cl.country, cl.class, cl.bore, sh.name from Ships sh
left join Classes cl on cl.class = sh.class
WHERE bore IS NOT NULL
union all
select DISTINCT cl.country, cl.class, cl.bore, o.ship from Outcomes o
left join Classes cl on cl.class = o.ship
where o.ship NOT IN (select name from Ships) AND bore IS NOT NULL
) t
GROUP BY t.country
-- Решение -------------------------------------------------------------
SELECT t.country, CAST(AVG(bore*bore*bore)/2 AS NUMERIC(6,2)) FROM (
	select cl.country, cl.class, cl.bore, sh.name from Ships sh
	left join Classes cl on cl.class = sh.class
	WHERE cl.bore IS NOT NULL
	union all
	select DISTINCT cl.country, cl.class, cl.bore, o.ship from Outcomes o
	left join Classes cl on cl.class = o.ship
	where o.ship NOT IN (select name from Ships) AND cl.bore IS NOT NULL
) t
GROUP BY t.country

--cost	0.045528307557106
--operations	14

-- GIT HUB
SELECT country, cast(avg((power(bore,3)/2)) as numeric(6,2)) as weight 
    FROM ( SELECT country, classes.class, bore, name 
               FROM classes LEFT JOIN ships ON classes.class = ships.class 
           UNION ALL 
           SELECT DISTINCT country, class, bore, ship 
               FROM classes t1 LEFT JOIN outcomes t2 ON t1.class = t2.ship 
           WHERE ship = class 
             AND ship NOT IN (SELECT name FROM ships) 
          ) a 
    where name IS NOT NULL group by country ;

--cost	0.049990393221378
--operations	14

SELECT country, cast(avg((power(bore,3)/2)) AS numeric(6,2)) AS weight 
FROM (SELECT country, classes.class, bore, name FROM classes LEFT JOIN ships ON classes.class=ships.class 
	UNION ALL 
	SELECT DISTINCT country, class, bore, ship FROM classes t1 LEFT JOIN outcomes t2 ON t1.class=t2.ship 
	WHERE ship=class and ship not in (SELECT name FROM ships) 
) a WHERE name IS NOT NULL GROUP BY country

--cost	0.049990393221378
--operations	14

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=32#20
SELECT Country, ISNULL(CONVERT(NUMERIC(6,2), AVG(POWER(Bore,3)/2)), 0) Wght
FROM (
SELECT ship name, class, country, bore
FROM Outcomes, Classes
WHERE Outcomes.ship = Classes.class
UNION
SELECT Ships.name, Classes.class, country, bore
FROM Ships, Classes
WHERE Ships.class = Classes.class ) as s
GROUP BY Country

--cost 0.041329685598612
--operations 11