--Потопить в следующем сражении суда, которые в первой своей битве были повреждены и больше не участвовали ни в каких сражениях. Если следующего сражения для такого судна не существует в базе данных, не вносить его в таблицу Outcomes. Замечание: в базе данных нет двух сражений, которые состоялись бы в один день.
--    Оператор INSERT
--    Функции LAG и LEAD
-- Процесс -------------------------------------------------------------
select b.[name], b.[date] from Battles b
select o.ship, o.battle, o.result from Outcomes o

select b.[name], b.[date],
LAG(b.[date]) OVER(ORDER BY b.[date]) prev_code, 
LEAD(b.[date]) OVER(ORDER BY b.[date]) next_code
from Battles b

select b.[name], b.[date],
LAG(b.[name]) OVER(ORDER BY b.[date]) prev_code, 
LEAD(b.[name]) OVER(ORDER BY b.[date]) next_code
from Battles b

select o.ship, o.battle from Outcomes o 
left join Battles b on b.[name] = o.battle
where o.result = 'damaged' and o.ship IN (
	select o.ship from Outcomes o
	group by o.ship
	having count(o.result) = 1
)

select o.ship, nb.next_battle 'battle', 'sunk' 'result' from (
	select o.ship, o.battle from Outcomes o 
	left join Battles b on b.[name] = o.battle
	where o.result = 'damaged' and o.ship IN (
		select o.ship from Outcomes o
		group by o.ship
		having count(o.result) = 1
	)
) o
join (
	select b.[name], LEAD(b.[name]) OVER(ORDER BY b.[date]) 'next_battle'
	from Battles b
) nb on nb.[name] = o.battle
where nb.next_battle IS NOT NULL

-- Решение -------------------------------------------------------------
INSERT INTO Outcomes
select o.ship, nb.next_battle 'battle', 'sunk' 'result' from (
	select o.ship, o.battle from Outcomes o 
	left join Battles b on b.[name] = o.battle
	where o.result = 'damaged' and o.ship IN (
		select o.ship from Outcomes o
		group by o.ship
		having count(o.result) = 1
	)
) o
join (
	select b.[name], LEAD(b.[name]) OVER(ORDER BY b.[date]) 'next_battle'
	from Battles b
) nb on nb.[name] = o.battle
where nb.next_battle IS NOT NULL

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/forum.php?F=2&N=18#19