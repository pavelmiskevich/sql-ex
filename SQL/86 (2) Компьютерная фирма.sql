--Для каждого производителя перечислить в алфавитном порядке с разделителем "/" все типы выпускаемой им продукции.
--Вывод: maker, список типов продукции
--    Предложение GROUP BY
--    Оператор COALESCE
--    Функция REPLACE
--    Получение итоговых значений
-- Процесс -------------------------------------------------------------
select distinct [type] from Product order by [type]

select distinct p.maker, p.[type] from Product p

select distinct p.maker, p.[type], pc.model, l.model, pr.model from Product p
left join PC pc on p.model = pc.model
left join Laptop l on p.model = l.model
left join Printer pr on p.model = pr.model

select distinct t.maker,
	case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Laptop') IS NOT NULL) then 'Laptop' else '' end + 
	case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'PC') IS NOT NULL) then '/PC/' else '' end + 
	case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Printer') IS NOT NULL) then 'Printer' else '' end
from (
select distinct p.maker, p.[type] from Product p
) t

select distinct f.maker, 
	case when (LEN(f.[types]) = 11) then SUBSTRING(f.[types], 2, LEN(f.[types])) 
	else
		case when (LEN(f.[types]) = 10) then SUBSTRING(f.[types], 1, LEN(f.[types]) - 1) 
		else f.[types]
		end
	end 'types'
from (
	select distinct t.maker,
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Laptop') IS NOT NULL) then 'Laptop' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'PC') IS NOT NULL) then '/PC/' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Printer') IS NOT NULL) then 'Printer' else '' end 'types'
	from (
	select distinct p.maker, p.[type] from Product p
	) t
) f

select distinct f.maker, 
	f.[types],
    case when (SUBSTRING(f.[types], 1, 1) = '/') then SUBSTRING(f.[types], 2, LEN(f.[types])) end 'types',
    case when (SUBSTRING(f.[types], LEN(f.[types]), 1) = '/') then SUBSTRING(f.[types], 1, LEN(f.[types]) - 1) end 'types',
	case when (SUBSTRING(f.[types], 1, 1) = '/') 
		then SUBSTRING(f.[types], 2, LEN(f.[types])) 
		else
			case when (SUBSTRING(f.[types], LEN(f.[types]), 1) = '/') 
				then SUBSTRING(f.[types], 1, LEN(f.[types]) - 1) 
				else
				f.[types]
			end
	end 'types'
from (
	select distinct t.maker,
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Laptop') IS NOT NULL) then 'Laptop/' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'PC') IS NOT NULL) then 'PC/' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Printer') IS NOT NULL) then 'Printer' else '' end 'types'
	from (
	select distinct p.maker, p.[type] from Product p
	) t
) f

select distinct f.maker, 	
	0 +
	case when (SUBSTRING(f.[types], 1, 1) = '/') then 1 end +
	case when (SUBSTRING(f.[types], LEN(f.[types]), 1) = '/') then 2 end 'types'
from (
	select distinct t.maker,
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Laptop') IS NOT NULL) then 'Laptop' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'PC') IS NOT NULL) then '/PC/' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Printer') IS NOT NULL) then 'Printer' else '' end 'types'
	from (
	select distinct p.maker, p.[type] from Product p
	) t
) f
-- Решение -------------------------------------------------------------
select distinct f.maker, 
	case when (SUBSTRING(f.[types], 1, 1) = '/') 
		then SUBSTRING(f.[types], 2, LEN(f.[types])) 
		else
			case when (SUBSTRING(f.[types], LEN(f.[types]), 1) = '/') 
				then SUBSTRING(f.[types], 1, LEN(f.[types]) - 1) 
				else
				f.[types]
			end
	end 'types'
from (
	select distinct t.maker,
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Laptop') IS NOT NULL) then 'Laptop/' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'PC') IS NOT NULL) then 'PC/' else '' end + 
			case when ((select top 1 [type] from Product where maker = t.maker and [type] = 'Printer') IS NOT NULL) then 'Printer' else '' end 'types'
	from (
	select distinct p.maker, p.[type] from Product p
	) t
) f

--cost	0.075645558536053
--operations	17

-- GIT HUB
SELECT maker, 
CASE count(distinct type) 
WHEN 1 THEN MIN(type) 
WHEN 2 THEN MIN(type) + '/' + MAX(type) 
WHEN 3 THEN 'Laptop/PC/Printer' END 
FROM Product 
GROUP BY maker

--cost	0.015488217584789
--operations	5

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=86#20
select maker,case when CONCAT([Laptop],[PC],[Printer])='LaptopPCPrinter' then 'Laptop/PC/Printer'
	 when CONCAT([Laptop],[PC],[Printer])='LaptopPC' then 'Laptop/PC'
	 when CONCAT([Laptop],[PC],[Printer])='LaptopPrinter' then 'Laptop/Printer'
	 when CONCAT([Laptop],[PC],[Printer])='PCPrinter' then 'PC/Printer'
else CONCAT([Laptop],[PC],[Printer]) end
from (SELECT maker,type FROM [Product] group by maker,type) c
PIVOT ( max([type])  for  [type] in ( [Laptop],[PC],[Printer])) as pp

--cost 0.015488217584789
--operations 4

with q1 as
(SELECT distinct [maker],[type]
  FROM [Product])
  ,
  qq2 as
  (

select distinct maker,
(select type+'/' from q1 q2  where q1.maker=q2.maker for XML path ('')) зап
from q1
)
select maker,LEFT(зап,LEN(зап)-1)
from qq2

--cost 0.39504241943359
--operations 11

