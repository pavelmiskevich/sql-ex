--Для каждой компании, перевозившей пассажиров, подсчитать время, которое провели в полете самолеты с пассажирами.
--Вывод: название компании, время в минутах.
--    Функция DATEDIFF
--    Оператор CASE
--    Получение итоговых значений
--    Явные операции соединения
-- Процесс -------------------------------------------------------------
select c.[name], 
SUM(
		CASE   
			  WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
			  WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
		END
	) 'minutes'
from Company c
join Trip tr on tr.ID_comp = c.ID_comp and tr.trip_no IN (
	select trip_no from Pass_in_trip
)
group by c.[name]

select tr.trip_no, 
SUM(
		CASE   
			  WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
			  WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
		END
	) 'minutes'
from Trip tr 
where tr.trip_no IN (
	select pit.trip_no from Pass_in_trip pit
)
group by tr.trip_no

select tr.trip_no, time_in, time_out, DATEDIFF(mi, time_out, time_in)
from Trip tr 
join Company c on c.ID_comp = tr.ID_comp and c.[name] = 'Aeroflot '
join Pass_in_trip pit on tr.trip_no = pit.trip_no
where tr.trip_no IN (
	select trip_no from Pass_in_trip
)
-- Решение -------------------------------------------------------------
select c.[name], 
SUM(
		CASE   
			  WHEN time_out < time_in THEN DATEDIFF(mi, time_out, time_in)
			  WHEN time_out > time_in THEN 1440 - DATEDIFF(mi, time_in, time_out)
		END
	) 'minutes'
from Company c
join Trip tr on tr.ID_comp = c.ID_comp and tr.trip_no IN (
	select trip_no from Pass_in_trip
)
join (
	select distinct tr.trip_no, pit.[date] from Trip tr
	join Pass_in_trip pit on tr.trip_no = pit.trip_no
) pitd on tr.trip_no = pitd.trip_no
group by c.[name]

--cost	0.049763649702072
--operations	15

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=93#20
select (select name from company where ID_comp=b.ID_comp) Company, 
       sum(datediff(mi,time_out,dateadd(day,IIF(time_out> time_in,1,0),time_in))) Time_fly
from (Select distinct ID_comp, p.trip_no, date, time_out, time_in 
	 from Pass_in_trip p
	 join Trip t on t.trip_no=p.trip_no) b
group by ID_comp

--cost 0.03089707903564
--operations 10   