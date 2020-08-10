--Для каждого производителя подсчитать: сколько имеется в наличии его продуктов (любого типа) с неуникальной для этого производителя ценой и количество таких неуникальных цен.
--Вывод: производитель, количество продуктов, количество цен.
-- Процесс -------------------------------------------------------------
select maker, model, [type] from Product
-- Решение -------------------------------------------------------------
WITH T AS (
select maker, count(price) 'c' from (
		select pr.maker, price from Product pr
		join PC pc on pr.model = pc.model
		union all
		select pr.maker, price from Product pr
		join Laptop lp on pr.model = lp.model
		union all
		select pr.maker, price from Product pr
		join Printer p on pr.model = p.model
	) t
	group by maker, price
	having count(price) > 1
)
select f.maker,
	COALESCE((select sum(T.c) from T where T.maker = f.maker), 0) 'cou',
	COALESCE((select count(T.c) from T where T.maker = f.maker), 0)  'cou2'
from (
	select distinct maker from Product
) f

--cost	1.4165140390396
--operations	73

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=123#20
select maker,sum(n2),count(n3) from (
select maker, case when n > 1 then n else 0 end n2,
case when n > 1 then 1 else null end n3 from (
select maker, price, count(code) n from product p left join
(select code, model, price from pc where price is not null
union all
select code, model, price from laptop where price is not null
union all
select code, model, price from printer where price is not null) x on p.model = x.model
group by maker, price) y) x
group by maker 

--cost 0.046764325350523
--operations 11

--cost 0.0048555000685155
--operations 12