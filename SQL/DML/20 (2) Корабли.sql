--Заменить любое количество повторяющихся пробелов в названиях кораблей из таблицы Ships на один пробел.
-- Процесс -------------------------------------------------------------
select [name] from Ships

select LEN('|' + REPLACE('    ','  ',' ') + '|')
-- Решение -------------------------------------------------------------
UPDATE Ships	
	SET [name] = replace(replace(replace([name],'  ',' '+CHAR(1)), CHAR(1)+' ',''), CHAR(1),'')
-- GIT HUB

--FORUM
--https://www.sql-ex.ru/forum/forum.php?F=2&N=20#18