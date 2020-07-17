--Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
--    Простой оператор SELECT
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select sh.class, sh.name, cl.country from Classes cl
join Ships sh on sh.class = cl.class
where cl.numGuns > 9

--cost	0.017385620623827
--operations	3

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=14#20