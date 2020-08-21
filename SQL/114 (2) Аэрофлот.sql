--Определить имена разных пассажиров, которым чаще других доводилось лететь на одном и том же месте. Вывод: имя и количество полетов на одном и том же месте.
--    Предложение GROUP BY
--    Предложение HAVING
--    Явные операции соединения
-- Процесс -------------------------------------------------------------
--* Неверное число записей (меньше на 3)
SELECT TOP 1 WITH TIES t.[name], t.NN FROM (
select pas.[name], pit.place, count(*) 'NN' from Pass_in_trip pit
join Passenger pas on pit.ID_psg = pas.ID_psg
group by pas.[name], pit.place
) t order by t.NN desc

--* Неверное число записей (больше на 1)
SELECT TOP 1 WITH TIES pas.[name], t.NN FROM (
select pit.ID_psg, pit.place, count(*) 'NN' from Pass_in_trip pit
group by pit.ID_psg, pit.place
) t
join Passenger pas on t.ID_psg = pas.ID_psg
order by t.NN desc
-- Решение -------------------------------------------------------------
SELECT TOP 1 WITH TIES pas.[name], t.NN FROM (
	select distinct pit.ID_psg, count(*) 'NN' from Pass_in_trip pit
	group by pit.ID_psg, pit.place
) t
join Passenger pas on t.ID_psg = pas.ID_psg
order by t.NN desc

--cost	0.037335842847824
--operations	8

-- GIT HUB

--FORUM
--+https://www.sql-ex.ru/forum/Lforum.php?F=3&N=114#20
WITH CTE AS (
  SELECT ID_PSG, COUNT(*) C, MAX(COUNT(*)) OVER() MC
    FROM PASS_IN_TRIP
    GROUP BY ID_PSG, PLACE
)
SELECT P.NAME, MAX(CTE.MC) NN
  FROM CTE
    JOIN PASSENGER P ON P.ID_PSG=CTE.ID_PSG
  WHERE CTE.C=CTE.MC
  GROUP BY P.ID_PSG,P.NAME

--cost 0.025159403681755
--operations 15