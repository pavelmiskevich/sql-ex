--��� ������� �������� �������� ��, ������������ 600 ���, ���������� ������� ���� �� � ����� �� ���������. �������: speed, ������� ����.
--    ����������� GROUP BY
-- ������� -------------------------------------------------------------

-- ������� -------------------------------------------------------------
select speed, avg(price) from PC
where speed > 600
group by speed

--cost	0.014792243018746
--operations	4

-- GIT HUB
SELECT pc.speed, AVG(pc.price) 
    FROM pc 
    WHERE pc.speed > 600 
    GROUP BY pc.speed 

--cost	0.014792243018746
--operations	4

--FORUM
--https://www.sql-ex.ru/forum/Lforum.php?F=3&N=22#20