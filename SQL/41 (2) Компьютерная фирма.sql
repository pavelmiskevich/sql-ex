--Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
--определить максимальную цену на его продукцию.
--Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
--иначе максимальную цену.
--    Получение итоговых значений
--    Предложение GROUP BY
--    Объединение
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select pr.maker, max(u.price) from product pr, 
(
	select p.maker, pc.model, pc.price from PC pc
	join Product p on p.model = pc.model
	union
	select p.maker, lp.model, lp.price from Laptop lp
	join Product p on p.model = lp.model
	union
	select p.maker, pri.model, pri.price from Printer pri
	join Product p on p.model = pri.model
) u
where pr.maker = u.maker and pr.maker not in (
	select p.maker from PC pc
	join Product p on p.model = pc.model
	where pc.price IS NULL
	union
	select p.maker from Laptop lp
	join Product p on p.model = lp.model
	where lp.price IS NULL
	union
	select p.maker from Printer pri
	join Product p on p.model = pri.model
	where pri.price IS NULL
)
group by pr.maker
union
select distinct n.maker, NULL as 'm_price' from
(
	select p.maker from PC pc
	join Product p on p.model = pc.model
	where pc.price IS NULL
	union
	select p.maker from Laptop lp
	join Product p on p.model = lp.model
	where lp.price IS NULL
	union
	select p.maker from Printer pri
	join Product p on p.model = pri.model
	where pri.price IS NULL
) n

--cost	0.15750414133072
--operations	39

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=39#20
with cte as (

select
  model,
  price
from
  pc

union all

select
  model,
  price
from
  laptop

union all

select
  model,
  price
from
  printer

)

select
  maker,
  case when count(price) = count(*) then max(price) end
from
  product
inner join
  cte
on
  product.model = cte.model
group by
  maker

--cost 0.038436122238636
--operations 10