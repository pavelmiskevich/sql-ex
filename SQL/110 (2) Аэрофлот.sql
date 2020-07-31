--Определить имена разных пассажиров, когда-либо летевших рейсом, который вылетел в субботу, а приземлился в воскресенье.
--    Оператор CASE
--    Подзапросы
--    Функция DATEPART
--    Функция DATENAME
-- Процесс -------------------------------------------------------------
-- приземление на следующий день
select * from Trip where time_out > time_in
-- вылеты в субботу
select * from Pass_in_trip where DATENAME(weekday, [date] ) = 'Saturday'

select DATEPART(dw, [date]), DATENAME(weekday, [date] ), [date] from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no

select distinct pas.[name] from Passenger pas
join Pass_in_trip pit on pas.ID_psg = pit.ID_psg and DATEPART(dw, [date]) = 7 --and DATENAME(weekday, [date] ) = 'Saturday'
join Trip tr on pit.trip_no = tr.trip_no and time_out > time_in
--Ваш запрос вернул правильные данные на основной базе, но не прошел тест на проверочной базе.
--* Неверное число записей (меньше на 2)
-- Решение -------------------------------------------------------------
select pas.[name] from Passenger pas
where pas.ID_psg IN  (
	select pit.ID_psg from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and time_out > time_in
	where DATEPART(dw, [date]) = 7
)

--cost	0.027076689526439
--operations	6

select pas.[name] from Passenger pas
where pas.ID_psg IN  (
	select pit.ID_psg from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and time_out > time_in
	where DATENAME(weekday, [date] ) = 'Saturday'
)

--cost	0.021952824667096
--operations	8

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=110#20