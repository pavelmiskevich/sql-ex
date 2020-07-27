--В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
--Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).
--    Предложение GROUP BY
--    Внешние соединения
--    Объединение
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct
	isnull(i.point, o.point) point,
	isnull(i.date, o.date) date,
	(select sum(out) from Outcome where point = isnull(i.point, o.point) and date = isnull(i.date, o.date)) out,
	(select sum(inc) from Income where point = isnull(i.point, o.point) and date = isnull(i.date, o.date)) inc
from (select point, [date] from Income) i
full join (select point, [date] from Outcome) o on i.point = o.point and i.date = o.date

--cost	0.044200927019119
--operations	20

-- GIT HUB
SELECT point, date, SUM(sum_out), SUM(sum_inc) 
    FROM ( SELECT point, date, SUM(inc) as sum_inc, NULL as sum_out 
               FROM Income GROUP BY point, date 
             UNION 
             SELECT point, date, NULL as sum_inc, SUM(out) as sum_out 
                 FROM Outcome GROUP BY point, date 
          ) as t 
    GROUP BY point, date 
    ORDER BY point ;

--cost	0.035419210791588
--operations	11

select point, date, sum(sumOut), sum(sumInc) 
from( select point, date, sum(inc) as sumInc, null as sumOut from Income Group by point, date 
Union 
select point, date, null as sumInc, sum(out) as sumOut from Outcome Group by point, date ) as X
group by point, date order by point

--cost	0.035419210791588
--operations	11

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=30#20
with all_data as (
Select code, point, date, inc, null as out
from income 
union all
Select code, point, date, null as inc, out 
from outcome 
)
select point, date, sum(out) as out,  sum (inc) as inc
from all_data
group by point, date

--cost          0.018404265865684
--operations 8