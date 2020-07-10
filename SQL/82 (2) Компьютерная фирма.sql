--В наборе записей из таблицы PC, отсортированном по столбцу code (по возрастанию) найти среднее значение цены для каждой шестерки подряд идущих ПК.
--Вывод: значение code, которое является первым в наборе из шести строк, среднее значение цены в наборе.
--    Нумерация строк результатов запроса
--    Получение итоговых значений
-- Процесс -------------------------------------------------------------
select code, model, speed, ram, hd, cd, price from PC order by code
select code, price from PC order by code
select ROW_NUMBER() OVER(ORDER BY code) [no], code, price from PC 
select ROW_NUMBER() OVER(ORDER BY code), code from PC
select ROW_NUMBER() OVER(ORDER BY code) no, code, price from PC
select ROW_NUMBER() OVER(ORDER BY code) [no], code from PC

select t.num, t.code from (
select ROW_NUMBER() OVER(ORDER BY code) num, code from PC
) t
where t.num <= (select count(1) - 5 from PC)

select r.price from (
select ROW_NUMBER() OVER(ORDER BY code), price from PC
) r
where r.num >= t.num and r.num < t.num + 5
-- Решение -------------------------------------------------------------
select t.code, 
(
	(select AVG(r.price) from (
		select ROW_NUMBER() OVER(ORDER BY code) num, price from PC
	) r
	where r.num >= t.num and r.num <= t.num + 5)
) avgprс 
from (
	select ROW_NUMBER() OVER(ORDER BY code) num, code from PC
) t
where t.num <= (
	select count(1) - 5 from PC
)

--cost	0.013008926995099
--operations	16

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=82#20
Select code,avg from (Select ROW_NUMBER() OVER (ORDER BY code) as number,code,AVG(p.price) over (Order by p.code ROWS between CURRENT ROW AND 5 FOLLOWING) as avg FROM PC as p) as t where t.number<=(select count(code)-5 from PC)

--cost	0.0071284398436546
--operations	21

WITH T AS (
SELECT ROW_NUMBER() OVER (ORDER BY CODE) RN, P.CODE, P.PRICE
  FROM PC P
)
SELECT T1.CODE, AVG(T2.PRICE)
  FROM T T1
    JOIN T T2 ON T1.RN   <= T2.RN 
             AND T1.RN+6 >   T2.RN
  WHERE T1.RN < (SELECT COUNT(*) FROM PC)-4
  GROUP BY T1.CODE

--cost 0.00436832010746
--operations 26