--Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
--    Использование в запросе нескольких источников записей
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select distinct p1.model model1, p2.model model2, p1.speed, p1.ram from PC p1 
join PC p2 on p1.speed = p2.speed and p1.ram = p2.ram and p2.model < p1.model

--cost	0.037259969860315
--operations	4

-- GIT HUB
select distinct PC.model, pc2.model, PC.speed, PC.ram  
from PC 
INNER JOIN PC as pc2 ON  pc2.speed = PC.speed 
AND pc2.ram=PC.ram AND PC.model != pc2.model AND PC.model > pc2.model

--cost	0.037259969860315
--operations	4

SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram 
    FROM pc pc1, pc pc2 
    WHERE pc1.speed = pc2.speed 
      AND pc1.ram   = pc2.ram 
      AND pc1.model > pc2.model

--cost	0.037259969860315
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=16