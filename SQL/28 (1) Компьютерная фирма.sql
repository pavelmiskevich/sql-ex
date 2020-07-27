--Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
--    Предложение GROUP BY
--    Предложение HAVING
--    Подзапросы
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select count(u.maker) from (
	select distinct maker from Product 
	group by maker
	having count(model) = 1
) u

--cost	0.015512922778726
--operations	7

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=28#20