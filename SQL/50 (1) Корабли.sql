--Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct o.battle from Ships sh
join Outcomes o on o.ship = sh.name
where sh.class = 'Kongo'

--cost	0.018896764144301
--operations	4

-- GIT HUB
SELECT DISTINCT battle 
  FROM outcomes 
 WHERE ship IN (SELECT name 
                  FROM ships 
                 WHERE class = 'kongo');

--cost	0.018896764144301
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=50#20