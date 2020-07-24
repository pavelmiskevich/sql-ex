--Вывести все строки из таблицы Product, кроме трех строк с наименьшими номерами моделей и трех строк с наибольшими номерами моделей.
--    Предикат IN
--    Ограничение количества строк, возвращаемых запросом
-- Процесс -------------------------------------------------------------
select maker, model, [type] from Product

select maker, model, [type] from Product
where model not in (
select top 3 model from Product order by model
)
and model not in (
select top 3 model from Product order by model desc
)
-- Решение -------------------------------------------------------------
select maker, model, [type] from Product
where model not in (
select top 3 model from Product order by model
)
and model not in (
select top 3 model from Product order by model desc
)

--cost	0.027597999200225
--operations	7

-- GIT HUB
SELECT maker, model, type FROM
(
	SELECT maker, model, type,
	row_number() over(ORDER BY model) first,
	row_number() over(ORDER BY model DESC) second
	FROM Product
) R
WHERE first > 3 AND second > 3

--cost	0.015521478839219
--operations	7

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=90#20
SELECT
 t.maker,
 t.model,
 t.type
FROM (
 SELECT
  ROW_NUMBER() OVER (ORDER BY model) AS n,
  COUNT(1) OVER () AS cnt,
  *
 FROM Product
) AS t
WHERE t.n BETWEEN 4 AND (cnt - 3)

--cost 0.0048555000685155
--operations 12