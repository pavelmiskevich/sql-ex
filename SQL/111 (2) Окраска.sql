--Найти НЕ белые и НЕ черные квадраты, которые окрашены разными цветами в пропорции 1:1:1. Вывод: имя квадрата, количество краски одного цвета
--    Оператор CASE
--    Подзапросы
--    Предложение GROUP BY
-- Процесс -------------------------------------------------------------
select Q_ID, Q_NAME from utQ --квадраты
select V_ID, V_NAME, V_COLOR from utV --балончики
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB

-- белые квадраты
select B_Q_ID from utB
group by B_Q_ID
having SUM(B_VOL) = 765
union
-- черные квадраты
select B_Q_ID from utB
group by B_Q_ID
having SUM(B_VOL) = 0
union
select Q_ID from utQ
where Q_ID NOT IN (select B_Q_ID from utB)
-- белые и черные квадраты 
select Q_ID from utQ
left join utB on utQ.Q_ID = utB.B_Q_ID
group by Q_ID
having SUM(B_VOL) = 0 or SUM(B_VOL) = 255 * 3 or SUM(B_VOL) IS NULL

--окрашены
select  B_Q_ID, utV.V_COLOR, SUM(B_VOL) 'sum' from utB
join utV on utB.B_V_ID = utV.V_ID
group by B_Q_ID, utV.V_COLOR
order by B_Q_ID
-- Решение -------------------------------------------------------------
WITH T AS (
	select  B_Q_ID, utV.V_COLOR, SUM(B_VOL) 'sum' from utB
	join utV on utB.B_V_ID = utV.V_ID
	where B_Q_ID NOT IN (
		select B_Q_ID from utB
		group by B_Q_ID
		having SUM(B_VOL) = 765
		union
		select B_Q_ID from utB
		group by B_Q_ID
		having SUM(B_VOL) = 0
		union
		select Q_ID from utQ
		where Q_ID NOT IN (select B_Q_ID from utB)
	)
	group by B_Q_ID, utV.V_COLOR	
) 
select distinct utQ.Q_NAME, 
(select top 1 T.[sum] from T where T.B_Q_ID = utQ.Q_ID)
from T
join utQ on T.B_Q_ID = utQ.Q_ID
where 
(select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'R') = (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'G')
and (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'G') = (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'B')

--cost	0.6413893699646
--operations	119

-- оптимизирован список белых и черных квадратов
WITH T AS (
	select  B_Q_ID, utV.V_COLOR, SUM(B_VOL) 'sum' from utB
	join utV on utB.B_V_ID = utV.V_ID
	where B_Q_ID NOT IN (
		select Q_ID from utQ
		left join utB on utQ.Q_ID = utB.B_Q_ID
		group by Q_ID
		having SUM(B_VOL) = 0 or SUM(B_VOL) = 255 * 3 or SUM(B_VOL) IS NULL
	)
	group by B_Q_ID, utV.V_COLOR	
) 
select distinct utQ.Q_NAME, 
(select top 1 T.[sum] from T where T.B_Q_ID = utQ.Q_ID)
from T
join utQ on T.B_Q_ID = utQ.Q_ID
where 
(select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'R') = (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'G')
and (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'G') = (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'B')

--cost	0.63549453020096
--operations	88

--оптизирован, так как не нужно черные квадраты не попадут в выборку
WITH T AS (
	select  B_Q_ID, utV.V_COLOR, SUM(B_VOL) 'sum' from utB
	join utV on utB.B_V_ID = utV.V_ID
	where B_Q_ID NOT IN (
		select B_Q_ID from utB
		group by B_Q_ID
		having SUM(B_VOL) = 255 * 3
	)
	group by B_Q_ID, utV.V_COLOR	
) 
select distinct utQ.Q_NAME, 
(select top 1 T.[sum] from T where T.B_Q_ID = utQ.Q_ID)
from T
join utQ on T.B_Q_ID = utQ.Q_ID
where 
(select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'R') = (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'G')
and (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'G') = (select T.[sum] from T where T.B_Q_ID = utQ.Q_ID and T.V_COLOR = 'B')

--cost	0.51148670911789
--operations	69

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=111#20
WITH T AS (
  SELECT B_Q_ID,
       SUM(CASE WHEN V_COLOR = 'R' THEN B_VOL ELSE 0 END) R,
       SUM(CASE WHEN V_COLOR = 'G' THEN B_VOL ELSE 0 END) G,
       SUM(CASE WHEN V_COLOR = 'B' THEN B_VOL ELSE 0 END) B
  FROM UTB B
    JOIN UTV V ON V.V_ID = B.B_V_ID
  GROUP BY B_Q_ID
)
SELECT Q_NAME, R QTY
  FROM T
    JOIN UTQ Q ON Q.Q_ID = T.B_Q_ID
  WHERE R=G AND G=B AND R!=255 AND R!=0

--cost	0.046082105487585
--operations	8

select q_name, max(b_vol)
from(
select q_name, V_COLOR, sum(B_VOL) B_VOL from utb 
join utq on utb.B_Q_ID=utq.Q_ID 
join utv on utb.B_V_ID=utv.V_ID
group by q_name, V_COLOR) sub
group by q_name
having sum(b_vol)<765 and max(b_vol)=avg(b_vol) and min(b_vol)=avg(b_vol) and count(*)=3

--cost 0.066900186240673
--operations 10