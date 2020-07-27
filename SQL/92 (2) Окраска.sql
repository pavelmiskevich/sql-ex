--Выбрать все белые квадраты, которые окрашивались только из баллончиков,
--пустых к настоящему времени. Вывести имя квадрата
--    Получение итоговых значений
--    Оператор CASE
--    Подзапросы
-- Процесс -------------------------------------------------------------
select Q_ID, Q_NAME from utQ --квадраты
select V_ID, V_NAME, V_COLOR from utV --балончики
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB
select B_DATETIME, B_Q_ID, B_V_ID, CONVERT(INT, B_VOL) from utB

-- белые квадраты
select B_Q_ID from utB
group by B_Q_ID
having SUM(B_VOL) = 765

--пустые балончики
select B_V_ID from utB
group by B_V_ID
having SUM(B_VOL) = 255

--квадраты, которые красились не пустыми балончиками
select B_Q_ID from utB where B_V_ID IN (
	select B_V_ID from utB
	group by B_V_ID
	having SUM(B_VOL) < 255
)
-- Решение -------------------------------------------------------------
select distinct utQ.Q_NAME from utQ
join utB on utQ.Q_ID = utB.B_Q_ID and utB.B_Q_ID IN (
	select B_Q_ID from utB
	group by B_Q_ID
	having SUM(B_VOL) = 765
) and utB.B_Q_ID NOT IN (
	select B_Q_ID from utB where B_V_ID IN (
		select B_V_ID from utB
		group by B_V_ID
		having SUM(B_VOL) < 255
	)
)

--cost	0.045870304107666
--operations	17

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=91#20
SELECT (SELECT Q_NAME FROM utQ WHERE Q_ID = a.B_Q_ID) FROM (SELECT B_Q_ID FROM utB GROUP BY B_Q_ID HAVING SUM(B_VOL) = 765
EXCEPT
SELECT DISTINCT B_Q_ID FROM utB
WHERE B_V_ID IN(SELECT B_V_ID FROM utB GROUP BY B_V_ID HAVING SUM(B_VOL) != 255)) AS a

--cost 0.029257301241159
--operations 14