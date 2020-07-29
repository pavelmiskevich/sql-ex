--Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').
--    Пересечение и разность
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct country from Classes
where type = 'bb' and country in(
	select distinct country from Classes
	where type = 'bc')

--cost	0.021138979122043
--operations	4

-- GIT HUB
SELECT country 
    FROM classes 
    GROUP BY country 
    HAVING COUNT(DISTINCT type) = 2;

--cost	0.014959990978241
--operations	5

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=38#20