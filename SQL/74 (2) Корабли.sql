--Вывести классы всех кораблей России (Russia). Если в базе данных нет классов кораблей России, вывести классы для всех имеющихся в БД стран.
--Вывод: страна, класс
--    Предложение GROUP BY
--    Внешние соединения
--    Оператор CASE
--    Использование ключевых слов ANY, ALL с предикатами сравнения
-- Процесс -------------------------------------------------------------
select c.country, c.class from Classes c
join Ships s ON c.class = s.class
join Outcomes o ON s.name = o.ship
union
select c.country, c.class from Classes c
join Outcomes o ON c.class = o. ship
where o.ship NOT IN (select name from Ships)
-- Решение -------------------------------------------------------------
select c.country, c.class from Classes c WHERE c.country = 'RUSSIA'
union all
select c.country, c.class from Classes c WHERE NOT EXISTS (
	select c.country, c.class from Classes c WHERE c.country = 'RUSSIA'
)

--cost	0.012830056250095
--operations	6

-- GIT HUB
SELECT Classes.country, Classes.class 
FROM Classes
WHERE UPPER(Classes.country) = 'RUSSIA' AND EXISTS ( 
	SELECT Classes.country, Classes.class 
	FROM Classes 
	WHERE UPPER(Classes.country) = 'RUSSIA' 
) 

UNION ALL 

SELECT Classes.country, Classes.class 
FROM Classes
WHERE NOT EXISTS (
	SELECT Classes.country, Classes.class 
	FROM Classes
	WHERE UPPER(Classes.country) = 'RUSSIA' 
)

--cost	0.016704227775335
--operations	8

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=74#20
SELECT country, class
FROM Classes 
WHERE country=
(CASE
WHEN 'Russia' IN(SELECT DISTINCT country FROM Classes)
THEN 'Russia' ELSE country
END)

--cost 0.0095143346115947
--operations 4