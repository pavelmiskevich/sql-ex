--Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
--имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн
--    Явные операции соединения
--    Использование значения NULL в условиях поиска
--    Оператор CASE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct sh.name from Ships sh
join Classes cl on cl.class = sh.class --or cl.class = sh.name
	and cl.type = 'bb' 
	and cl.country = 'Japan' 
	and (cl.numGuns >= 9 or cl.numGuns IS NULL)
	and (cl.bore < 19  or cl.bore IS NULL)
	and (cl.displacement <= 65000 or cl.displacement IS NULL)

--cost	0.017553120851517
--operations	3

-- GIT HUB
SELECT DISTINCT s.name 
  FROM ships s JOIN classes c ON c.class = s.class 
 WHERE UPPER(c.country) = 'JAPAN' 
   AND (numguns >= 9 OR numguns IS NULL) 
   AND (c.bore < 19 OR c.bore IS NULL) 
   AND (displacement <= 65000 OR c.displacement IS NULL) 
   AND (c.type = 'bb'); 
   
--cost	0.017559820786119
--operations	3

SELECT DISTINCT ships.name 
FROM ships INNER JOIN classes ON classes.class = ships.class 
WHERE UPPER(classes.country) = 'JAPAN' 
AND (numguns>=9 or numguns is NULL) 
AND (classes.bore < 19 OR classes.bore IS NULL) 
AND (displacement <= 65000 OR classes.displacement IS NULL) 
AND classes.type = 'bb'