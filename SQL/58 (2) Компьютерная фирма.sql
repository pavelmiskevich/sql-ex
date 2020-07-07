--Для каждого типа продукции и каждого производителя из таблицы Product c точностью до двух десятичных знаков найти процентное отношение числа моделей данного типа данного производителя к общему числу моделей этого производителя.
--Вывод: maker, type, процентное отношение числа моделей данного типа к общему числу моделей производителя
--    Получение итоговых значений
--    Преобразoвание типов
--    Явные операции соединения
--    Декартово произведение
--    Коррелирующие подзапросы
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct pr.maker, pr.type, ISNULL(CAST(((CAST(type.mc AS decimal) / al.mc) * 100) AS numeric(17, 2)), '.00') as 'prc' from (
	(select distinct maker, pr2.type from Product pr1
	cross join (select distinct type from Product) pr2)
	) pr
left join (select pr1.maker, pr1.type, count(pr1.model) as 'mc' from Product pr1
--where pr1.maker = pr.maker and pr1.type = pr.type
group by pr1.maker, pr1.type) type on type.maker = pr.maker and type.type = pr.type
left join (select pr1.maker, count(pr1.model) as 'mc' from Product pr1
group by pr1.maker) al on al.maker = pr.maker

--cost	0.0721705108881
--operations	16

-- GIT HUB
