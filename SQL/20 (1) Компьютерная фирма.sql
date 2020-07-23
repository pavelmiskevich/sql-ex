--Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
--    Предложение GROUP BY
--    Предложение HAVING
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select pr.maker, count(pr.model) from Product pr
where type = 'pc'
group by pr.maker
having count(pr.model) > 2

--cost	0.015046463347971
--operations	5

-- GIT HUB
SELECT maker, COUNT(model) AS Count_Model 
from Product 
WHERE type = 'pc'
GROUP BY Product.maker 
HAVING COUNT(model) >= 3

--cost	0.015046463347971
--operations	5

SELECT maker, COUNT(model) 
    FROM product 
    WHERE type = 'pc' 
    GROUP BY product.maker 
    HAVING COUNT (DISTINCT model) >= 3

--cost	0.015046463347971
--operations	5

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=20#20