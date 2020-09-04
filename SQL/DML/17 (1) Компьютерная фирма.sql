--Удалить из таблицы PC компьютеры, у которых величина hd попадает в тройку наименьших значений.
--    Оператор DELETE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
DELETE FROM PC WHERE hd <= ANY(
	SELECT distinct TOP 3 hd FROM PC ORDER BY hd
)

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/forum.php?F=2&N=17#20