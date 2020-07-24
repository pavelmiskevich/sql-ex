--Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
--    Объединение
--    Получение итоговых значений
--    Подзапросы
--    CTE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
WITH model_maxprice(model, price) AS ( 
  select model, price from PC where price = (
			select max(price) from PC )
		union
		select model, price from Laptop where price = (
			select max(price) from Laptop )
		union
		select model, price from Printer where price = (
			select max(price) from Printer ) 
	) 
select model from model_maxprice where price >= ALL( SELECT price FROM model_maxprice)

--cost	0.039348676800728
--operations	28

select model from PC where price = (
	select max(u.price) from (
		select model, price from PC where price = (
			select max(price) from PC )
		union
		select model, price from Laptop where price = (
			select max(price) from Laptop )
		union
		select model, price from Printer where price = (
			select max(price) from Printer ) 
	) u
)
union
select model from Laptop where price = (
	select max(u.price) from (
		select model, price from PC where price = (
			select max(price) from PC )
		union
		select model, price from Laptop where price = (
			select max(price) from Laptop )
		union
		select model, price from Printer where price = (
			select max(price) from Printer ) 
	) u
)
union
select model from Printer where price = (
	select max(u.price) from (
		select model, price from PC where price = (
			select max(price) from PC )
		union
		select model, price from Laptop where price = (
			select max(price) from Laptop )
		union
		select model, price from Printer where price = (
			select max(price) from Printer ) 
	) u
)

--cost	0.1166524887085
--operations	53

-- GIT HUB
SELECT model 
    FROM (SELECT model, price FROM pc 
          UNION 
          SELECT model, price FROM Laptop 
          UNION 
          SELECT model, price FROM Printer
          ) t1 
    WHERE price = (SELECT MAX(price) 
                       FROM (SELECT price FROM pc 
                             UNION 
                             SELECT price FROM Laptop 
                             UNION 
                             SELECT price FROM Printer
                             ) t2 
                   )

--cost	0.043487202376127
--operations	12

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=24#20
SELECT TOP (1) WITH TIES model FROM (
SELECT model, price   FROM [Laptop]
union
SELECT model, price   FROM [PC]
union
SELECT model, price   FROM [Printer]) a
ORDER BY price desc

--cost 0.020739758387208
--operations 10