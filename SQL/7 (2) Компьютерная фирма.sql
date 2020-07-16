--Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
--    Объединение
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct PC.model, PC.price from Product
join PC on Product.model = PC.model
where maker = 'B'
union
select distinct Laptop.model, Laptop.price from Product
join Laptop on Product.model = Laptop.model
where maker = 'B'
union
select distinct Printer.model, Printer.price from Product
join Printer on Product.model = Printer.model
where maker = 'B'

--cost	0.072484165430069
--operations	14

-- GIT HUB
SELECT DISTINCT product.model, pc.price 
    FROM Product JOIN pc ON product.model = pc.model WHERE maker = 'B' 
    UNION 
    SELECT DISTINCT product.model, laptop.price 
        FROM product JOIN laptop ON product.model = laptop.model WHERE maker = 'B' 
        UNION 
        SELECT DISTINCT product.model, printer.price 
            FROM product JOIN printer ON product.model = printer.model WHERE maker = 'B'; 

--cost	0.072484046220779
--operations	14

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=7#20
SELECT A.model, A.price FROM (SELECT model, price
FROM pc
UNION
SELECT model, price
FROM laptop
UNION
SELECT model, price
FROM printer) AS A INNER JOIN  
product ON product.model=A.model
WHERE maker='B'

--cost	0.038351092487574
--operations	7