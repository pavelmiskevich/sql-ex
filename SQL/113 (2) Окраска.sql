--Сколько каждой краски понадобится, чтобы докрасить все Не белые квадраты до белого цвета.
--Вывод: количество каждой краски в порядке (R,G,B)
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

--окрашены не полностью
select Q_ID from utQ
left join utB on utQ.Q_ID = utB.B_Q_ID
group by Q_ID
having SUM(B_VOL) < 255 * 3 or SUM(B_VOL) IS NULL

-- не учтены квадраты, в которых нет какой-либо краски
select B_Q_ID, utV.V_COLOR, 255 - SUM(B_VOL) 'sum' from utB
join utV on utB.B_V_ID = utV.V_ID
group by B_Q_ID, utV.V_COLOR
having SUM(B_VOL) < 255
union 
select Q_ID, 'R', 255 from utQ where utQ.Q_ID not IN (select B_Q_ID from utB)
union 
select Q_ID, 'G', 255 from utQ where utQ.Q_ID not IN (select B_Q_ID from utB)
union 
select Q_ID, 'B', 255 from utQ where utQ.Q_ID not IN (select B_Q_ID from utB)

-- полная комбинация квадратов с цветами
select Q_ID, V_COLOR from utQ
cross join (select distinct V_COLOR from utV) t

select Q_ID, V_COLOR from utQ, (select distinct V_COLOR from utV) t

select distinct Q_ID, V_COLOR from utQ, utV
-- нужная краска для докрашивания, включая неокрашенные каким-то цветом
select distinct t.Q_ID, t.V_COLOR, 
255 - (
	select COALESCE(sum(B_VOL), 0) from utB
	join utV on utB.B_V_ID = utV.V_ID
	where utV.V_COLOR = t.V_COLOR and utB.B_Q_ID = t.Q_ID
) 'sum'
from (
	select distinct Q_ID, V_COLOR from utQ, utV
) t
-- Решение -------------------------------------------------------------
WITH T AS (
	select distinct t.Q_ID, t.V_COLOR, 
	255 - (
		select COALESCE(sum(B_VOL), 0) from utB
		join utV on utB.B_V_ID = utV.V_ID
		where utV.V_COLOR = t.V_COLOR and utB.B_Q_ID = t.Q_ID
	) 'sum'
	from (
		select distinct Q_ID, V_COLOR from utQ, utV
	) t
) 
select distinct
	(select sum(T.[sum]) from T where T.V_COLOR = 'R') 'Red',
	(select sum(T.[sum]) from T where T.V_COLOR = 'G') 'Green',
	(select sum(T.[sum]) from T where T.V_COLOR = 'B') 'Blue'
from T

--cost	0.50145590305328
--operations	45

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=113
with cte as (
select V_COLOR, b_vol from utb 
join utv on utb.B_V_ID = utv.V_ID
)

select sum(R), sum(G), sum(B) from (
select 255 R, 255 G, 255 B from utq
union all
select -[R],-[G],-[B] from cte
PIVOT(sum(b_vol) for v_color in ([R],[G],[B])) pvt
) z

--cost 0.031195715069771
--operations 11