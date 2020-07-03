--С точностью до 2-х десятичных знаков определите среднее число орудий всех линейных кораблей (учесть корабли из таблицы Outcomes).
--    Явные операции соединения
--    Объединение
--    Получение итоговых значений
--    Преобразование типов
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select STR(avg(convert(real, m.numGuns)), 5, 2) avgguns from (
	select cl.numGuns from Classes cl
	join Ships sh on cl.class = sh.class
	where cl.type = 'bb'
	union all
	select cl.numGuns from Classes cl
	join (select distinct o.ship from Outcomes o)  ou on cl.class = ou.ship
	where cl.type = 'bb' and ou.ship not in (select name from Ships)
) m

--cost	0.033457856625319
--operations	13

-- GIT HUB
SELECT CAST(AVG(CAST(x.numguns as numeric(6,2))) AS numeric(6,2))
FROM ( 
	SELECT numguns, name 
	FROM classes 
	RIGHT JOIN ships ON classes.class=ships.class AND type='bb' AND ships.name <>'null' AND ships.class <>'null' 
	UNION ALL 
	SELECT DISTINCT numguns, ship 
	FROM classes LEFT JOIN outcomes ON classes.class=outcomes.ship 
	WHERE ship not IN (SELECT name FROM ships) AND class<>'null' AND type='bb' 
) AS x
   
--cost	0.051224797964096
--operations	19