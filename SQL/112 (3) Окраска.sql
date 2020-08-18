--Какое максимальное количество черных квадратов можно было бы окрасить в белый цвет
--оставшейся краской
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

--оставшиеся балончики с краской
select  V_ID, utV.V_COLOR, SUM(B_VOL) 'sum' from utB
join utV on utB.B_V_ID = utV.V_ID
group by V_ID, utV.V_COLOR
having SUM(B_VOL) < 255
-- судя по правильному ответу в 4 квадрата, наличие только 2-х черных в БД не имеет значения
-- сумма оставшейся краски
select t.V_COLOR, SUM(t.[sum]) 'sum' from (
	select  V_ID, utV.V_COLOR, SUM(B_VOL) 'sum' from utB
	join utV on utB.B_V_ID = utV.V_ID
	group by V_ID, utV.V_COLOR
	having SUM(B_VOL) < 255
) t
group by t.V_COLOR
-- минимальное количество краски одного цвета
SELECT TOP 1 WITH TIES f.[sum] / 255 FROM (
	select t.V_COLOR, SUM(t.[sum]) 'sum' from (
		select  V_ID, utV.V_COLOR, SUM(B_VOL) 'sum' from utB
		join utV on utB.B_V_ID = utV.V_ID
		group by V_ID, utV.V_COLOR
		having SUM(B_VOL) < 255
		union
		select V_ID, V_COLOR, 255 from utV where utV.V_ID not IN (select B_V_ID from utB)
	) t
	group by t.V_COLOR
) f
order by f.[sum]
--* Несовпадение данных (1)
-- так как есть полные балончики, которые ничего не красили
select * from utV where utV.V_ID not IN (select B_V_ID from utB)

SELECT MIN(f.[sum]) / 255 FROM (
	select t.V_COLOR, SUM(t.[sum]) 'sum' from (
		select  utV.V_COLOR, SUM(B_VOL) 'sum' from utB
		join utV on utB.B_V_ID = utV.V_ID
		where utB.B_V_ID NOT IN (
			select  V_ID from utB
			join utV on utB.B_V_ID = utV.V_ID
			group by V_ID
			having SUM(B_VOL) = 255
		)
		group by utV.V_COLOR
		union all
		select V_COLOR, 255 from utV where utV.V_ID not IN (select B_V_ID from utB)
	) t
	group by t.V_COLOR
) f
-- Решение -------------------------------------------------------------
SELECT top 1 f.[sum] / 255 'Qty' FROM (
	select t.V_COLOR, SUM(t.[sum]) 'sum' from (
		select  utV.V_COLOR, SUM(B_VOL) 'sum' from utB
		join utV on utB.B_V_ID = utV.V_ID
		where utB.B_V_ID NOT IN (
			select  V_ID from utB
			join utV on utB.B_V_ID = utV.V_ID
			group by V_ID
			having SUM(B_VOL) = 255
		)
		group by utV.V_COLOR
		union all
		select V_COLOR, 255 from utV where utV.V_ID not IN (select B_V_ID from utB)
		union all
		select 'I', 0 -- на случай, если вообще нет балончиков в БД
	) t
	group by t.V_COLOR
) f 

--cost	0.092571921646595
--operations	26

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=112#20
SELECT CASE WHEN R < G AND R < B THEN R/255 
       WHEN G < R AND G < B THEN G/255 ELSE
            B/255 END AS Qty
FROM
(SELECT a.R * 255 - c.V_RED AS R, a.G * 255 - c.V_GRIN AS G, a.B * 255 - c.V_BLUE AS B 
FROM
(SELECT '1' AS P,
       SUM (CASE WHEN v.V_COLOR = 'R' THEN b.B_VOL ELSE 0 END) AS V_RED,
       SUM (CASE WHEN v.V_COLOR = 'G' THEN b.B_VOL ELSE 0 END) AS V_GRIN,
       SUM (CASE WHEN v.V_COLOR = 'B' THEN b.B_VOL ELSE 0 END) AS V_BLUE
FROM utV AS v JOIN utB AS b
ON v.V_ID = b.B_V_ID) c
JOIN 
(SELECT '1' AS F, 
        SUM (CASE WHEN v.V_COLOR = 'R' THEN 1 ELSE 0 END)  AS R,
        SUM (CASE WHEN v.V_COLOR = 'G' THEN 1 ELSE 0 END)  AS G,
        SUM (CASE WHEN v.V_COLOR = 'B' THEN 1 ELSE 0 END)  AS B
FROM utV AS v) AS a
ON c.P = a.F) d

--cost 0.031304396688938
--operations 11