--На основании информации из таблицы Pass_in_Trip, для каждой авиакомпании определить:
--1) количество выполненных перелетов;
--2) число использованных типов самолетов;
--3) количество перевезенных различных пассажиров;
--4) общее число перевезенных компанией пассажиров.
--Вывод: Название компании, 1), 2), 3), 4).
--    Получение итоговых значений
-- Процесс -------------------------------------------------------------
select * from Company
select distinct pit.trip_no from Pass_in_trip pit

select distinct CAST(pit.trip_no AS CHAR(4)) + CAST(pit.[date] AS CHAR(10)) from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = 5

select count(*) from (select distinct trip_no, [date] from Pass_in_trip) pit
join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = 5

select COUNT(distinct tr.plane) from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = 5

select c.[name],
	(
		select count(*) from (select distinct trip_no, [date] from Pass_in_trip) pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'flights',
	(
		select COUNT(distinct plane) from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'planes',
	(
		select COUNT(distinct ID_psg) from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'diff_psngrs',
	(
		select COUNT(ID_psg) from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'total_psngrs'
from (select distinct ID_comp, [name] from Company) c

select * from (
	select c.[name],
		(
			select COUNT(distinct CAST(pit.trip_no AS CHAR(4)) + CAST(pit.[date] AS CHAR(10))) from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'flights',
		(
			select COUNT(distinct plane) from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'planes',
		(
			select COUNT(distinct ID_psg) from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'diff_psngrs',
		(
			select COUNT(ID_psg) from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'total_psngrs'
	from Company c
) t
where t.flights > 0 and t.planes > 0 and t.diff_psngrs > 0 and t.total_psngrs > 0
--Ваш запрос вернул правильные данные на основной базе, но не прошел тест на проверочной базе.
--* Несовпадение данных (4)

select c.[name],
	(
		select COUNT(distinct CAST(pit.trip_no AS CHAR(4)) + CAST(pit.[date] AS CHAR(10))) from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'flights',
	(
		select COUNT(distinct plane) from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'planes',
	(
		select COUNT(distinct ID_psg) from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'diff_psngrs',
	(
		select COUNT(ID_psg) from Pass_in_trip pit
		join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
	) 'total_psngrs'
from Company c
--Ваш запрос вернул правильные данные на основной базе, но не прошел тест на проверочной базе.
--* Неверное число записей (больше на 6)
-- Решение -------------------------------------------------------------
select * from (
	select c.[name],
		(
			select count(*) from (select distinct trip_no, [date] from Pass_in_trip) pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'flights',
		(
			select COUNT(distinct plane) from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'planes',
		(
			select COUNT(distinct ID_psg) from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'diff_psngrs',
		(
			select COUNT(ID_psg) from Pass_in_trip pit
			join Trip tr on pit.trip_no = tr.trip_no and tr.ID_comp = c.ID_comp
		) 'total_psngrs'
	from Company c
) t
where t.flights > 0 and t.planes > 0 and t.diff_psngrs > 0 and t.total_psngrs > 0

--cost	0.16081142425537
--operations	38

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=95#20
select (select name from company where id_comp = t.id_comp) company_name
       , count(distinct concat(pit.trip_no, date)) flights
       , count(distinct plane) planes
       , count(distinct id_psg) diff_psg
       , count(id_psg) total_psg
from pass_in_trip pit
join trip t on pit.trip_no = t.trip_no
group by id_comp;

--cost 0.11068703234196
--operations 31

WITH
q AS (
SELECT Trip.trip_no as trip, ID_comp, plane, date, ID_psg, place, Town_from, town_to, time_out, time_in FROM Pass_in_trip JOIN Trip ON Pass_in_trip.trip_no=Trip.trip_no
),
q1 AS (
SELECT q.trip, date, ID_Comp, plane FROM q GROUP BY trip, date, ID_Comp, plane
),
q2 AS (
SELECT ID_comp, count(trip) as flights , count(DISTINCT plane) as planes  FROM q1 GROUP BY ID_comp
),
q5 AS (
SELECT ID_comp, count(DISTINCT ID_psg) as diff_psngrs, count(ID_psg) as total_psgrs FROM q GROUP BY ID_comp
)
SELECT (SELECT name FROM Company WHERE ID_comp=q2.ID_comp) as company_name, flights, planes, diff_psngrs, total_psgrs FROM q2 JOIN q5 ON q2.ID_comp=q5.ID_comp

--cost 0.062644459307194
--operations 20

with x as(
select id_comp,
row_number() over(partition by id_comp,date,t.trip_no order by date)fl,
row_number() over(partition by id_comp,plane order by plane) pl,
row_number() over(partition by id_comp,id_psg order by id_psg) dp 
from pass_in_trip pit
join trip t
on pit.trip_no = t.trip_no)
select (select name from Company where id_comp = x.id_comp) company,
sum(case when fl = 1 then 1 else 0 end) fl,
sum(case when pl = 1 then 1 else 0 end) pl,
sum(case when dp = 1 then 1 else 0 end) dp,
count(dp) p 
from x
group by id_comp

--cost 0.057146154344082
--operations 17