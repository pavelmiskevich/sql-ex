--Определить лидера по сумме выплат в соревновании между каждой существующей парой пунктов с одинаковыми номерами из двух разных таблиц - outcome и outcome_o - на каждый день, когда осуществлялся прием вторсырья хотя бы на одном из них.
--Вывод: Номер пункта, дата, текст:
--- "once a day", если сумма выплат больше у фирмы с отчетностью один раз в день;
--- "more than once a day", если - у фирмы с отчетностью несколько раз в день;
--- "both", если сумма выплат одинакова.
--    Оператор COALESCE
--    Внешние соединения
--    Предикат EXISTS
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct  isnull(m.point, n.point)
	,isnull(m.date, n.date)
	,case when isnull(n.ooou,0) > isnull(m.oou,0) then 'once a day' 
	else 
		case when isnull(n.ooou,0) < isnull(m.oou,0) then 'more than once a day' else 'both' end  end
from (
	select distinct o.point, o.date, sum(o.[out]) oou  from Outcome o where o.point in (
		select distinct point from Outcome_o) group by o.date, o.point) m
full join (select distinct oo.point, oo.date, oo.[out] ooou from Outcome_o oo where oo.point in (
	select point from Outcome)) n on m.point = n.point and m.date = n.date

--cost	0.048543646931648
--operations	13

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=128#20
with cte as (SELECT point, date,sum(out) sum_out FROM [Outcome] group by point, date) 

SELECT isnull(o.point,c.point) point,isnull(o.date, c.date) dd,
       case when o.out> isnull(c.sum_out,0) then 'once a day'
            when isnull(o.out,0)<c.sum_out then 'more than once a day' else  'both' end lider
FROM [Outcome_o] o
full join cte c on o.date=c.date and o.point=c.point
where EXISTS (SELECT * FROM [Outcome] where point = o.point) or 
EXISTS (SELECT * FROM [Outcome_o] where point = c.point)

--cost 0.029264962300658
--operations 11