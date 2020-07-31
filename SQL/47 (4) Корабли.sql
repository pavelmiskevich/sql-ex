--Определить страны, которые потеряли в сражениях все свои корабли.
--    Получение итоговых значений
--    Предложение GROUP BY
--    Объединение
--    Внешние соединения
-- Процесс -------------------------------------------------------------
select cl.country, sh.name from Classes cl
join Ships sh on cl.class = sh.class
join Outcomes ou on ou.ship = sh.name and ou.result = 'sunk'
where 
union all

select distinct cl.country, ou.ship from Classes cl
join Outcomes ou on ou.ship = cl.class and ou.result = 'sunk'

select cl.country, sh.name, ou.result from Classes cl
join Ships sh on cl.class = sh.class
join Outcomes ou on ou.ship = sh.name and ou.result <> 'sunk'
select ou.ship from Outcomes ou where ou.result = 'sunk'


select cl.country, sh.name, 'sunk' from Classes cl
join Ships sh on cl.class = sh.class
--join Outcomes ou on ou.ship = sh.name
where sh.name IN (select ou.ship from Outcomes ou where ou.result = 'sunk')
union all
select distinct cl.country, ou.ship, 'sunk' from Classes cl
join Outcomes ou on ou.ship = cl.class --and ou.result = 'sunk'
where ou.ship IN (select ou.ship from Outcomes ou where ou.result = 'sunk')


select distinct cl.country, sh.name from Classes cl
join Ships sh on cl.class = sh.class
join Outcomes ou on ou.ship = sh.name and ou.result = 'sunk'
--left join Outcomes ou2 on ou.ship = sh.name and ou.result <> 'sunk'
group by cl.country, sh.name
having count(sh.name) = count(ou.result)
union all
select distinct cl.country, ou.ship from Classes cl
join Outcomes ou on ou.ship = cl.class and ou.result = 'sunk'



select allsh.country, count(allsh.name), count(ssh.name) from (
select cl.country, count(sh.name) from Classes cl
join Ships sh on cl.class = sh.class
group by cl.country
union all
select distinct cl.country, count(ou.ship) from Classes cl
join Outcomes ou on ou.ship = cl.class and ou.ship NOT IN (select sh.Name from Ships sh)
group by cl.country
) allsh
join (
select distinct cl.country, count(sh.name) from Classes cl
join Ships sh on cl.class = sh.class
join Outcomes ou on ou.ship = sh.name and ou.result = 'sunk'
group by cl.country
union all
select distinct cl.country, count(ou.ship) from Classes cl
join Outcomes ou on ou.ship = cl.class and ou.result = 'sunk' and ou.ship NOT IN (select sh.Name from Ships sh)
group by cl.country
) ssh on allsh.country = ssh.country
-- Решение -------------------------------------------------------------
select distinct allsh.country from (
	select country, count(name) as 'c' from (
	select distinct cl.country, sh.name as 'name' from Classes cl
	join Ships sh on cl.class = sh.class
	--group by cl.country
	union
	select distinct cl.country, ou.ship as 'name' from Classes cl
	join Outcomes ou on ou.ship = cl.class and ou.ship NOT IN (select sh.Name from Ships sh)
	--group by cl.country
	) allsh
	group by allsh.country
) allsh
join (
select country, count(name) as 'c' from (
	select distinct cl.country, sh.name from Classes cl
	join Ships sh on cl.class = sh.class
	join Outcomes ou on ou.ship = sh.name and ou.result = 'sunk'
	--group by cl.country
	union
	select distinct cl.country, ou.ship from Classes cl
	join Outcomes ou on ou.ship = cl.class and ou.result = 'sunk' and ou.ship NOT IN (select sh.Name from Ships sh)
	--group by cl.country
	) ssh
	group by ssh.country
) ssh on allsh.country = ssh.country
where allsh.c = ssh.c

--cost	0.11918180435896
--operations	30

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=47#20
select b.country
from outcomes a right join
--ниже таблица, в которой есть все произведенные корабли находящиеся в базе
(select a1.ship as name, b1.class, b1.country
from outcomes a1 join classes b1 on a1.ship=b1.class
union 
select a2.name, a2.class, b2.country
from ships a2 join classes b2 on a2.class=b2.class) b
on a.ship=b.name and a.result='sunk'
group by b.country
--сравниваем количество произведенных с количеством потопленных
having count(*)<=count(a.result)

--cost 0.054178800433874
--operations 13

SELECT country
FROM
(
SELECT 
    country, 
    COALESCE(MAX(result), 'ok') as shipResult
FROM
    outcomes o1
    FULL JOIN ships s1 ON o1.ship = s1.name
    JOIN classes c1 ON (s1.class = c1.class OR o1.ship = c1.class)
GROUP BY 
    country, COALESCE(o1.ship, s1.name)
) everyShipResult
GROUP BY country
HAVING MIN(shipResult) = 'sunk'

--cost 0.06767
--operations 10