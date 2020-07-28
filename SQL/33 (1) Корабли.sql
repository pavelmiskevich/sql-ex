--Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
--    Простой оператор SELECT
--    Предикаты (часть 1)
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select ship from Outcomes
where battle = 'North Atlantic' and result = 'sunk'

--cost	0.0033557000569999
--operations	1

-- GIT HUB
SELECT o.ship 
    FROM battles b LEFT JOIN outcomes o ON o.battle = b.name 
    WHERE b.name = 'North Atlantic' AND o.result = 'sunk';

--cost	0.0067110559903085
--operations	3

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=33#20