--Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза.
--    Подзапросы
--    Предложение GROUP BY
--    Предложение HAVING
-- Процесс -------------------------------------------------------------
select pit.ID_psg, count(pit.place) from Pass_in_trip pit
group by pit.ID_psg
having count(pit.place) > 1
--join Pass_in_trip pit on pit.ID_psg = p.ID_psg

select pit.ID_psg, pit.trip_no, pit.place from Pass_in_trip pit

select p.name from Passenger p
join (
select pit.ID_psg, pit.place, count(pit.trip_no) from Pass_in_trip pit
group by pit.ID_psg, pit.place
having count(pit.trip_no) > 1
) pp on p.ID_psg = pp.ID_psg
-- Решение -------------------------------------------------------------
select p.name from Passenger p
where p.ID_psg IN (
select pit.ID_psg from Pass_in_trip pit
group by pit.ID_psg, pit.place
having count(pit.trip_no) > 1
)

--cost	0.020551634952426
--operations	8

-- GIT HUB
SELECT name FROM Passenger
WHERE ID_psg IN (
	SELECT ID_psg FROM Pass_in_trip 
	GROUP BY place,ID_psg HAVING count(*) >1 
)

--cost	0.020551634952426
--operations	8