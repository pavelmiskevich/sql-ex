--Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
--    Простой оператор SELECT
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct Product.maker, Laptop.speed from Laptop
join Product on Laptop.model = Product.model AND type = 'laptop'
where hd >= 10

--cost	0.02058975212276
--operations	4

-- GIT HUB
SELECT DISTINCT p.maker, l.speed 
    FROM laptop l 
    JOIN product p ON p.model = l.model 
    WHERE l.hd >= 10

--cost	0.020670196041465
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=6#20
--1 вариант
select distinct p.maker,l.speed 
   from product p, laptop l 
where p.model=l.model and l.hd> =10 and p.type='laptop';

--cost	0.02058975212276
--operations	4

--2 вариант
select distinct p.maker, l.speed
  from product p
  join laptop l
  on p.model = l.model
where l.hd >  = 10 and type='laptop';

--cost	0.02058975212276
--operations	4