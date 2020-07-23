--Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
--Вывести: maker, средний размер экрана.
--    Предложение GROUP BY
--    Явные операции соединения
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select pr.maker, avg(lp.screen) from Product pr
join Laptop lp on pr.model = lp.model
group by pr.maker

--cost	0.021534653380513
--operations	6

-- GIT HUB
SELECT product.maker, AVG(screen) 
    FROM      laptop 
    LEFT JOIN product ON product.model = laptop.model 
    GROUP BY  product.maker

--cost	0.021535152569413
--operations	6

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=19#20