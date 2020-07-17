--Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
--    Получение итоговых значений
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select avg(speed) from Laptop where price > 1000

--cost	0.0033154599368572
--operations	3

-- GIT HUB
SELECT AVG(speed) 
    FROM laptop 
    WHERE price > 1000 

--cost	0.0033154599368572
--operations	3

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=12#20