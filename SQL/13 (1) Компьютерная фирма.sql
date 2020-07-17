--Найдите среднюю скорость ПК, выпущенных производителем A.
--    Получение итоговых значений
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select avg(speed) from PC
join Product on PC.model = Product.model
where maker = 'A'

--cost	0.012801639735699
--operations	5

-- GIT HUB
SELECT AVG(pc.speed) 
    FROM pc, product 
    WHERE pc.model = product.model AND product.maker = 'A' 

--cost	0.012801639735699
--operations	5

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=13#20