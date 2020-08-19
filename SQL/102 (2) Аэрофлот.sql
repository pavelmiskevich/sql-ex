--Определить имена разных пассажиров, которые летали
--только между двумя городами (туда и/или обратно).
--    Предложение GROUP BY
--    Предложение HAVING
--    Объединение
--    Явные операции соединения
-- Процесс -------------------------------------------------------------
select pit.ID_psg, tr.town_from from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no
order by pit.ID_psg

select distinct pit.ID_psg, tr.town_from, tr.town_to from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no

select t.ID_psg, count(distinct t.town_from) from (
	select distinct pit.ID_psg, tr.town_from from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no
) t
group by t.ID_psg
having count(t.town_from) < 3

select t.ID_psg, count(t.town) from (
	select distinct pit.ID_psg, tr.town_from 'town' from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no
	union
	select distinct pit.ID_psg, tr.town_to 'town' from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no
) t
group by t.ID_psg
having count(t.town) < 3

-- Решение -------------------------------------------------------------
select pas.[name] from Passenger pas 
where pas.ID_psg IN (
	select t.ID_psg from (
		select distinct pit.ID_psg, tr.town_from 'town' from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no
		union
		select distinct pit.ID_psg, tr.town_to 'town' from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no
	) t
	group by t.ID_psg
	having count(t.town) < 3
)

--cost	0.064540527760983
--operations	14

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=102#19
select name from (
select id_psg from (
Select distinct id_psg, town_to, town_from from 
pass_in_trip pit join trip on pit.trip_no = trip.trip_no) x
group by id_psg
having (count(town_to) = 1) or 
(count(town_to) = 2 and max(town_to) = max(town_from) and min(town_to) = min(town_from))) y join passenger p on p.id_psg = y.id_psg

--cost 0.037657771259546
--operations 9