--В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.
--    Явные операции соединения
--    Объединение
--    Оператор CASE
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct isnull(io.point, oo.point), isnull(io.date, oo.date), io.inc, oo.out from Income_o io
full join Outcome_o oo on io.point = oo.point and io.date = oo.date

--cost	0.023773994296789
--operations	5

-- GIT HUB
SELECT t1.point, t1.date, inc, out 
    FROM income_o t1 
         LEFT JOIN outcome_o t2 
                ON t1.point = t2.point 
                   AND t1.date = t2.date 
  UNION 
  SELECT t2.point, t2.date, inc, out 
    FROM income_o t1 
         RIGHT JOIN outcome_o t2 
                 ON t1.point = t2.point 
                    AND t1.date = t2.date ;

--cost	0.024208499118686
--operations	7

SELECT income_o.point, income_o.date, inc, out 
FROM income_o 
LEFT JOIN outcome_o ON income_o.point = outcome_o.point 
AND income_o.date = outcome_o.date 
UNION 
SELECT outcome_o.point, outcome_o.date, inc, out 
FROM income_o 
RIGHT JOIN outcome_o  ON income_o.point = outcome_o.point 
AND income_o.date = outcome_o.date

--cost	0.024208499118686
--operations	7

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=29#20
SELECT
CASE
WHEN I.point IS NOT NULL
THEN I.point
ELSE O.point
END point,
CASE
WHEN I.date IS NOT NULL
THEN I.date
ELSE O.date
END DATE, I.inc, O.out
FROM Income_o I FULL JOIN
     Outcome_o O ON I.point = O.point AND I.date = O.date

--cost 0.012286799959838
--operations 4