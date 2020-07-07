--Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
--    Явные операции соединения
--    Предложение GROUP BY
--    Объединение
--    Подзапросы
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select cl.class, count(m.name) from Classes cl
left join (
	select sh.class, sh.name from Ships sh
	join Outcomes o on o.ship = sh.name and o.result = 'sunk'
	union all
	select o.ship, o.ship from Outcomes o
	join Classes cl on o.ship = cl.class
	where o.result = 'sunk' and o.ship not in (select name from Ships)) m on cl.class = m.class
group by cl.class

--cost	0.041732884943485
--operations	14

-- GIT HUB
SELECT classes.class, COUNT(R.ship) 
FROM classes 
LEFT JOIN ( 
	SELECT outcomes.ship, ships.class 
	FROM outcomes 
	LEFT JOIN ships ON ships.name = outcomes.ship 
	WHERE outcomes.result = 'sunk' 
) AS R ON R.class = classes.class OR R.ship = classes.class 
GROUP BY classes.class
   
--cost	0.029186066240072
--operations	9