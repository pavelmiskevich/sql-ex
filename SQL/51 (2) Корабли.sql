--Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).
--    Явные операции соединения
--    Объединение
--    Предикаты ALL|ANY
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


select distinct sh.name from Ships sh
join Classes cl on sh.class = cl.class
join (select max(numGuns) numGuns, displacement from Classes group by displacement) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement
--where sh.name NOT IN (select ship from Outcomes)
union
select distinct ou.ship from Outcomes ou
join Classes cl on ou.ship = cl.class
join (select max(numGuns) numGuns, displacement from Classes group by displacement) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement
--where ou.ship NOT IN (select name from Ships)


select distinct sh.name from Ships sh
join Classes cl on sh.class = cl.class
join (
select distinct max(cl.numGuns) numGuns, cl.displacement from Ships sh
join Classes cl on sh.class = cl.class
group by cl.displacement
union
select distinct max(cl.numGuns) numGuns, cl.displacement from Outcomes ou
join Classes cl on ou.ship = cl.class
where ou.ship NOT IN (select name from Ships)
group by cl.displacement
) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement
union
select distinct ou.ship from Outcomes ou
join Classes cl on ou.ship = cl.class
join (
select distinct max(cl.numGuns) numGuns, cl.displacement from Ships sh
join Classes cl on sh.class = cl.class
group by cl.displacement
union
select distinct max(cl.numGuns) numGuns, cl.displacement from Outcomes ou
join Classes cl on ou.ship = cl.class
where ou.ship NOT IN (select name from Ships)
group by cl.displacement
) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement
where ou.ship NOT IN (select name from Ships)

-- Решение -------------------------------------------------------------
select distinct sh.name from Ships sh
join Classes cl on sh.class = cl.class
join (
	select max(t.numGuns) numGuns, t.displacement from (
		select distinct cl.numGuns, cl.displacement from Ships sh
		join Classes cl on sh.class = cl.class
		--group by cl.displacement
		union
		select distinct cl.numGuns, cl.displacement from Outcomes ou
		join Classes cl on ou.ship = cl.class
		where ou.ship NOT IN (select name from Ships)
		--group by cl.displacement
	) t
	group by t.displacement
) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement
union
select distinct ou.ship from Outcomes ou
join Classes cl on ou.ship = cl.class
join (
	select max(t.numGuns) numGuns, t.displacement from (
		select distinct cl.numGuns, cl.displacement from Ships sh
		join Classes cl on sh.class = cl.class
		--group by cl.displacement
		union
		select distinct cl.numGuns, cl.displacement from Outcomes ou
		join Classes cl on ou.ship = cl.class
		where ou.ship NOT IN (select name from Ships)
		--group by cl.displacement
	) t
	group by t.displacement
) m on cl.numGuns = m.numGuns and cl.displacement = m.displacement
where ou.ship NOT IN (select name from Ships)

--cost	0.22113542258739
--operations	39

-- GIT HUB