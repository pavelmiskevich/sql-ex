--В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
--Вывод: номер модели, тип модели.
--    Предикат LIKE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct model, type from Product where model NOT LIKE '%[^0-9]%'
union
select distinct model, type from Product where model NOT LIKE '%[^a-Z]%'

--cost	0.012481782585382
--operations	3

-- GIT HUB
SELECT model, type 
    FROM product 
    WHERE upper(model) NOT LIKE '%[^A-Z]%' 
       OR model NOT LIKE '%[^0-9]%';

--cost	0.0033633999992162
--operations	1

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=35#20