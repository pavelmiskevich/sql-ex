--Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
--    Подзапросы
--    Получение итоговых значений
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct Printer.model, Printer.price from Printer
join (
	select max(price) as price from Printer) pr on Printer.price = pr.price

--cost	0.018071383237839
--operations	5

select distinct Printer.model, Printer.price from Printer
where price = (
	select max(price) as price from Printer)

--cost	0.018071383237839
--operations	5

-- GIT HUB
SELECT model, price 
    FROM printer 
    WHERE price = ( SELECT MAX(price) FROM printer ) 

--cost	0.0067100999876857
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=10#20