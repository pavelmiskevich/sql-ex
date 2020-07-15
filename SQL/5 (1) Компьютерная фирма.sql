--Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
--    Простой оператор SELECT
--    Предикаты (часть 1)
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select model, speed, hd from PC
where (cd = '12x' or cd = '24x') and price < 600

--cost	0.0033249000553042
--operations	1

-- GIT HUB
SELECT model, speed, hd 
    FROM PC 
    WHERE ((cd = '12x') OR (cd = '24x')) AND (price < 600)

--cost	0.0033249000553042
--operations	1

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=5#20
