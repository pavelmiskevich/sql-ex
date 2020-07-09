--По таблицам Income и Outcome для каждого пункта приема найти остатки денежных средств на конец каждого дня,
--в который выполнялись операции по приходу и/или расходу на данном пункте.
--Учесть при этом, что деньги не изымаются, а остатки/задолженность переходят на следующий день.
--Вывод: пункт приема, день в формате "dd/mm/yyyy", остатки/задолженность на конец этого дня.
--    Накопительные итоги
--    Оператор COALESCE
--    Внешние соединения
--    Функция CONVERT
-- Процесс -------------------------------------------------------------
select i.point, i.[date] from Income i
union
select o.point, o.[date] from Outcome o

select point, CONVERT(nvarchar(10), date, 103), 
sum(t.sum)
from (
select inc.point, inc.date, inc.inc as 'sum' from Income inc
union all
select out.point, out.date, -out.out as 'sum' from Outcome out
) t
group by point, CONVERT(nvarchar(10), date, 103)
-- Решение -------------------------------------------------------------
select f.point, CONVERT(nvarchar(10), f.[date], 103), 
	(
		select sum(t.[sum]) from (
			select ii.point, ii.[date], ii.inc as 'sum' from Income ii where ii.point = f.point and ii.[date] <= f.[date]
			union all
			select oo.point, oo.[date], -oo.[out] as 'sum' from Outcome oo where oo.point = f.point and oo.[date] <= f.[date]
		) t
	) rem
from (
	select i.point, i.[date] from Income i
	union
	select o.point, o.[date] from Outcome o
) f

--cost	0.035279311239719
--operations	12

-- GIT HUB

--+FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=69#20
select point, convert(varchar(100), date, 103), sum(sum(inc)) over(partition by point order by date)
from
(
select point, date, inc from income 
union all 
select point, date, -out from outcome 
) T group by point, date

--cost 0.0185402687639
--operations 13