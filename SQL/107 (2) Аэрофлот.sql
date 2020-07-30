--Для пятого по счету пассажира из числа вылетевших из Ростова в апреле 2003 года определить компанию, номер рейса и дату вылета.
--Замечание. Считать, что два рейса одновременно вылететь из Ростова не могут.
--    Постраничная разбивка записей (пейджинг)
-- Процесс -------------------------------------------------------------
select *, COUNT(*) OVER() from Pass_in_trip
-- вылеты пассажиров в апреле 2003 года
select * from Pass_in_trip 
where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4
order by [date]
-- вылеты пассажиров в апреле 2003 года из Ростова
select top 5 pit.* from Pass_in_trip pit
join Trip tr on pit.trip_no = tr.trip_no and tr.town_from = 'Rostov'
where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4
order by [date]

SELECT pit.trip_no, pit.[date], ROW_NUMBER() OVER(ORDER BY [date]) AS num
	FROM Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and tr.town_from = 'Rostov'
	where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4
-- по номеру строки, а именно 5
SELECT t.trip_no, t.[date] from (
	SELECT pit.trip_no, pit.[date], ROW_NUMBER() OVER(ORDER BY [date]) AS num
	FROM Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and tr.town_from = 'Rostov'
	where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4	
) t where t.num = 5
-- Решение -------------------------------------------------------------
select top 1 c.[name], t.trip_no, t.[date] from (
	select top 5 pit.trip_no, pit.[date] from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and tr.town_from = 'Rostov'
	where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4
	order by [date], trip_no
) t 
join Trip tr on t.trip_no = tr.trip_no
join Company c on tr.ID_comp = c.ID_comp
order by t.[date] desc

--cost	0.03791306912899
--operations	10

select top 1 c.[name], t.trip_no, t.[date] from (
	SELECT pit.trip_no, pit.[date], ROW_NUMBER() OVER(ORDER BY [date], pit.trip_no) AS num
	FROM Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and tr.town_from = 'Rostov'
	where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4
) t 
join Trip tr on t.trip_no = tr.trip_no
join Company c on tr.ID_comp = c.ID_comp
where t.num = 5

--cost	0.026537647470832
--operations	13

--!!!Потому что к дате надо добавлять время вылета, а вам случайно повезло.
select top 1 c.[name], t.trip_no, t.[date] from (
	select top 5 pit.trip_no, pit.[date] from Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and tr.town_from = 'Rostov'
	where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4
	order by [date], tr.time_out
) t 
join Trip tr on t.trip_no = tr.trip_no
join Company c on tr.ID_comp = c.ID_comp
order by t.[date] desc

select top 1 c.[name], t.trip_no, t.[date] from (
	SELECT pit.trip_no, pit.[date], ROW_NUMBER() OVER(ORDER BY [date], tr.time_out) AS num
	FROM Pass_in_trip pit
	join Trip tr on pit.trip_no = tr.trip_no and tr.town_from = 'Rostov'
	where DATEPART(year, [date]) = 2003 and DATEPART(month, [date]) = 4
) t 
join Trip tr on t.trip_no = tr.trip_no
join Company c on tr.ID_comp = c.ID_comp
where t.num = 5

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=107#20
SELECT C.NAME, T.TRIP_NO, PT.DATE
  FROM PASS_IN_TRIP PT
    JOIN TRIP T ON PT.TRIP_NO = T.TRIP_NO
    JOIN COMPANY C ON C.ID_COMP=T.ID_COMP
  WHERE T.TOWN_FROM = 'Rostov'
    AND PT.DATE-DAY(PT.DATE)+1 = Cast('4-1-2003' as datetime)
  ORDER BY PT.date, T.time_out
  OFFSET 4 ROWS FETCH NEXT 1 ROW ONLY

--cost 0.021801363676786
--operations 7