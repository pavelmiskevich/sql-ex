--Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
--    Явные операции соединения
--    Подзапросы
--    Получение итоговых значений
--    Предикат IN
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct pr.maker from Product pr
where pr.type = 'Printer' and pr.maker in (
	select pr.maker from Product pr join PC pc on pr.model = pc.model
	where pc.ram = (select min(ram) from PC) 
		and pc.speed = (select max(speed) from PC
						where ram = (
							select min(ram) from PC)))

--cost	0.043747812509537
--operations	16

-- GIT HUB
SELECT DISTINCT maker 
    FROM product 
    WHERE model IN (SELECT model 
                        FROM pc 
                        WHERE ram = (SELECT MIN(ram) FROM pc) 
                            AND speed = (SELECT MAX(speed) 
                                             FROM pc 
                                             WHERE ram = (SELECT MIN(ram) 
                                                              FROM pc 
                                                          ) 
                                         ) 
                    ) 
        AND maker IN (SELECT maker 
                          FROM product 
                          WHERE type = 'printer');                   

--cost	0.031802739948034
--operations	16

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=25#20