--Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
--Вывести: maker, максимальная цена.
--    Предложение GROUP BY
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select pr.maker, max(pc.price) from Product pr
join PC pc on pr.model = pc.model
group by pr.maker

--cost	0.024492986500263
--operations	5

-- GIT HUB
SELECT product.maker, MAX(pc.price) 
    FROM product, pc 
    WHERE product.model = pc.model 
    GROUP BY product.maker 

--cost	0.024492986500263
--operations	5

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=21#20