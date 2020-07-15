--Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
--    Простой оператор SELECT
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select pr.model, speed, hd from Product pr
join PC pc on pr.model = pc.model
where pc.price < 500

--cost	0.009227380156517
--operations	3

-- GIT HUB
SELECT model, speed, hd FROM PC WHERE price < 500

--cost	0.0033249000553042
--operations	1

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=1#20
