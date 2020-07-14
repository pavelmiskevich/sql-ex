--Определить названия всех кораблей из таблицы Ships, которые удовлетворяют, по крайней мере, комбинации любых четырёх критериев из следующего списка:
--numGuns = 8
--bore = 15
--displacement = 32000
--type = bb
--launched = 1915
--class=Kongo
--country=USA
--    Оператор CASE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct sh.name from Ships sh
join Classes cl on sh.class = cl.class
where (select case when (cl.numguns = 8) then 1 else 0 end 
+ case when (cl.bore = 15) then 1 else 0 end 
+ case when (cl.displacement = 32000) then 1 else 0 end 
+ case when (cl.type = 'bb') then 1 else 0 end 
+ case when (sh.launched = 1915) then 1 else 0 end 
+ case when (sh.class = 'Kongo') then 1 else 0 end 
+ case when (cl.country = 'USA') then 1 else 0 end) > 3

--cost	0.01764022000134
--operations	4

-- GIT HUB
SELECT name 
FROM Ships JOIN Classes ON Ships.class = Classes.class 
WHERE 
CASE WHEN numGuns = 8 THEN 1 ELSE 0 END + 
CASE WHEN bore = 15 THEN 1 ELSE 0 END + 
CASE WHEN displacement = 32000 THEN 1 ELSE 0 END + 
CASE WHEN type = 'bb' THEN 1 ELSE 0 END + 
CASE WHEN launched = 1915 THEN 1 ELSE 0 END + 
CASE WHEN Ships.class = 'Kongo' THEN 1 ELSE 0 END + 
CASE WHEN country = 'USA' THEN 1 ELSE 0 END > = 4

--cost	0.01764022000134
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=83#20
with cte as(
select s.name, sum(case when c.numGuns = 8 then 1 else 0 end) a,
	     sum(case when c.bore = 15 then 1 else 0 end) b,
	     sum(case when c.displacement = 32000 then 1 else 0 end) c,
             sum(case when c.type = 'bb' then 1 else 0 end) d,
	     sum(case when s.launched = 1915 then 1 else 0 end) e,
	     sum(case when c.class = 'Kongo' then 1 else 0 end) f,
	     sum(case when c.country = 'usa' then 1 else 0 end) g
from ships s
join classes c on s.class = c.class
group by s.name
)

select name from cte where a+b+c+d+e+f+g > =4 

--cost 0.017551170662045
--operations 7