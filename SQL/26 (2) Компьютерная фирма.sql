--Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.
--    Явные операции соединения
--    Подзапросы
--    Объединение
--    Получение итоговых значений
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select avg(av.price) AVG_price from (
	select pc.price price from PC pc
	join Product pr on pr.model = pc.model
	where pr.maker = 'A'
	union all
	select lp.price price from Laptop lp
	join Product pr on pr.model = lp.model
	where pr.maker = 'A'
) av

--cost	0.022818010300398
--operations	9

-- GIT HUB
SELECT sum(s.price)/sum(s._quantity) as _average 
    FROM (SELECT price, 1 as _quantity FROM pc, product 
              WHERE pc.model = product.model 
                AND product.maker = 'A' 
            UNION all 
            SELECT price, 1 as _quantity FROM laptop, product 
              WHERE laptop.model = product.model 
                AND product.maker = 'A'
          ) as s;

--cost	0.022819260135293
--operations	12

select sum(s.sum)/sum(s.kol)
from (select price as sum, 1 as kol from PC, Product where Product.model = PC.model and Product.maker = 'A'
	UNION ALL
	select price as sum, 1 as kol from Laptop, Product where Product.model = Laptop.model and Product.maker = 'A') as s

--cost	0.022819260135293
--operations	12

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=26#20
WITH rrr AS (
select price,model from pc
UNION ALL
select price,model from laptop )
SELECT AVG(price) FROM rrr WHERE model in (SELECT model FROM product WHERE maker='a')

--cost 0.010873403400183
--operations 7