--Из каждой группы ПК с одинаковым номером модели в таблице PC удалить все строки кроме строки с наибольшим для этой группы кодом (столбец code).
--    Оператор DELETE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
delete from PC where code NOT IN (
	select max(code) from PC
	group by model
)

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/forum.php?F=2&N=15#19