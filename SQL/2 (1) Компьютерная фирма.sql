--Найдите производителей принтеров. Вывести: maker
--    Простой оператор SELECT
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct maker from Product where type = 'Printer'

--cost	0.014886102639139
--operations	2

-- GIT HUB
SELECT maker FROM Product WHERE type = 'Printer' GROUP BY maker

--cost	0.014886102639139
--operations	2

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=2#20
