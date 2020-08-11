--Для каждого корабля из таблицы Ships, в имени которого есть символы, не являющиеся латинской буквой, вывести:
--имя корабля, позиционный номер первого небуквенного символа в имени и сам символ.
--    Функция SUBSTRING
--    Функции CHARINDEX и PATINDEX
-- Процесс -------------------------------------------------------------
SELECT name, SUBSTRING(name, 2, LEN(name)) FROM Ships;
SELECT name, PATINDEX('% %', name), SUBSTRING(name, PATINDEX('% %', name), 1) FROM Ships WHERE PATINDEX('% %', name) > 0;

SELECT name FROM Ships WHERE PATINDEX('%[^a-Z]%', name) > 0;
-- Решение -------------------------------------------------------------
SELECT name, PATINDEX('%[^a-Z]%', name), 
	SUBSTRING(name, PATINDEX('%[^a-Z]%', name), 1) 
FROM Ships WHERE PATINDEX('%[^a-Z]%', name) > 0;

--cost	0.0033697700127959
--operations	2

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=136#20
with A as (select 65 x from ships union all select iif(x 1=92,97,x 1) from A where x<121),
B as (select max(len(name)) y from ships where name like '%[^a-zA-Z]%'
      union all select y-1 from B where y> 0),
C as (select name, charindex(char(unicode(right(name,y))),name) num, 
      char(unicode(right(name,y))) char
      from ships,B
      where unicode(right(name,y)) not in (select x from A)
)
select distinct name, num, char from (
select name, num, char, min(num) over(partition by name order by num)t from C)D
where num=t

--cost 0.10617528110743
--operations 38