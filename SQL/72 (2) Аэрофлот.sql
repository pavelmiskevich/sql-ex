--Среди тех, кто пользуется услугами только какой-нибудь одной компании, определить имена разных пассажиров, летавших чаще других.
--Вывести: имя пассажира и число полетов.
--    Явные операции соединения
--    Предложение GROUP BY
--    Подзапросы
--    Предложение HAVING
-- Процесс -------------------------------------------------------------
SELECT pit.ID_psg, count(t.ID_Comp) from Pass_in_trip pit
join Passenger p on pit.ID_psg = p.ID_psg
join Trip t on pit.trip_no = t.trip_no
GROUP BY pit.ID_psg
HAVING count(t.ID_Comp) = 1
2, 9, 12
14, 37

SELECT pit.ID_psg, count(t.ID_Comp) from Pass_in_trip pit
join Passenger p on pit.ID_psg = p.ID_psg
join Trip t on pit.trip_no = t.trip_no
GROUP BY pit.ID_psg

-- летающие одной компанией
SELECT r.ID_psg FROM (
SELECT DISTINCT pit.ID_psg, t.ID_Comp from Pass_in_trip pit
join Trip t on pit.trip_no = t.trip_no
) r
GROUP BY r.ID_psg
HAVING COUNT(r.ID_Comp) = 1

SELECT TOP(1) WITH TIES p.name
-- Решение -------------------------------------------------------------
SELECT TOP 1 WITH TIES p.name, f.[count] from (
	SELECT pit.ID_psg, COUNT(pit.trip_no) [count] from Pass_in_trip pit
	WHERE pit.ID_psg IN (
		SELECT r.ID_psg FROM (
			SELECT DISTINCT pit.ID_psg, t.ID_Comp from Pass_in_trip pit
			join Trip t on pit.trip_no = t.trip_no
		) r
	GROUP BY r.ID_psg
	HAVING COUNT(r.ID_Comp) = 1
	)
	GROUP BY pit.ID_psg
	) f
join Passenger p on f.ID_psg = p.ID_psg
ORDER BY f.count DESC

--cost	0.063286073505878
--operations	16

-- GIT HUB
SELECT TOP 1 WITH TIES name, maxs FROM passenger
INNER JOIN (
	SELECT passengerID, max(counts) maxs FROM ( 
		SELECT pass_in_trip.ID_psg passengerID, Trip.ID_comp, count(*) counts FROM pass_in_trip
		INNER JOIN trip ON trip.trip_no = pass_in_trip.trip_no
		GROUP BY pass_in_trip.ID_psg, Trip.ID_comp
	) AS R GROUP BY passengerID HAVING count(*) = 1
) AS R1 ON ID_psg = passengerID ORDER BY maxs DESC

--cost	0.048622667789459
--operations	13

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=72#20
WITH asd 
     AS (SELECT pt.id_psg, 
                Count(pt.trip_no) cnt, 
                Max(Count(pt.trip_no)) over () cmax 
         FROM   pass_in_trip pt 
                JOIN trip t ON t.trip_no = pt.trip_no 
         GROUP  BY pt.id_psg 
         HAVING Max(t.id_comp) = Min(t.id_comp)) 
SELECT p.name, a.cnt 
FROM   asd a 
       JOIN passenger p ON p.id_psg = a.id_psg 
WHERE  a.cnt = a.cmax   

--cost 0.036938302218914
--operations 17