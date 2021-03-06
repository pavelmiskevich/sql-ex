--Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
--    Явные операции соединения
--    Предложение GROUP BY
--    Предложение HAVING
--    Объединение
--    Предикат IN
-- Процесс -------------------------------------------------------------
select distinct sh.name from Ships sh
join Classes cl on sh.class = cl.class
join (select max(numGuns) numGuns, displacement from Classes group by displacement) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement
where sh.name not in (select distinct o.ship from Outcomes o
join Classes cl on o.ship = cl.class
join (select max(numGuns) numGuns, displacement from Classes group by displacement) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement)
union all
select distinct o.ship from Outcomes o
join Classes cl on o.ship = cl.class
join (select max(numGuns) numGuns, displacement from Classes group by displacement) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement

select cl.class, count() from Classes cl

select distinct sh.name from Ships sh
join Classes cl on sh.class = cl.class
union
select distinct o.ship from Outcomes o
join Classes cl on o.ship = cl.class
where o.ship NOT IN (select name from Ships)

select t.class, count(t.name) from (
select distinct cl.class, sh.name from Ships sh
join Classes cl on sh.class = cl.class
union
select distinct cl.class, o.ship from Outcomes o
join Classes cl on o.ship = cl.class
where o.ship NOT IN (select name from Ships)
) t
group by t.class
having count(t.name) >= 3

select t.class, count(t.name) from (
select distinct cl.class, sh.name from Ships sh
join Classes cl on sh.class = cl.class
join Outcomes o on o.ship = sh.name and o.result = 'sunk'
union
select distinct cl.class, o.ship from Outcomes o
join Classes cl on o.ship = cl.class
where o.ship NOT IN (select name from Ships) and o.result = 'sunk'
) t
group by t.class
-- Решение -------------------------------------------------------------
select t.class, count(t.name) from (
	select distinct cl.class, sh.name from Ships sh
	join Classes cl on sh.class = cl.class
	join Outcomes o on o.ship = sh.name and o.result = 'sunk'
	union
	select distinct cl.class, o.ship from Outcomes o
	join Classes cl on o.ship = cl.class
	where o.ship NOT IN (select name from Ships) and o.result = 'sunk'
	) t
	where t.class IN (
		select t.class from (
			select distinct cl.class, sh.name from Ships sh
			join Classes cl on sh.class = cl.class
			union
			select distinct cl.class, o.ship from Outcomes o
			join Classes cl on o.ship = cl.class
			where o.ship NOT IN (select name from Ships)
		) t
	group by t.class
	having count(t.name) >= 3
)
group by t.class

--cost	0.066263467073441
--operations	31

-- GIT HUB
