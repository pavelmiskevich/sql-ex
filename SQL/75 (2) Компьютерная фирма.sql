--Для тех производителей, у которых есть продукты с известной ценой хотя бы в одной из таблиц Laptop, PC, Printer найти максимальные цены на каждый из типов продукции.
--Вывод: maker, максимальная цена на ноутбуки, максимальная цена на ПК, максимальная цена на принтеры.
--Для отсутствующих продуктов/цен использовать NULL.
--    Получение итоговых значений
--    Явные операции соединения
--    Оператор COALESCE
-- Процесс -------------------------------------------------------------
SELECT p.maker, pc.price, l.price, pr.price from Product p
left join PC pc on p.model = pc.model
left join Laptop l on p.model = l.model
left join Printer pr on p.model = pr.model

SELECT p.maker, pc.price, l.price, pr.price from Product p
left join PC pc on p.model = pc.model
left join Laptop l on p.model = l.model
left join Printer pr on p.model = pr.model
--where pc.price IS NULL AND l.price IS NULL AND pr.price IS NULL
-- Решение -------------------------------------------------------------
SELECT p.maker, MAX(l.price), MAX(pc.price), MAX(pr.price) from Product p
left join PC pc on p.model = pc.model
left join Laptop l on p.model = l.model
left join Printer pr on p.model = pr.model
where pc.price IS NOT NULL OR l.price IS NOT NULL OR pr.price IS NOT NULL
GROUP BY p.maker

--cost	0.080200098454952
--operations	10

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=75#19
select PRODUCT.MAKER,
       MAX(case PRODUCT.TYPE when 'Laptop' then devices.PRICE  end) AS laptop,   
       MAX(case PRODUCT.TYPE when 'PC' then devices.PRICE  end) AS pc,
       MAX(case PRODUCT.TYPE when 'Printer' then devices.PRICE  end) AS printer
from (
select PC.MODEL, PC.PRICE from PC
union all
select LAPTOP.MODEL, LAPTOP.PRICE from LAPTOP
union all
select  PRINTER.MODEL, PRINTER.PRICE from PRINTER) devices
JOIN PRODUCT ON devices.MODEL = PRODUCT.MODEL 
group by PRODUCT.MAKER
having sum(devices.PRICE) is not NULL

--cost 0.03844391554594
--operations 10