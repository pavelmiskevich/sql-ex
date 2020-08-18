--Среди тех, кто пользуется услугами только одной компании, определить имена разных пассажиров, летавших чаще других.
--Вывести: имя пассажира, число полетов и название компании.
--    Явные операции соединения
--    Получение итоговых значений
--    Подзапросы
-- Процесс -------------------------------------------------------------
-- пользующие услугами одной компании (считается количество полетов)
select pit.ID_psg from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no
group by pit.ID_psg
having count(tr.ID_comp) = 1

-- пользующие услугами одной компании
select t.ID_psg from (
	select distinct pit.ID_psg, tr.ID_comp from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no
) t
group by t.ID_psg
having count(t.ID_comp) = 1

-- количество полетов пасажиров
select cf.ID_psg, 
(
	select count(*) from (select distinct trip_no, [date] from Pass_in_trip where ID_psg = cf.ID_psg) t1
) 'count'
from (
	select t.ID_psg from (
		select distinct pit.ID_psg, tr.ID_comp from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no
	) t
	group by t.ID_psg
	having count(t.ID_comp) = 1
) cf

-- летающие чаще друших
SELECT TOP 1 WITH TIES tf.ID_psg, tf.[count] FROM (
	select cf.ID_psg, 
	(
		select count(*) from (select distinct trip_no, [date] from Pass_in_trip where ID_psg = cf.ID_psg) t1
	) 'count'
	from (
		select t.ID_psg from (
			select distinct pit.ID_psg, tr.ID_comp from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no
		) t
		group by t.ID_psg
		having count(t.ID_comp) = 1
	) cf
) tf 
order by tf.[count] DESC

select distinct pas.[name], f.[count], 
(
	select top 1 c.[name] from Company c
	join Trip tr on tr.ID_comp = c.ID_comp
	join Pass_in_trip pit on pit.trip_no = tr.trip_no and pit.ID_psg = f.ID_psg
) 'company'
from (
	SELECT TOP 1 WITH TIES tf.ID_psg, tf.[count] FROM (
		select cf.ID_psg, 
		(
			select count(*) from (select distinct trip_no, [date] from Pass_in_trip where ID_psg = cf.ID_psg) t1
		) 'count'
		from (
			select t.ID_psg from (
				select distinct pit.ID_psg, tr.ID_comp from Pass_in_trip pit
				join Trip tr on pit.trip_no = tr.trip_no
			) t
			group by t.ID_psg
			having count(t.ID_comp) = 1
		) cf
	) tf 
	order by tf.[count] DESC
) f
join Passenger pas on f.ID_psg = pas.ID_psg

select pit.ID_psg, count(pit.trip_no) from Pass_in_trip pit
where pit.ID_psg IN (
	select pit.ID_psg from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no
	group by pit.ID_psg
	having count(tr.ID_comp) = 1
)
group by pit.ID_psg

SELECT TOP 1 WITH TIES t.ID_psg, t.[count] FROM (
	select pit.ID_psg, count(pit.trip_no) [count] from Pass_in_trip pit
	where pit.ID_psg IN (
		select pit.ID_psg from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no
		group by pit.ID_psg
		having count(tr.ID_comp) = 1
	)
	group by pit.ID_psg
) t 
order by t.[count] DESC

select distinct pas.[name], f.[count], c.[name] 'company'
from (
	SELECT TOP 1 WITH TIES t.ID_psg, t.[count] FROM (
		select pit.ID_psg, count(pit.[date] + tr.time_out) [count] from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no
		where pit.ID_psg IN (
			select t.ID_psg from (
				select distinct pit.ID_psg, tr.ID_comp from Pass_in_trip pit
				join Trip tr on pit.trip_no = tr.trip_no
			) t
			group by t.ID_psg
			having count(t.ID_comp) = 1
		)
		group by pit.ID_psg
	) t 
	order by t.[count] DESC
) f
join Passenger pas on f.ID_psg = pas.ID_psg
join Pass_in_trip pit on pas.ID_psg = pit.ID_psg
join Trip tr on pit.trip_no = tr.trip_no
join Company c on tr.ID_comp = c.ID_comp
-- Решение -------------------------------------------------------------
select pas.[name], f.[count], f.[name] 'company'
from (
	SELECT TOP 1 WITH TIES t.ID_psg, t.[name], t.[count] FROM (
		select pit.ID_psg, c.[name], count(pit.[date] + tr.time_out) [count] from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no
		join Company c on tr.ID_comp = c.ID_comp
		where pit.ID_psg IN (
			select t.ID_psg from (
				select distinct pit.ID_psg, tr.ID_comp from Pass_in_trip pit
				join Trip tr on pit.trip_no = tr.trip_no
			) t
			group by t.ID_psg
			having count(t.ID_comp) = 1
		)
		group by pit.ID_psg, c.[name]
	) t 
	order by t.[count] DESC
) f
join Passenger pas on f.ID_psg = pas.ID_psg

--cost	0.086220718920231
--operations	20

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=88#20
SELECT
 (SELECT name FROM Passenger AS p WHERE p.ID_psg = t.ID_psg) AS name,
 t.cnt AS trip_Qty,
 (SELECT name FROM Company AS c WHERE c.ID_comp = t.ID_comp) AS Company
FROM (
 SELECT
  pit.ID_psg,
  MAX(ID_comp) AS ID_comp,
  COUNT(1) AS cnt,
  MAX(COUNT(1)) OVER () AS max_cnt
 FROM Pass_in_trip AS pit INNER JOIN Trip AS t ON t.trip_no = pit.trip_no
 GROUP BY pit.ID_psg
 HAVING MIN(ID_comp) = MAX(ID_comp)
) AS t
WHERE t.cnt = t.max_cnt

--cost 0.032826144248247
--operations 21