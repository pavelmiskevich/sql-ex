--Удалить из таблицы Product те модели, которые отсутствуют в других таблицах.
--    Оператор DELETE123
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
DELETE FROM Product 
	FROM Product p 
	LEFT JOIN PC ON p.model = PC.model 
	LEFT JOIN Laptop l ON p.model = l.model 
	LEFT JOIN Printer pr ON p.model = pr.model 
	WHERE PC.model IS NULL AND l.model IS NULL AND pr.model IS NULL

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/forum.php?F=2&N=15#19