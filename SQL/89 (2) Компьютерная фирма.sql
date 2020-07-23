--Найти производителей, у которых больше всего моделей в таблице Product, а также тех, у которых меньше всего моделей.
--Вывод: maker, число моделей
--    Предложение GROUP BY
--    Предложение HAVING
--    Предикат IN
-- Процесс -------------------------------------------------------------
select maker, count(model) 'count' from Product
group by maker

select max(t.[count]) from (
	select maker, count(model) 'count' from Product
	group by maker
) t
-- Решение -------------------------------------------------------------
select maker, count(model) 'qty' from Product
group by maker
having count(model) = (
	select max(t.[count]) from (
		select maker, count(model) 'count' from Product
		group by maker
	) t
)
OR count(model) = (
	select min(t.[count]) from (
		select maker, count(model) 'count' from Product
		group by maker
	) t
)

--cost	0.059242356568575
--operations	17

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=89#20
WITH count as (SELECT maker, COUNT(model) a, MAX(COUNT(model)) over() b, MIN(COUNT(model)) over() c
FROM product
GROUP BY maker)
SELECT maker, a
FROM count
WHERE a=b or a=c

--cost 0.016102872788906
--operations 12

SELECT maker, c
FROM
(SELECT maker, count(model) c , max(count(model)) OVER() max, min(count(model)) OVER() min
FROM PRODUCT
GROUP BY  maker) d
WHERE c=max or c = min

--cost 0.016102872788906
--operations 12  

