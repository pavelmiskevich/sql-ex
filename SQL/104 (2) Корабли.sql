--Для каждого класса крейсеров, число орудий которого известно, пронумеровать (последовательно от единицы) все орудия.
--Вывод: имя класса, номер орудия в формате 'bc-N'.
--    Генерация числовой последовательности
-- Процесс -------------------------------------------------------------
select cl.* from Classes cl 
where cl.numGuns IS NOT NULL and cl.[type] = 'bc'

select cl.*, ROW_NUMBER() over(partition by cl.class order by cl.class) from Classes cl 
where cl.numGuns IS NOT NULL and cl.[type] = 'bc'
-- Решение -------------------------------------------------------------
WITH cla ([class], [numGuns]) AS 
(
    select cl.class, cl.numGuns from Classes cl 
	where cl.numGuns IS NOT NULL and cl.[type] = 'bc'
), num ([count]) AS 
(
    select 1
	union ALL
	select [count] + 1 from num WHERE [count] < 100
)
select cla.class, 'bc-' + Cast(num.count as varchar) 'num' from cla, num
where num.[count] <= (select c2.numGuns from cla c2 where c2.class = cla.class)
order by cla.class

--cost	0.021422032266855
--operations	17

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=104
with sq1(num) AS
(
SELECT ones.n + 10*tens.n + 100*hundreds.n
FROM (VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) ones(n),
     (VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) tens(n),
     (VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) hundreds(n)
)
SELECT class, CONCAT('bc-', CONVERT(VARCHAR,num)) FROM classes JOIN sq1 ON num<=numGuns AND NOT num=0 WHERE type='bc'

--cost 0.18596008419991
--operations 8

WITH cnt AS
	(SELECT class, CONCAT('bc-', 1) gun, 1 AS n, numguns
	 FROM classes
	 WHERE type = 'bc' AND numguns IS NOT NULL
	 UNION ALL
	 SELECT class, CONCAT('bc-', n+1), n+1, numguns
	 FROM cnt
	 WHERE n < numguns)

SELECT class, gun
FROM cnt

--cost 0.0033792110625654
--operations 12