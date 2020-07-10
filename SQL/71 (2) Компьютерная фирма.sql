--Найти тех производителей ПК, все модели ПК которых имеются в таблице PC.
--    Предикат IN
--    Реляционное деление
-- Процесс -------------------------------------------------------------
SELECT maker
FROM Product
GROUP BY maker
HAVING COUNT(DISTINCT type) = 
            (SELECT COUNT(DISTINCT type) FROM Product);

SELECT maker
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(DISTINCT type) = 1
            --(SELECT COUNT(DISTINCT type) FROM Product)


SELECT distinct maker
FROM Product p
WHERE type NOT IN ('Laptop', 'Printer') AND p.model  IN (select model from PC)

SELECT distinct p.*, pc.*, l.*
FROM Product p
left join PC pc on p.model = pc.model
left join Laptop l on p.model = l.model
WHERE p.model  = ANY (select model from PC)

SELECT DISTINCT p.*
FROM Product p
WHERE p.type = 'PC' AND NOT EXISTS (
SELECT model
    FROM PC 
    WHERE model NOT IN 
              (SELECT model 
                FROM Product p2 
                WHERE p.model = p2.model
              )
)
-- Решение -------------------------------------------------------------
SELECT DISTINCT p.maker
FROM Product p
WHERE p.type = 'PC' AND NOT EXISTS (
SELECT p2.maker
    FROM Product p2
    WHERE p2.maker = p.maker AND p2.type = 'PC' AND model NOT IN 
              (SELECT model 
                FROM PC
              )
)

--cost	0.031576130539179
--operations	8

-- GIT HUB
SELECT Product.maker 
FROM Product
LEFT JOIN PC ON PC.model = Product.model 
WHERE Product.type = 'PC' 
GROUP BY Product.maker 
HAVING COUNT(Product.model) = COUNT(PC.model)

--cost	0.02772918343544
--operations	7

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=71#20
SELECT maker FROM (SELECT maker, model,
CASE WHEN model IN (select model FROM PC) 
THEN 1 ELSE 0 END as II FROM PRODUCT
WHERE type='PC') x
GROUP BY maker
HAVING count(model)=SUM(II)

--cost 0.022210285067558
--operations 7