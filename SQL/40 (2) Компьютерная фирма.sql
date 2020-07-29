--Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
--Вывести: maker, type
--    Получение итоговых значений
--    Предложение GROUP BY
--    Предложение HAVING
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct maker, type from Product where maker in (
	select pr.maker from (
		select distinct maker, type from Product) pr
	group by pr.maker
	having count(pr.type) = 1
)
and
maker not in (
	select maker from Product
	group by maker
	having count(type) <= 1
)

--cost	0.052529610693455
--operations	15

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=40#20
select maker,max(type)
from product
group by maker
having count(DISTINCT type)=1 and count(model)> 1

--cost 0.015581049956381
--operations 7