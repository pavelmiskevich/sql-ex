--Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
--Вывести: type, model, speed
--    Использование в запросе нескольких источников записей
--    Использование ключевых слов ANY, ALL с предикатами сравнения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct pr.type, lp.model, lp.speed from  Laptop lp, Product pr
where lp.speed < ALL (select speed from PC) and pr.type = 'Laptop'

--cost	0.02461607567966
--operations	8

-- GIT HUB
select distinct Product.type, Laptop.model, Laptop.speed 
from Laptop inner join Product ON Product.model =  Laptop.model 
WHERE speed < ALL(select speed from PC)

--cost	0.025120675563812
--operations	7

SELECT DISTINCT p.type, p.model, l.speed 
    FROM laptop l 
    JOIN product p on l.model = p.model 
    WHERE l.speed < (SELECT MIN(speed) FROM pc)

--cost	0.022069375962019
--operations	7

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=17#20