--Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
--    Предложение GROUP BY
--    Предложение HAVING
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select hd from PC
group by hd
having count(hd) >= 2

--cost	0.015043876133859
--operations	5

-- GIT HUB
SELECT hd FROM pc GROUP BY hd HAVING COUNT(model) >= 2

--cost	0.015043876133859
--operations	5

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=15#20