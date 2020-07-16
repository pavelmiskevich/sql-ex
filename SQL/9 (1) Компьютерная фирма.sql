--Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
--    Явные операции соединения
--    Простой оператор SELECT
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct Product.maker from Product
join PC on Product.model = PC.model
where PC.speed >= 450

--cost	0.021210338920355
--operations	4

-- GIT HUB
SELECT DISTINCT product.maker 
    FROM pc 
    INNER JOIN product ON pc.model = product.model 
    WHERE pc.speed >= 450 

--cost	0.021210338920355
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=9#20