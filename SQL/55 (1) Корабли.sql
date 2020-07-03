--Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
--    Явные операции соединения
--    Предложение GROUP BY
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select cl.class, isnull(sh.launched, (
	select min(sh.launched) from Ships sh where sh.class = cl.class group by sh.class)
) from Classes cl
left join Ships sh on cl.class = sh.name

--cost	0.021296724677086
--operations	7

-- GIT HUB
SELECT Classes.class, R.min FROM Classes
LEFT JOIN (
	SELECT class, MIN(launched) as min FROM Ships GROUP BY class
) AS R ON R.class = Classes.class
   
--cost	0.012816484086215
--operations	5