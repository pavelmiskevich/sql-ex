--По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.
--    Использование в запросе нескольких источников записей
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct sh.name from Ships sh
join Classes cl on cl.class = sh.class
where sh.launched > 1921 and cl.displacement > 35000 and cl.type = 'bb'

--cost	0.011570819653571
--operations	3

-- GIT HUB
SELECT name FROM classes, ships 
    WHERE launched >= 1922 
      AND displacement > 35000 
      AND type = 'bb' 
      AND ships.class = classes.class;

--cost	0.011570819653571
--operations	3

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=34#20