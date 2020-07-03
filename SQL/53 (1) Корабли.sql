--Определите среднее число орудий для классов линейных кораблей.
--Получить результат с точностью до 2-х десятичных знаков.
--    Получение итоговых значений
--    Преобразование типов
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select STR(avg(convert(real, cl.numGuns)), 5, 2) avgguns from Classes cl
where cl.type = 'bb'

--cost	0.0033378337975591
--operations	5

-- GIT HUB
select CAST(
	AVG(CAST(numGuns as numeric(6,2))
	) AS NUMERIC(6,2)) 
from Classes where type = 'bb'
   
--cost	0.0033378337975591
--operations	5