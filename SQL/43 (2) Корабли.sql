--Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
--    Предикат EXISTS
--    Предикат NOT IN
--    Использование значения NULL в условиях поиска
--    Функция DATEPART
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct b.name from Battles b
where NOT EXISTS (
	select 1 from Ships s where s.launched = DATEPART(yy, b.date))

--cost	0.0098556149750948
--operations	5

-- GIT HUB
SELECT name 
  FROM battles 
 WHERE year(date) NOT IN (SELECT launched 
                            FROM ships 
                           WHERE launched IS NOT NULL);

--cost	0.01551229134202
--operations	8

select name from Battles
where YEAR (date) NOT IN (
	select launched from Ships where launched is not null
)

--cost	0.01551229134202
--operations	8

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=43#20