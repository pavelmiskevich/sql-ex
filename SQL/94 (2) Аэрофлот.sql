--Для семи последовательных дней, начиная от минимальной даты, когда из Ростова было совершено максимальное число рейсов, определить число рейсов из Ростова.
--Вывод: дата, количество рейсов
--    Функция DATEADD
--    Генерация числовой последовательности
--    Получение итоговых значений
--    Явные операции соединения
-- Процесс -------------------------------------------------------------
select trip_no, ID_comp, plane, town_from, town_to, time_out, time_in from Trip
--количество рейсов из Ростова
select pit.[date], count(pit.trip_no)  from (
	select distinct trip_no, [date] from Pass_in_trip
) pit
join Trip tr on tr.trip_no = pit.trip_no and town_from = 'Rostov'
group by pit.[date]

--минимальная дата с максимальным количеством рейсов
SELECT TOP 1 WITH TIES t.[date] FROM (
	select pit.[date], count(pit.trip_no) 'count'  from (
		select distinct trip_no, [date] from Pass_in_trip
	) pit
	join Trip tr on tr.trip_no = pit.trip_no and town_from = 'Rostov'
	group by pit.[date]
) t
order by t.[count] DESC, t.[date]
-- генерация числовой последовательности
WITH dates ([Date], [count]) AS 
(
    SELECT TOP 1 WITH TIES t.[date] 'Date', 1 FROM (
		select pit.[date], count(pit.trip_no) 'count'  from (
			select distinct trip_no, [date] from Pass_in_trip
		) pit
		join Trip tr on tr.trip_no = pit.trip_no and town_from = 'Rostov'
		group by pit.[date]
	) t
	order by t.[count] DESC, t.[date]
    UNION ALL
    SELECT DATEADD(d,1,[Date]), [count] + 1
    FROM dates 
	WHERE [count] < 7
)
select d.* from dates d
-- Решение -------------------------------------------------------------
WITH dates ([Date], [count]) AS 
(
    SELECT TOP 1 WITH TIES t.[date] 'Date', 1 FROM (
		select pit.[date], count(pit.trip_no) 'count'  from (
			select distinct trip_no, [date] from Pass_in_trip
		) pit
		join Trip tr on tr.trip_no = pit.trip_no and town_from = 'Rostov'
		group by pit.[date]
	) t
	order by t.[count] DESC, t.[date]
    UNION ALL
    SELECT DATEADD(d,1,[Date]), [count] + 1
    FROM dates 
	WHERE [count] < 7
)
SELECT d.[Date] 'Dt', count(pit.trip_no) FROM dates d
left join (	
	select distinct Pass_in_trip.trip_no, [date] from Pass_in_trip
	join Trip on Trip.trip_no = Pass_in_trip.trip_no and town_from = 'Rostov'
) pit on d.[Date] = pit.[date]
group by d.[Date]

--cost	0.068928733468056
--operations	29

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=94#20
with cte as
(
		select 
		date, count(distinct pt.trip_no) cnt, max(count(distinct pt.trip_no)) over() m

		 from pass_in_trip pt join trip t on pt.trip_no = t.trip_no
		where town_from = 'Rostov'
		group by date  
),
dd as
(
	select min(date) date, 1 rn from cte where m=cnt
	union all
	select dateadd(d, 1, date), rn+1 from dd
		where rn < 7
)
select dd.date, isnull(c.cnt, 0) from dd left join cte c on dd.date = c.date 

--cost 0.031936034560204
--operations 12