--Для каждой компании подсчитать количество перевезенных пассажиров (если они были в этом месяце) по декадам апреля 2003. При этом учитывать только дату вылета.
--Вывод: название компании, количество пассажиров за каждую декаду
--    Предложение GROUP BY
--    Оператор CASE
-- Процесс -------------------------------------------------------------
select tr.ID_comp, tr.time_out, pit.ID_psg from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no

select tr.ID_comp, tr.time_out, count(pit.ID_psg) from Trip tr
join Pass_in_trip pit on tr.trip_no = pit.trip_no
group by tr.ID_comp, tr.time_out

select tr.ID_comp, tr.time_out, pit.ID_psg from Pass_in_trip pit
join Trip tr on tr.trip_no = pit.trip_no and tr.time_out >= '2003-04-01 00:00:00.000' and tr.time_out  < '2003-04-11 00:00:00.000'

select c.[name], t1.ID_psg '11-20' from Company c
join Trip tr on c.ID_comp = tr.ID_comp
left join (
select trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-11 00:00:00.000' and pit.[date]  < '2003-04-21 00:00:00.000'
) t1 on tr.trip_no = t1.trip_no

select c.[name], count(t1.ID_psg) '11-20' from Company c
join Trip tr on c.ID_comp = tr.ID_comp
left join (
select trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-11 00:00:00.000' and pit.[date]  < '2003-04-21 00:00:00.000'
) t1 on tr.trip_no = t1.trip_no
group by c.[name]

--select c.[name], t1.ID_psg '1-10', t2.ID_psg '11-20', t3.ID_psg '21-30' from Company c
select c.[name], count(t1.ID_psg) '1-10', count(t2.ID_psg) '11-20', count(t3.ID_psg) '21-30' from Company c
join Trip tr on c.ID_comp = tr.ID_comp
left join (
select distinct trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-01 00:00:00.000' and pit.[date]  < '2003-04-11 00:00:00.000'
) t1 on tr.trip_no = t1.trip_no
left join (
select distinct trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-11 00:00:00.000' and pit.[date]  < '2003-04-21 00:00:00.000'
) t2 on tr.trip_no = t2.trip_no and t2.ID_psg IS NOT NULL
left join (
select distinct trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-21 00:00:00.000' and pit.[date]  < '2003-05-01 00:00:00.000'
) t3 on tr.trip_no = t3.trip_no
group by c.[name]
having count(t1.ID_psg) > 0 or count(t2.ID_psg) > 0 or count(t3.ID_psg) > 0

select c.[name], 
	sum(case when (t1.ID_psg IS NOT NULL) then 1 else 0 end) '1-10', 
	sum(case when (t2.ID_psg IS NOT NULL) then 1 else 0 end) '11-20', 
	sum(case when (t3.ID_psg IS NOT NULL) then 1 else 0 end) '21-30' from Company c
join Trip tr on c.ID_comp = tr.ID_comp
left join (
select trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-01 00:00:00.000' and pit.[date]  < '2003-04-11 00:00:00.000'
) t1 on tr.trip_no = t1.trip_no
left join (
select trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-11 00:00:00.000' and pit.[date]  < '2003-04-21 00:00:00.000'
) t2 on tr.trip_no = t2.trip_no
left join (
select trip_no, ID_psg from Pass_in_trip pit
where pit.[date] >= '2003-04-21 00:00:00.000' and pit.[date]  < '2003-05-01 00:00:00.000'
) t3 on tr.trip_no = t3.trip_no
group by c.[name]
having count(t1.ID_psg) > 0 or count(t2.ID_psg) > 0 or count(t3.ID_psg) > 0
-- Решение -------------------------------------------------------------
select c.[name],
	COALESCE(sum(t1.co), 0) '1-10', 
	COALESCE(sum(t2.co), 0) '11-20', 
	COALESCE(sum(t3.co), 0) '21-30'
from Company c
join Trip tr on c.ID_comp = tr.ID_comp
left join (
	select trip_no, count(ID_psg) co from Pass_in_trip pit
	where pit.[date] >= '2003-04-01 00:00:00.000' and pit.[date]  < '2003-04-11 00:00:00.000'
	group by trip_no
) t1 on tr.trip_no = t1.trip_no
left join (
	select trip_no, count(ID_psg) co from Pass_in_trip pit
	where pit.[date] >= '2003-04-11 00:00:00.000' and pit.[date]  < '2003-04-21 00:00:00.000'
	group by trip_no
) t2 on tr.trip_no = t2.trip_no
left join (
	select trip_no, count(ID_psg) co from Pass_in_trip pit
	where pit.[date] >= '2003-04-21 00:00:00.000' and pit.[date]  < '2003-05-01 00:00:00.000'
	group by trip_no
) t3 on tr.trip_no = t3.trip_no
group by c.[name]
having sum(t1.co) IS NOT NULL or sum(t2.co) IS NOT NULL or sum(t3.co) IS NOT NULL

--cost	0.076995462179184
--operations	23

-- GIT HUB
SELECT Company.name, R.1_10, R.11_21, R.21_30 
FROM (
	SELECT Trip.ID_comp, 
	SUM(CASE WHEN DAY(Pass_in_trip.date) < 11 THEN 1 ELSE 0 END) AS 1_10, 
	SUM(CASE WHEN (DAY(Pass_in_trip.date) > 10 AND DAY(P.date) < 21) THEN 1 ELSE 0 END) AS 11_21, 
	SUM(CASE WHEN DAY(Pass_in_trip.date) > 20 THEN 1 ELSE 0 END) AS 21_30 
	FROM Trip 
	INNER JOIN Pass_in_trip ON Trip.trip_no = Pass_in_trip.trip_no AND CONVERT(char(6), P.date, 112) = '200304' 
GROUP BY Trip.ID_comp 
) AS R INNER JOIN Company ON R.ID_comp = Company.ID_comp

--некорректен

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=84#20
SELECT name, SUM (CASE WHEN DATEPART(d, date) BETWEEN 1 AND 10 THEN 1 ELSE 0 END)  '1-10',
	     SUM(CASE WHEN DATEPART(d, date) BETWEEN 11 AND 20 THEN 1 ELSE 0 END) '11-20',
	     SUM(CASE WHEN DATEPART(d, date) BETWEEN 21 AND 30 THEN 1 ELSE 0 END ) '21-30'
FROM pass_in_trip pit
JOIN trip t ON t.trip_no = pit.trip_no
JOIN company c ON c.id_comp = t.id_comp
WHERE CONCAT(DATEPART(yy, date), DATEPART(M, date)) = 20034
GROUP BY name

--cost 0.022062478587031
--operations 9  