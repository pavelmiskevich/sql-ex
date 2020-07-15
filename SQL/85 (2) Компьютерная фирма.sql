--Найти производителей, которые выпускают только принтеры или только PC.
--При этом искомые производители PC должны выпускать не менее 3 моделей.
--    Получение итоговых значений
--    Предложение HAVING
--!!! Какой то бред в постановке, первое условие противоречит второму
-- Процесс -------------------------------------------------------------
select maker, model, [type] from Product order by maker, [type]
-- ни один производитель не подходит под оба условия

select maker from Product where maker NOT IN(select maker from Product where [type] <> 'Laptop')

select maker, count([type]) from Product
where [type] = 'PC' or [type] = 'Printer'
group by maker

select distinct p.maker, pc.model, lt.model, pr.model from Product p
left join PC pc on p.model = pc.model
left join Laptop lt on p.model = lt.model
left join Printer pr on p.model = pr.model

select p.maker, count(pc.model), count(lt.model), count(pr.model) from Product p
left join PC pc on p.model = pc.model
left join Laptop lt on p.model = lt.model
left join Printer pr on p.model = pr.model
group by p.maker

-- Условие №2 ищем производителей PC, у которых не менее трех моделей
select p.maker from Product p
where p.[type] = 'PC'
group by p.maker
having count(p.model) >= 3
-- ответ неверный E

-- Условие №1 ищем производителей, которые только принтеры или только PC
-- опять же вопрос, в данном условии ИЛИ исключающее или нет?
select distinct p.maker, pc.model as PC, pr.model as Printer from Product p
left join PC pc on p.model = pc.model
left join Printer pr on p.model = pr.model

select p.maker from (select distinct maker, [type] from Product) p
where p.[type] <> 'Laptop' and maker NOT IN (select maker from Product where [type] = 'Laptop')
group by p.maker
having count(p.[type]) = 1
-- Решение -------------------------------------------------------------
-- Задача стала понятна. Ищем производителей принтеров или ПК, но для ПК должно быть не менее трех моделей
select distinct p.maker from (
select distinct maker, [type] from Product
) p
group by p.maker
having count(p.[type]) = 1

select pr.maker from Product pr
where pr.[type] = 'Printer' and pr.maker IN (
	select distinct p.maker from (
		select distinct maker, [type] from Product
	) p
	group by p.maker
	having count(p.[type]) = 1
)
union
select pr.maker from Product pr
where pr.[type] = 'PC' and pr.maker IN (
	select distinct p.maker from (
		select distinct maker, [type] from Product
	) p
	group by p.maker
	having count(p.[type]) = 1
)
group by pr.maker
having count(pr.model) >= 3

--cost	0.077852182090282
--operations	21

-- GIT HUB
SELECT maker 
FROM Product 
GROUP BY maker 
HAVING count(distinct type) = 1 AND (
	min(type) = 'printer' OR (min(type) = 'pc' AND count(model) >= 3)
)

--cost	0.015601050108671
--operations	7

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=85#20
SELECT
 maker
FROM Product
GROUP BY maker
HAVING
 MAX(IIF(type = 'Printer', 1, 0)) * MIN(IIF(type <>  'Printer', -1, 1)) > = 1
 OR SUM(IIF(type = 'PC', 1, 0)) * MIN(IIF(type <>  'PC', -1, 1)) > = 3

--cost 0.015537809580564
--operations 5

SELECT maker FROM PRODUCT WHERE type='printer'
EXCEPT
SELECT maker From product where type in ('PC','Laptop')
UNION
(SELECT maker FROM (SELECT maker, count(model) c FROM PRODUCT WHERE type='PC' GROUP BY maker HAVING count(model)> =3) x
EXCEPT
SELECT maker From product where type in ('Printer','Laptop'))

--cost	0.044530414044857
--operations	14