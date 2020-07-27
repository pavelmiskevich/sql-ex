--C точностью до двух десятичных знаков определить среднее количество краски на квадрате.
--    Получение итоговых значений
--    Оператор CASE
--    Преобразoвание типов
-- Процесс -------------------------------------------------------------
select Q_ID, Q_NAME from utQ --квадраты
select V_ID, V_NAME, V_COLOR from utV --балончики
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB
select B_DATETIME, B_Q_ID, B_V_ID, CONVERT(INT, B_VOL) from utB

select B_V_ID, SUM(CONVERT(INT, B_VOL)) from utB
group by B_V_ID

select B_Q_ID, SUM(B_VOL) from utB
group by B_Q_ID

select AVG(B_VOL) from utB

select Q_ID, Q_NAME from utQ where Q_ID NOT IN (select B_Q_ID from utB)

select Q_ID, SUM(CAST(B_VOL AS NUMERIC(6,2))) 'sum' from utQ
left join utB on utQ.Q_ID = utB.B_Q_ID
group by Q_ID

select Q_ID, 
CASE 
 WHEN SUM(CAST(B_VOL AS NUMERIC(6,2))) IS NULL 
 THEN 0
 ELSE SUM(CAST(B_VOL AS NUMERIC(6,2)))
END 'sum' from utQ
left join utB on utQ.Q_ID = utB.B_Q_ID
group by Q_ID
-- Решение -------------------------------------------------------------
select CAST(AVG(t.[sum]) AS NUMERIC(6,2)) 'avg_paint' from (
	select Q_ID, 
		CASE 
		 WHEN SUM(CAST(B_VOL AS NUMERIC(6,2))) IS NULL 
		 THEN 0
		 ELSE SUM(CAST(B_VOL AS NUMERIC(6,2)))
		END 'sum' from utQ
	left join utB on utQ.Q_ID = utB.B_Q_ID
	group by Q_ID
) t

--cost	0.027835380285978
--operations	8

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=91#20
SELECT CAST(1.0*ISNULL((SELECT SUM(B_VOL) FROM utB),0)/(SELECT COUNT(*) FROM UTQ) AS NUMERIC(10,2)) AVG_QTY

--cost 0.007159180007875
--operations 8