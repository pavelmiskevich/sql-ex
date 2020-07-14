--Найти производителей компьютерной техники, у которых нет моделей ПК, не представленных в таблице PC.
--    Предикат IN
--    Получение итоговых значений
--    Подзапросы
--    Пересечение и разность
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct maker from Product pr where maker not in (
	select distinct maker from Product p
	left join PC pc on p.model = pc.model
	where type = 'PC' and code IS NULL
)

--cost	0.048857100307941
--operations	9

-- GIT HUB
SELECT DISTINCT maker 
FROM product 
WHERE maker NOT IN ( 
     SELECT maker 
     FROM product 
     WHERE type = 'pc' and  model NOT IN (SELECT model FROM PC)
)

--cost	0.039141301065683
--operations	8

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=80#20
select maker from PRODUCT
minus
select  p.maker
from  product p
left join pc on pc.model = p.model
where p.type = 'PC' and pc.model is null;

--cost	0.0033633999992162
--operations	6