--Перенести все концевые пробелы, имеющиеся в названии каждого сражения в таблице Battles, в начало названия.
--    Оператор UPDATE
--    Функции работы со строками
-- Процесс -------------------------------------------------------------
select PATINDEX('% %' , 'str   ')
select LEFT('str   ' , 1)
select RIGHT('str   ' , 1)
select LEN('str   ') --не учитывает концевые пробелы
--REPLICATE(' ', 5)
select DATALENGTH('str   ')
-- Решение -------------------------------------------------------------
UPDATE Battles
	SET [name] = REPLICATE(' ', DATALENGTH(b.[name]) - LEN(b.[name])) + RTRIM(b.[name])
FROM Battles b
--WHERE [name] = b.[name]

-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/forum.php?F=2&N=18#19