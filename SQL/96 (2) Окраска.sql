--При условии, что баллончики с красной краской использовались более одного раза, выбрать из них такие, которыми окрашены квадраты, имеющие голубую компоненту.
--Вывести название баллончика
--    Использование в запросе нескольких источников записей
--    Получение итоговых значений
--    Подзапросы
-- Процесс -------------------------------------------------------------
select Q_ID, Q_NAME from utQ --квадраты
select V_ID, V_NAME, V_COLOR from utV --балончики
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB where B_V_ID IN (1, 10, 17,31,34) order by B_V_ID
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB where B_Q_ID IN (4,6,8)
select V_ID, V_NAME, V_COLOR from utV where V_ID IN (18,19,37,38)
select B_DATETIME, B_Q_ID, B_V_ID, B_VOL from utB where B_Q_ID = 6

-- баллончики с красной краской использовались более одного раза
select B_V_ID from utB
join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'R'
group by B_V_ID
having count(B_DATETIME) > 1

--квадраты с голубой компонентой
select distinct B_Q_ID from utB
join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'B'

select utV.V_NAME from utB
join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'R'
where utB.B_Q_ID IN (
	select B_Q_ID from utB
	join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'B'
)
group by utV.V_NAME
having count(utB.B_DATETIME) > 1

select distinct utV.V_NAME from utQ
join utB on utQ.Q_ID = utB.B_Q_ID
join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'B' and utV.V_ID IN (
	select B_V_ID from utB
	join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'R'
	group by B_V_ID
	having count(B_DATETIME) > 1
)
-- Решение -------------------------------------------------------------
select distinct utV.V_NAME from utB
join utV on utB.B_V_ID = utV.V_ID
where utB.B_V_ID IN (
	select B_V_ID from utB
	join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'R'
	group by B_V_ID
	having count(B_DATETIME) > 1
) and
utB.B_Q_ID IN (
	select B_Q_ID from utB
	join utV on utB.B_V_ID = utV.V_ID and utV.V_COLOR = 'B'
)

--cost	0.11639422178268
--operations	16

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=96#20
WITH T AS (
SELECT U.*, V.*,
  MAX(CASE WHEN V.V_COLOR = 'B' THEN 1 ELSE 0 END) OVER (PARTITION BY U.B_Q_ID) BLUE_F,
  COUNT(*) OVER (PARTITION BY U.B_V_ID) USES_COUNT
  FROM UTV V
  JOIN UTB U ON U.B_V_ID = V.V_ID
)
SELECT DISTINCT T.V_NAME
  FROM T
  WHERE T.V_COLOR = 'R'
    AND BLUE_F = 1
    AND USES_COUNT > 1

--cost 0.081814751029015
--operations 24