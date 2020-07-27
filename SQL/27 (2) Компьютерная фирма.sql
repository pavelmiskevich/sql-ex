--Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
--    Получение итоговых значений
--    Явные операции соединения
--    Предикат IN
-- Процесс -------------------------------------------------------------

-- Решение -------------------------------------------------------------
select pr.maker, avg(pc.hd) hd from PC pc
join Product pr on pc.model = pr.model
where pr.maker in (
	SELECT DISTINCT maker FROM Product WHERE type = 'printer')
group by pr.maker

--cost	0.037573434412479
--operations	8

-- GIT HUB
SELECT product.maker, AVG(pc.hd) 
    FROM pc, product 
    WHERE product.model = pc.model 
      AND product.maker IN (SELECT DISTINCT maker 
                                FROM product 
                                WHERE product.type = 'printer' 
                            ) 
    GROUP BY maker;

--cost	0.037573434412479
--operations	8

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=27#20
select maker, avg(pc.hd)
  from product as pr
  join pc
    on pc.model = pr.model
where type = 'PC'
   and pr.model >    0
   and pc.model >    0
group by maker
having count(case when type = 'Printer' then 1 else 0 end) >    0
   and count(case when type = 'PC'      then 1 else 0 end) >    0

--cost 0.019783578813076
--operations 7