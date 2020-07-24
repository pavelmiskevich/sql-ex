--������� ��������������, ������� ����������� �� ��� ��
--�� ��������� �� ����� 750 ���, ��� � ��-�������� �� ��������� �� ����� 750 ���.
--�������: Maker
--    ����� �������� ����������
--    ����������� � ��������
-- ������� -------------------------------------------------------------
select pr.maker from Product pr
left join PC pc on pc.model = pr.model
join Laptop lp on lp.model = pr.model
where pc.speed >= 750 and lp.speed >=750
-- ������� -------------------------------------------------------------
select distinct t1.maker from (select pr.maker from Product pr
join PC pc on pc.model = pr.model where pc.speed >= 750) t1
join (select pr.maker from Product pr
join Laptop lp on lp.model = pr.model where lp.speed >=750
) t2 on t2.maker = t1.maker

--cost	0.032857276499271
--operations	9

-- GIT HUB
SELECT DISTINCT maker 
    FROM product t1 JOIN pc t2 ON t1.model = t2.model 
    WHERE speed >= 750 
      AND maker IN (SELECT maker 
                        FROM product t1 JOIN laptop t2 ON t1.model = t2.model 
                        WHERE speed >= 750)

--cost	0.036176130175591
--operations	10

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=23#20