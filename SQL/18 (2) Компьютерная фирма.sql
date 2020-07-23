--Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
--    Явные операции соединения
--    Получение итоговых значений
--    Подзапросы
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct pr.maker, pri.price from Product pr
join Printer pri on pr.model = pri.model
where pri.color = 'y' and pri.price = (select min(price) from Printer where color = 'y')

--cost	0.02134738303721
--operations	7

-- GIT HUB
SELECT distinct Product.maker, Printer.price 
FROM Product
INNER JOIN Printer On Printer.model = Product.model
where Printer.price = (SELECT MIN(price) FROM Printer WHERE Printer.color = 'y') 
AND Printer.color = 'y'

--cost	0.02134738303721
--operations	7

SELECT DISTINCT product.maker, printer.price 
    FROM product, printer 
    WHERE product.model = printer.model 
      AND printer.color = 'y' 
      AND printer.price = (SELECT MIN(price) 
                               FROM printer 
                               WHERE printer.color = 'y')

--cost	0.02134738303721
--operations	7

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=18#20