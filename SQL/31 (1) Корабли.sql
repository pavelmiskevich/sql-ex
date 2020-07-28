--Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
--    Простой оператор SELECT
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct cl.class, cl.country from Classes cl
--left join Ships sh on cl.class = sh.class
where cl.bore >= 16

--cost	0.0033183000050485
--operations	1

-- GIT HUB
SELECT DISTINCT class, country 
    FROM classes 
    WHERE bore >= 16 ;

--cost	0.0033183000050485
--operations	1

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=31#20