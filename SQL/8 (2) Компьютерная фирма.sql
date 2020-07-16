--Найдите производителя, выпускающего ПК, но не ПК-блокноты.
--    Пересечение и разность
--    Предикат IN
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct maker from Product
where maker in (
	select maker from Product where type = 'PC') 
and maker not in (
	select maker from Product where type = 'Laptop')

--cost	0.046980120241642
--operations	8

select distinct maker from Product where type = 'PC'
EXCEPT
select distinct maker from Product where type = 'Laptop'

--cost	0.02127343788743
--operations	5

-- GIT HUB
SELECT DISTINCT maker 
    FROM product 
    WHERE type = 'pc' 
  EXCEPT 
    SELECT DISTINCT product.maker 
        FROM product 
        WHERE type = 'laptop' ; 

--cost	0.02127343788743
--operations	5

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=8#20
SELECT DISTINCT maker
FROM Product
WHERE type IN ('Laptop', 'PC')
GROUP BY maker
EXCEPT
SELECT DISTINCT maker
FROM Product
WHERE type = 'Laptop'

--cost	0.02241056971252
--operations	5