--Определить пассажиров, которые больше других времени провели в полетах.
--Вывод: имя пассажира, общее время в минутах, проведенное в полетах
--    Явные операции соединения
--    Получение итоговых значений
--    Функции T-SQL для работы c датами
--    Использование ключевых слов ANY, ALL с предикатами сравнения
-- Процесс -------------------------------------------------------------
DATEDIFF(mi, time_out, time_in)

select pit.ID_psg, t.time_out, time_in from Pass_in_trip pit
join Trip t on pit.trip_no = t.trip_no

select pit.ID_psg, 
	SUM(
		CASE   
			  WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
			  WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
		END
	) time_in_min
from Pass_in_trip pit
join Trip t on pit.trip_no = t.trip_no
group by pit.ID_psg
-- Решение -------------------------------------------------------------
select top 1 WITH TIES p.[name], t.time_in_min from (
	select pit.ID_psg, 
		SUM(
			CASE   
				  WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
				  WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
			END
		) time_in_min
	from Pass_in_trip pit
	join Trip t on pit.trip_no = t.trip_no
	group by pit.ID_psg
) t 
join Passenger p on t.ID_psg = p.ID_psg
order by t.time_in_min desc

--cost	0.048696778714657
--operations	11

-- GIT HUB
SELECT Passenger.name, T.minutes
FROM (
	SELECT Pass_in_trip.ID_psg,
	SUM((DATEDIFF(minute, time_out, time_in) + 1440)%1440) AS minutes,
	MAX(SUM((DATEDIFF(minute, time_out, time_in) + 1440)%1440)) OVER() AS MaxMinutes
	FROM Pass_in_trip
    INNER JOIN Trip ON Pass_in_trip.trip_no = Trip.trip_no
    GROUP BY Pass_in_trip.ID_psg
) AS T INNER JOIN Passenger ON Passenger.ID_psg = T.ID_psg
WHERE T.minutes = T.MaxMinutes

--cost	0.038143638521433
--operations	17

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=79#20
with a (ID_psg, min, max_min, name) as (Select ID_psg, SUM(sum_min) AS min, 
max(SUM(sum_min)) over() AS max_min,
(select name from Passenger where Passenger.ID_psg=ps.ID_psg) as name 
FROM Pass_in_trip AS ps
INNER JOIN (
SELECT
  trip_no,
  CASE 
  WHEN t.time_in < t.time_out 
  THEN DATEDIFF(mi, t.time_out, DATEADD(day, 1, t.time_in)) 
  ELSE DATEDIFF(mi, t.time_out, t.time_in) 
  END sum_min
 FROM Trip AS t
) AS fl ON ps.trip_no= fl.trip_no
GROUP BY ps.ID_psg)
select name, min from a 
where min=max_min

--cost 0.030744407325983
--operations 18