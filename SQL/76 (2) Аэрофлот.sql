--Определить время, проведенное в полетах, для пассажиров, летавших всегда на разных местах. Вывод: имя пассажира, время в минутах.
--    Явные операции соединения
--    Предложение GROUP BY
--    Предложение HAVING
--    Функция DATEDIFF
-- Процесс -------------------------------------------------------------
select pit.ID_psg, pit.place, count(pit.trip_no), count(t.place) from Pass_in_trip pit
join (select DISTINCT ID_psg, place from Pass_in_trip) t on t.ID_psg = pit.ID_psg
group by pit.ID_psg, pit.place

select t.ID_psg, t.trip_count, t2.place_count from (
select pit.ID_psg, count(pit.trip_no) trip_count from Pass_in_trip pit
group by pit.ID_psg
) t
join (
select pit.ID_psg, count(pit.place) place_count from (select DISTINCT ID_psg, place from Pass_in_trip) pit
group by pit.ID_psg
) t2 on t2.ID_psg = t.ID_psg

select t.ID_psg, t.trip_count, t2.place_count from (
select pit.ID_psg, count(pit.trip_no) trip_count from Pass_in_trip pit
group by pit.ID_psg
) t
join (
select pit.ID_psg, count(pit.place) place_count from (select DISTINCT ID_psg, place from Pass_in_trip) pit
group by pit.ID_psg
) t2 on t2.ID_psg = t.ID_psg
where t.trip_count = t2.place_count

select pas.name, SUM(DATEDIFF(mi, time_out, time_in)) from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
join Passenger pas on pit.ID_psg = pas.ID_psg
where pit.ID_psg IN (
select t.ID_psg from (
select pit.ID_psg, count(pit.trip_no) trip_count from Pass_in_trip pit
group by pit.ID_psg
) t
join (
select pit.ID_psg, count(pit.place) place_count from (select DISTINCT ID_psg, place from Pass_in_trip) pit
group by pit.ID_psg
) t2 on t2.ID_psg = t.ID_psg
where t.trip_count = t2.place_count
)
group by pas.name

select pas.name, 
SUM(
CASE   
      WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
      WHEN time_out > time_in THEN DATEDIFF(mi, time_in, time_out)
END
)
from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
join Passenger pas on pit.ID_psg = pas.ID_psg
where pit.ID_psg IN (
select t.ID_psg from (
select pit.ID_psg, count(pit.trip_no) trip_count from Pass_in_trip pit
group by pit.ID_psg
) t
join (
select pit.ID_psg, count(pit.place) place_count from (select DISTINCT ID_psg, place from Pass_in_trip) pit
group by pit.ID_psg
) t2 on t2.ID_psg = t.ID_psg
where t.trip_count = t2.place_count
)
group by pas.name


Kevin Costner       	868

-- определение разных мест сравнением количества путешествий и количества мест
select pas.name, 
SUM(
CASE   
      WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
      WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
END
)
from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
join Passenger pas on pit.ID_psg = pas.ID_psg
where pit.ID_psg IN (
select t.ID_psg from (
select pit.ID_psg, count(pit.trip_no) trip_count from Pass_in_trip pit
group by pit.ID_psg
) t
join (
select pit.ID_psg, count(pit.place) place_count from (select DISTINCT ID_psg, place from Pass_in_trip) pit
group by pit.ID_psg
) t2 on t2.ID_psg = t.ID_psg
where t.trip_count = t2.place_count
)
group by pas.name

-- определение разных мест сравнением количества мест и количества уникальных мест
select pas.name, 
SUM(
CASE   
      WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
      WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
END
)
from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
join Passenger pas on pit.ID_psg = pas.ID_psg
where pit.ID_psg IN (
select t.ID_psg from (
select pit.ID_psg, count(pit.place) trip_count from Pass_in_trip pit
group by pit.ID_psg
) t
join (
select pit.ID_psg, count(pit.place) place_count from (select DISTINCT ID_psg, place from Pass_in_trip) pit
group by pit.ID_psg
) t2 on t2.ID_psg = t.ID_psg
where t.trip_count = t2.place_count
)
group by pas.name

select DISTINCT pit.ID_psg from Pass_in_trip pit 
group by pit.ID_psg, pit.place
having count(pit.place) > 1
-- Решение -------------------------------------------------------------
select pas.Name, t.minutes from Passenger pas
join (
	select pit.ID_psg, 
	SUM(
	CASE   
		  WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
		  WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
	END
	) minutes
	from Trip tr
	join Pass_in_trip pit on tr.trip_no = pit.trip_no
	--join Passenger pas on pit.ID_psg = pas.ID_psg
	where pit.ID_psg NOT IN (
		select DISTINCT pit.ID_psg from Pass_in_trip pit 
		group by pit.ID_psg, pit.place
		having count(pit.place) > 1
	)
group by pit.ID_psg
) t on t.ID_psg = pas. ID_psg

--cost	0.057971034198999
--operations	16

select pas.name, t.minutes from Passenger pas
join (
	select pit.ID_psg, 
	SUM(
	CASE   
		  WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
		  WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
	END
	) minutes
	from Trip tr
	join Pass_in_trip pit on tr.trip_no = pit.trip_no
	--join Passenger pas on pit.ID_psg = pas.ID_psg
	where pit.ID_psg IN (
		select t.ID_psg from (
		select pit.ID_psg, count(pit.trip_no) trip_count from Pass_in_trip pit
		group by pit.ID_psg
	) t
join (
		select pit.ID_psg, count(pit.place) place_count from (select DISTINCT ID_psg, place from Pass_in_trip) pit
		group by pit.ID_psg
	) t2 on t2.ID_psg = t.ID_psg
where t.trip_count = t2.place_count
)
group by pit.ID_psg
) t on t.ID_psg = pas.ID_psg

--cost	0.079824037849903
--operations	22

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=76#20
SELECT 
 (SELECT name FROM Passenger WHERE id_psg = pit.id_psg) AS name,
 SUM(dur) AS minutes 
FROM Pass_in_trip AS pit INNER JOIN (
 SELECT 
  trip_no,
  CASE 
  WHEN t.time_in < t.time_out 
  THEN DATEDIFF(mi, t.time_out, DATEADD(day, 1, t.time_in)) 
  ELSE DATEDIFF(mi, t.time_out, t.time_in) 
  END dur
 FROM Trip AS t
) AS fl_dur ON pit.trip_no = fl_dur.trip_no
GROUP BY pit.id_psg
HAVING COUNT(DISTINCT pit.place) = COUNT(pit.id_psg)

--cost 0.03013002872467
--operations 13