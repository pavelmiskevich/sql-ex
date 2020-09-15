--Для ПК с максимальным кодом из таблицы PC вывести все его характеристики (кроме кода) в два столбца:
--- название характеристики (имя соответствующего столбца в таблице PC);
--- значение характеристики
--    Объединение данных из двух столбцов в один
--    Преобразoвание типов
--    Операторы PIVOT и UNPIVOT
--    CHAR и VARCHAR
-- Процесс -------------------------------------------------------------
SELECT maker, -- столбец (столбцы), значения из которого формируют заголовки строк
[pc], [laptop], [printer] -- значения из столбца, который указан в предложении type, 
-- формирующие заголовки столбцов 
FROM Product -- здесь может быть подзапрос
PIVOT -- формирование пивот-таблицы
(COUNT(model) -- агрегатная функция, формирующая содержимое сводной таблицы
FOR type -- указывается столбец, 
-- уникальные значения в котором будут являться заголовками столбцов
IN([pc], [laptop], [printer]) --указываются конкретные значения в столбце type, 
 -- которые следует использовать в качестве заголовков, 
 -- т.к. нам могут потребоваться не все
) pvt ;-- алиас для сводной таблицы

SELECT model, speed, ram, hd, null 'cd', price, screen FROM Laptop WHERE code = (SELECT MAX(code) FROM Laptop)
union
SELECT model, speed, ram, hd, cd, price, null 'screen' FROM PC WHERE code = (SELECT MAX(code) FROM PC)

SELECT [chr], [value] FROM ( 
	SELECT CAST(model AS VARCHAR) model, 
		CAST(speed AS VARCHAR) speed, 
		CAST(ram AS VARCHAR) ram, 
		CAST(hd AS VARCHAR) hd, 
		CAST(cd AS VARCHAR) cd, 
		CAST(price AS VARCHAR) price 
	FROM PC WHERE code = (SELECT MAX(code) FROM PC)
) x 
UNPIVOT( [value] 
FOR [chr] IN (model, speed, ram, hd, cd, price) 
) unpvt;

SELECT MAX(code) FROM (
	select code from Laptop
	union
	select code from PC
) t

SELECT [chr], [value] FROM ( 
	SELECT CAST(model AS VARCHAR) model, 
		CAST(speed AS VARCHAR) speed, 
		CAST(ram AS VARCHAR) ram, 
		CAST(hd AS VARCHAR) hd, 
		CAST(cd AS VARCHAR) cd, 
		CAST(price AS VARCHAR) price 
	FROM PC WHERE code = (
		SELECT MAX(code) FROM (
			select code from Laptop
			union
			select code from PC
		) t
	)
	union all
	SELECT CAST(model AS VARCHAR) model, 
		CAST(speed AS VARCHAR) speed, 
		CAST(ram AS VARCHAR) ram, 
		CAST(hd AS VARCHAR) hd, 		
		CAST(price AS VARCHAR) price,
		CAST(screen AS VARCHAR) screen
	FROM Laptop WHERE code = (
		SELECT MAX(code) FROM (
			select code from Laptop
			union
			select code from PC
		) t
	)
) x 
UNPIVOT( [value] 
FOR [chr] IN (model, speed, ram, hd, cd, price) 
) unpvt
UNION ALL
SELECT [chr], [value] FROM ( 
	SELECT CAST(model AS VARCHAR) model, 
		CAST(speed AS VARCHAR) speed, 
		CAST(ram AS VARCHAR) ram, 
		CAST(hd AS VARCHAR) hd, 		
		CAST(price AS VARCHAR) price,
		CAST(screen AS VARCHAR) screen
	FROM Laptop WHERE code = (
		SELECT MAX(code) FROM (
			select code from Laptop
			union
			select code from PC
		) t
	)
) x 
UNPIVOT( [value] 
FOR [chr] IN (model, speed, ram, hd, price, screen) 
) unpvt

SELECT [chr], [value] FROM ( 
	SELECT CAST(model AS VARCHAR) model, 
		CAST(speed AS VARCHAR) speed, 
		CAST(ram AS VARCHAR) ram, 
		CAST(hd AS VARCHAR) hd, 
		CAST(cd AS VARCHAR) cd, 
		CAST(ISNULL(price, 0) AS VARCHAR) price 
	FROM PC WHERE code = (
		SELECT MAX(code) FROM (
			select code from Laptop
			union
			select code from PC
		) t
	)
) x 
UNPIVOT( [value] 
FOR [chr] IN (model, speed, ram, hd, cd, price) 
) unpvt
-- Решение -------------------------------------------------------------
SELECT [chr], NULLIF([value], '0.00') [value] FROM ( 
	SELECT CAST(model AS VARCHAR(50)) model, 
		CAST(speed AS VARCHAR(50)) speed, 
		CAST(ram AS VARCHAR(50)) ram, 
		CAST(hd AS VARCHAR(50)) hd, 
		CAST(cd AS VARCHAR(50)) cd, 
		CAST(COALESCE(price, '0.00') AS VARCHAR(50)) price --ISNULL(price, '0.00')
	FROM PC WHERE code = (
		SELECT MAX(code) FROM PC			
	)
) x 
UNPIVOT( [value] 
FOR [chr] IN (model, speed, ram, hd, cd, price) 
) unpvt

--cost	0.0033173570409417
--operations	7

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=146#20
Select col, vol from
(Select 
isnull(cast(model as varchar(50)),'') model , 
isnull(cast(speed as varchar(50)),'') speed, 
isnull(cast(ram as varchar(50)),'') ram, 
isnull(cast(hd as varchar(50)),'') hd, 
isnull(cast(cd as varchar(50)),'') cd, 
isnull(cast(price as varchar(50)),'') price  from PC
where code=(select max(code) from PC))  a
UNPIVOT 
(vol
for col in (model, speed, ram, hd, cd, price)
) pvt 

--cost 0.0033168171066791
--operations 6
WITH topc AS
	(
	SELECT TOP(1) *
	FROM pc
	ORDER BY code DESC
	)
SELECT chr
	, CASE chr WHEN 'model' THEN model 
		   WHEN 'speed' THEN CAST(speed AS VARCHAR)
		   WHEN  'ram'  THEN CAST(ram AS VARCHAR)
		   WHEN   'hd'  THEN CAST(hd AS VARCHAR)
		   WHEN   'cd'  THEN CAST(cd AS VARCHAR) 
		   WHEN 'price' THEN CAST(price AS VARCHAR) END AS value
FROM topc, (VALUES ('model'), ('speed'), ('ram'), ('hd'), ('cd'), ('price')) AS v(chr)

--cost 0.0033150371164083
--operations 5