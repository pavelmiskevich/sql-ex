--Пронумеровать уникальные пары {maker, type} из Product, упорядочив их следующим образом:
--- имя производителя (maker) по возрастанию;
--- тип продукта (type) в порядке PC, Laptop, Printer.
--Если некий производитель выпускает несколько типов продукции, то выводить его имя только в первой строке;
--остальные строки для ЭТОГО производителя должны содержать пустую строку символов ('').
--    Функция ROW_NUMBER
--    Оператор CASE
-- Процесс -------------------------------------------------------------
select distinct maker, type from Product

select distinct row_number() OVER(ORDER BY maker) num, maker, type from Product

select distinct 
	pr.maker, 
	pr.[type],  
	CASE 
		WHEN type = 'PC' THEN 1
		WHEN type = 'Laptop' THEN 2
		WHEN type = 'Printer' THEN 3
	END ord 
from Product pr
order by pr.maker, ord
-- Решение -------------------------------------------------------------
select 
	row_number() OVER(ORDER BY t.maker, t.ord) num,	
	--t.maker, 
	CASE 
		WHEN t.[type] = 'PC' and EXISTS(select 1 from Product where [type] = 'PC' and maker = t.maker) 
			THEN t.maker
		WHEN t.[type] = 'Laptop' and EXISTS(select 1 from Product where [type] = 'Laptop' and maker = t.maker) 
			AND NOT EXISTS(select 1 from Product where [type] = 'PC' and maker = t.maker) 
			THEN t.maker
		WHEN t.[type] = 'Printer' and EXISTS(select 1 from Product where [type] = 'Printer' and maker = t.maker) 
			AND NOT EXISTS(select 1 from Product where [type] = 'PC' and maker = t.maker) 
			AND NOT EXISTS(select 1 from Product where [type] = 'Laptop' and maker = t.maker) 
			THEN t.maker
		ELSE ''		
		--WHEN type = 'Laptop' THEN 2
		--WHEN type = 'Printer' THEN 3
	END maker ,
	t.[type] from (
		select distinct 
			pr.maker, 
			pr.[type],  
			CASE 
				WHEN type = 'PC' THEN 1
				WHEN type = 'Laptop' THEN 2
				WHEN type = 'Printer' THEN 3
			END ord 
		from Product pr
) t

--cost	0.087806969881058
--operations	18

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=65#20
SELECT ROW_NUMBER() OVER (ORDER BY maker, ind) num, CASE 
						    WHEN MIN(ind) OVER (PARTITION BY maker) = ind 
						    THEN maker
						    ELSE '' 
						    END maker, type
FROM
	(
	SELECT DISTINCT maker, type, CASE WHEN type = 'PC' THEN 1
					  WHEN type = 'Laptop' THEN 2
					  WHEN type = 'Printer' THEN 3 END ind
	FROM product
	)t

--cost 0.016684988513589
--operations 13
