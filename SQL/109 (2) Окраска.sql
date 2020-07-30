--1. Названия всех квадратов черного или белого цвета.
--2. Общее количество белых квадратов.
--3. Общее количество черных квадратов.
--    Явные операции соединения
--    Получение итоговых значений
--    Оконные функции
-- Процесс -------------------------------------------------------------
select Q_ID, Q_NAME from utQ --квадраты
select V_ID, V_NAME, V_COLOR from utV --балончики
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB where B_Q_ID IN (23,25)

-- белые квадраты
select B_Q_ID from utB
group by B_Q_ID
having SUM(B_VOL) = 765

-- черные квадраты
select B_Q_ID from utB
group by B_Q_ID
having SUM(B_VOL) = 0
union
select Q_ID from utQ
where Q_ID NOT IN (select B_Q_ID from utB)

WITH T AS (
select B_Q_ID, 'W' 'c' from utB
group by B_Q_ID
having SUM(B_VOL) = 765
union
select B_Q_ID, 'B' from utB
group by B_Q_ID
having SUM(B_VOL) = 0
union
select Q_ID, 'B' from utQ
where Q_ID NOT IN (select B_Q_ID from utB)
)
select 
Q_NAME,
(select count(B_Q_ID) from T where c = 'W') 'Whites',
(select count(B_Q_ID) from T where c = 'B') 'Blacks'
from T
join utQ on Q_ID = B_Q_ID
-- Решение -------------------------------------------------------------
WITH T AS (
select B_Q_ID, 'W' 'c' from utB
group by B_Q_ID
having SUM(B_VOL) = 765
union
select B_Q_ID, 'B' from utB
group by B_Q_ID
having SUM(B_VOL) = 0
union
select Q_ID, 'B' from utQ
where Q_ID NOT IN (select B_Q_ID from utB)
)
select 
Q_NAME,
(select count(B_Q_ID) from T where c = 'W') 'Whites',
(select count(B_Q_ID) from T where c = 'B') 'Blacks'
from T
join utQ on Q_ID = B_Q_ID

--cost	0.13616061210632
--operations	41

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=109#20
select q_name, count(sum_b_vol) over() as whites, count(*) over()  - count(sum_b_vol) over() as blacks
from (
	select q_name, sum(b_vol) as sum_b_vol
	from utB
	right join utQ on utB.b_q_id = utQ.q_id 
	group by q_name
	having sum(b_vol) = 255*3 or sum(b_vol) is null
	) as foo;

--cost 0.042757138609886
--operations 16

WITH T AS (
SELECT B_Q_ID Q, 
       SUM(B_VOL) S_Q 
  FROM UTB U
 GROUP BY B_Q_ID
)
SELECT Q_NAME,
       COUNT(S_Q) OVER() WHITES,
       COUNT(*) OVER() - COUNT(S_Q) OVER() BLACKS
  FROM UTQ
   LEFT JOIN T ON T.Q=UTQ.Q_ID
WHERE T.Q IS NULL OR T.S_Q = 765

--cost 0.027961499989033
--operations 16