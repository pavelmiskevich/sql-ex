--Укажите сражения, в которых участвовало по меньшей мере три корабля одной и той же страны.
--    Предложение GROUP BY
--    Внешние соединения
--    Предложение HAVING
-- Процесс -------------------------------------------------------------
select o.battle, count(o.ship) from Outcomes o
group by o.battle
having count(o.ship) >= 3

select c.country, o.battle, count(o.ship) from Outcomes o
join Ships s on o.ship = s.name
join Classes c on c.class = s.class
group by c.country, o.battle
having count(o.ship) >= 3
union all
select c.country, o.battle, count(o.ship) from Outcomes o
join Classes c on o.ship = c.class and o.ship NOT IN (select name from Ships)
group by c.country, o.battle
having count(o.ship) >= 3

select r.battle from (
select c.country, o.battle, o.ship from Outcomes o
join Ships s on o.ship = s.name
join Classes c on c.class = s.class --OR on c.class = s.name
--group by c.country, o.battle
--having count(o.ship) >= 3
union all
select c.country, o.battle, o.ship from Outcomes o
join Classes c on o.ship = c.class
where o.ship NOT IN (select name from Ships)
--group by c.country, o.battle
--having count(o.ship) >= 3
) r
group by r.country, r.battle
having count(r.ship) >= 3

select r.battle from (
select distinct t.country, t.battle, t.ship from (
select c.country, o.battle, o.ship from Outcomes o
join Ships s on o.ship = s.name
join Classes c on c.class = s.class --OR on c.class = s.name
--group by c.country, o.battle
--having count(o.ship) >= 3
union all
select c.country, o.battle, o.ship from Outcomes o
join Classes c on o.ship = c.class
where o.ship NOT IN (select name from Ships)
--group by c.country, o.battle
--having count(o.ship) >= 3
) t
) r
group by r.country, r.battle
having count(r.ship) >= 3

-- union с подсчетом кораблей
select r.battle from (
select distinct t.country, t.battle, t.ship from (
select c.country, o.battle, o.ship from Outcomes o
join Ships s on o.ship = s.name
join Classes c on c.class = s.class --OR on c.class = s.name
where c.country IS NOT NULL
--group by c.country, o.battle
--having count(o.ship) >= 3
union
select c.country, o.battle, o.ship from Outcomes o
join Classes c on o.ship = c.class
where o.ship NOT IN (select name from Ships) and c.country IS NOT NULL
--group by c.country, o.battle
--having count(o.ship) >= 3
) t
) r
group by r.country, r.battle
having count(r.ship) >= 3

-- union all с подсчетом стран
select r.battle from (
select c.country, o.battle from Outcomes o
join Ships s on o.ship = s.name
join Classes c on c.class = s.class --OR on c.class = s.name
--group by c.country, o.battle
--having count(o.ship) >= 3
union all
select c.country, o.battle from Outcomes o
join Classes c on o.ship = c.class
where o.ship NOT IN (select name from Ships)
--group by c.country, o.battle
--having count(o.ship) >= 3
) r
group by r.country, r.battle
having count(*) >= 3

select c.country, o.battle from Outcomes o
left join Ships s on s.name = o.ship
left join Classes c on o.ship = c.class OR s.class = c.class
where c.country IS NOT NULL


-- Решение -------------------------------------------------------------
select distinct o.battle from Outcomes o
left join Ships s on s.name = o.ship
left join Classes c on o.ship = c.class OR s.class = c.class
where c.country IS NOT NULL
group by c.country, o.battle
having count(o.battle) >= 3

--cost	0.051127400249243
--operations	10

-- GIT HUB
SELECT DISTINCT Outcomes.battle 
FROM Outcomes 
LEFT JOIN Ships ON Ships.name = Outcomes.ship 
LEFT JOIN Classes ON Outcomes.ship = Classes.class OR Ships.class = Classes.class 
WHERE Classes.country IS NOT NULL 
GROUP BY Classes.country, Outcomes.battle 
HAVING COUNT(Outcomes.ship) >= 3

--cost	0.051127400249243
--operations	10

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=70#20
Select distinct battle from (
Select coalesce(class,ship) class, battle from outcomes o left join ships s on o.ship = s.name) bc join classes on bc.class = classes.class
group by country, battle
having count(country) > =3

--cost	0.043022762984037
--operations	10