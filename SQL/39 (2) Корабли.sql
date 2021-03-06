--Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.
--    Явные операции соединения
--    Предикат EXISTS
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct ou.ship from Outcomes ou
join Battles ba on ou.battle = ba.name
where ou.result = 'damaged'
and EXISTS(
	select notda.ship from Outcomes notda
	join Battles ba2 on notda.battle = ba2.name
	where notda.ship = ou.ship AND ba2.date > ba.date
)

--cost	0.022363247349858
--operations	8

-- GIT HUB
SELECT DISTINCT ship 
  FROM outcomes o 
  JOIN battles  b 
    ON o.battle = b.name 
 WHERE EXISTS (SELECT * 
                 FROM outcomes o_in 
                 JOIN battles  b_in 
                   ON o_in.battle = b_in.name 
                WHERE b_in.date > b.date 
                  AND o.ship = o_in.ship) 
   AND o.result = 'damaged' 

--cost	0.022363247349858
--operations	8

SELECT DISTINCT R.ship 
FROM (SELECT outcomes.ship, battles.name, battles.date, outcomes.result 
	FROM outcomes INNER JOIN battles ON outcomes.battle = battles.name 
	) R 
WHERE UPPER(R.ship) IN (
	SELECT UPPER(ship) FROM (
		SELECT outcomes.ship, battles.name, battles.date, outcomes.result FROM outcomes 
		INNER JOIN battles ON outcomes.battle = battles.name )  R1 
	WHERE R1.date < R.date AND R1.result = 'damaged')

--cost	0.046461399644613
--operations	11

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=39#20