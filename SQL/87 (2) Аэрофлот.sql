--Считая, что пункт самого первого вылета пассажира является местом жительства, найти не москвичей, которые прилетали в Москву более одного раза.
--Вывод: имя пассажира, количество полетов в Москву
--    Явные операции соединения
--    Предложение GROUP BY
--    Подзапросы
--    Предложение HAVING
-- Процесс -------------------------------------------------------------
select trip_no, ID_comp, plane, town_from, town_to, time_out, time_in from Trip
select trip_no, [date], ID_psg, place from Pass_in_trip

select ID_psg, trip_no, min([date]) from Pass_in_trip
group by ID_psg, trip_no

-- первая дата вылета
select ID_psg, min([date]) from Pass_in_trip
group by ID_psg

select t.ID_psg, tr.town_from from Trip tr
join(
	select pit.ID_psg, pit.trip_no, pit.[date] from Pass_in_trip pit
	join(
		select ID_psg, min([date]) 'date' from Pass_in_trip
		group by ID_psg
	) tt on pit.ID_psg = tt.ID_psg and pit.[date] = tt.[date]
) t on tr.trip_no = t.trip_no

select t.ID_psg, min(t.[date]) 'date' from (
	select pit.ID_psg, tr.trip_no, min(pit.[date]) 'date', min(tr.time_out) 'time_out' from Trip tr
	join Pass_in_trip pit on tr.trip_no = pit.trip_no
	group by pit.ID_psg, tr.trip_no
) t
group by t.ID_psg, t.trip_no

select t.ID_psg, pit.trip_no from Pass_in_trip pit
join (
	select ID_psg, min([date]) 'date' from Pass_in_trip
	group by ID_psg
) t on pit.ID_psg = t.ID_psg and pit.[date] = t.[date]

-- пассажир и номер первого рейса
select pit.ID_psg, min(pit.[date]) 'date', min(tr.time_out) 'time_out' from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
group by pit.ID_psg

select pit.ID_psg, MIN(
	DATEADD(hh, DATEPART(HOUR, tr.time_out), DATEADD(minute, DATEPART(MINUTE ,tr.time_out), pit.[date])) 
)
from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no
group by pit.ID_psg

select pit.ID_psg, CAST(tr.time_out AS time(7)) from Pass_in_trip pit join Trip tr on pit.trip_no = tr.trip_no

select pit.ID_psg, MIN(pit.[date] + cast(CAST(tr.time_out AS time(7)) as datetime)) 'datetime'
from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no
group by pit.ID_psg

select t.ID_psg, tr.town_from, t.[time] from (
	select pit.ID_psg, MIN(pit.[date] + cast(CAST(tr.time_out AS time(7)) as datetime)) 'time'
	from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no
	group by pit.ID_psg
) t 
join Trip tr on cast(CAST(t.[time] AS time(7)) as datetime) = tr.time_out
join Pass_in_trip pit on t.ID_psg = pit.ID_psg and CAST(CAST(t.[time] as date) as datetime) = pit.[date]

-- город первого вылета
select pit.ID_psg, min(pit.[date]) 'date', min(tr.time_out) 'time_out' from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
group by pit.ID_psg
order by pit.ID_psg

select pit.ID_psg, tr.town_from from Pass_in_trip pit
left join Trip tr on pit.trip_no = tr.trip_no
join (
	select pit.ID_psg, tr.trip_no, tr.town_from, min(pit.[date]) 'date', min(tr.time_out) 'time_out' from Trip tr
	join Pass_in_trip pit on tr.trip_no = pit.trip_no
	group by pit.ID_psg, tr.trip_no, tr.town_from
) t on pit.ID_psg = t.ID_psg and pit.[date] = t.[date] and tr.time_out = t.time_out

--------------------------------
select pit.ID_psg, pit.[date], tr.time_out, pit.[date] + tr.time_out 'time_out' from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
--order by pit.ID_psg
group by pit.ID_psg

select pit.ID_psg, min(pit.[date] + tr.time_out) 'time_out' from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
--order by pit.ID_psg
group by pit.ID_psg

-- дата и время первого вылета
select pit.ID_psg, min(pit.[date] + tr.time_out) 'time_out' from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
group by pit.ID_psg
-- не москвичи
--WITH T AS (
--	select pit.ID_psg, pas.[name], tr.trip_no, tr.town_from, tr.town_to, pit.[date] + tr.time_out 'time_out' from Trip tr
--	join Pass_in_trip pit on tr.trip_no = pit.trip_no
--	join Passenger pas on pit.ID_psg = pas.ID_psg
--)
-- Решение -------------------------------------------------------------
WITH T (ID_psg, time_out)
AS (
	select pit.ID_psg, min(pit.[date] + tr.time_out) 'time_out' from Trip tr
	join Pass_in_trip pit on tr.trip_no = pit.trip_no
	group by pit.ID_psg
),
T_all (ID_psg, [name], town_from, town_to, time_out)
AS (
	select pit.ID_psg, pas.[name], tr.town_from, tr.town_to, pit.[date] + tr.time_out 'time_out' from Trip tr
	join Pass_in_trip pit on tr.trip_no = pit.trip_no
	join Passenger pas on pit.ID_psg = pas.ID_psg
)
select f.* from (
	select T_all.[name],
	(
		select count(time_out) from T_all where T_all.ID_psg = T.ID_psg and T_all.town_to  = 'Moscow'
	) 'Qty'
	from T_all
	join T on T.ID_psg = T_all.ID_psg and T.time_out = T_all.time_out
	where T_all.town_from <> 'Moscow'
) f
where f.Qty > 1

--cost	0.10153029859066
--operations	24

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=87#20
SELECT MIN(p.name) name, SUM( CASE WHEN t.town_to = 'Moscow' THEN 1 ELSE 0 END ) to_msk_qty
FROM Pass_in_trip i JOIN Trip t ON i.trip_no = t.trip_no JOIN Passenger p ON i.ID_psg = p.ID_psg
GROUP BY i.ID_psg
HAVING MIN( i.date + t.time_out ) <>  MIN( CASE WHEN t.town_from = 'Moscow' THEN i.date + t.time_out ELSE '3000-12-31 23:59:59' END )
AND SUM( CASE WHEN t.town_to = 'Moscow' THEN 1 ELSE 0 END) >  1

--cost 0.056269772350788
--operations 9   