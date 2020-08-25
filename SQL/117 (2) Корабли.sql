--По таблице Classes для каждой страны найти максимальное значение среди трех выражений:
--numguns*5000, bore*3000, displacement.
--Вывод в три столбца:
--- страна;
--- максимальное значение;
--- слово `numguns` - если максимум достигается для numguns*5000, слово `bore` - если максимум достигается для bore*3000, слово `displacement` - если максимум достигается для displacement.
--Замечание. Если максимум достигается для нескольких выражений, выводить каждое из них отдельной строкой.
--    Предложение GROUP BY
--    CROSS APPLY
-- Процесс -------------------------------------------------------------
select country, numguns*5000 'ng', bore*3000 'b', displacement 'dis' from  Classes cl
-- Решение -------------------------------------------------------------
WITH T ([country], [max_val], [name]) AS 
(
	select country, max(numguns*5000) 'max_val', 'numguns' 'name' from  Classes cl
	group by country
	union all
	select country, max(bore*3000), 'bore' from  Classes cl
	group by country
	union all
	select country, max(displacement), 'displacement' from  Classes cl
	group by country
)
select t.country, t.max_val,
f.[name]
from (
	select T.country, max(T.max_val) 'max_val' from T
	group by T.country
) t
join (
	select T.country, T.[name], T.max_val from T 
) f on f.country = t.country and f.max_val = t.max_val

--cost	0.0681988671422
--operations	32

-- GIT HUB


--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=117#19
WITH T AS (
  SELECT C.COUNTRY,X.V,X.N, RANK() OVER (PARTITION BY COUNTRY ORDER BY V DESC) RN
    FROM CLASSES C
      CROSS APPLY 
      (VALUES(numguns*5000, 'numguns')
            ,(bore*3000,'bore')
            ,(displacement,'displacement')) X (V, N)
)
SELECT DISTINCT COUNTRY,V,N FROM T WHERE RN=1

--cost 0.028658950701356
--operations 9

select distinct country, x, y from (
select *, max(x) over(partition by country) z from (
Select country, numguns*5000 x, 'numguns' y from classes
union all 
Select country, bore*3000, 'bore' from classes
union all
Select country, displacement, 'displacement' from classes
) A ) B 
where x=z

--cost 0.024458019062877
--operations 17