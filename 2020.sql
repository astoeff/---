-- 2020-09-1

-- УСЛОВИЕ
-- Да се напише заявка, която извежда имената и адресите на всички студиа, които имат поне
-- един цветен и поне един черно-бял филм. Резултатът да се сортира възходящо по адрес.

-- РЕШЕНИЕ
-- 1-ви начин: 
SELECT s.name, s.address
FROM studio s
WHERE s.name in 
(SELECT s.name
FROM studio s
JOIN movie m
ON s.name=m.studioname
WHERE m.incolor='Y')
AND
s.name in
(SELECT s.name
FROM studio s
JOIN movie m
ON s.name=m.studioname
WHERE m.incolor='N');

-- 2-ри начин:
select s.name, s.address 
from studio s 
where 
(select count(*) from movie m where m.studioname = s.name and incolor = 'Y') > 0 
and 
(select count(*) from movie m where m.studioname = s.name and incolor = 'N') > 0;

-- 2020-09-2

-- УСЛОВИЕ
-- Да се напише заявка, която за всяко студио с най-много три филма извежда: • името му;
-- • адреса;
-- • средната дължина на филмите на това студио.
-- Студиа без филми също да се изведат (за средна дължина да се извежда null или 0).

-- РЕШЕНИЕ
SELECT s.name, s.address, AVG(m.length)
FROM studio s LEFT JOIN movie m ON s.name = m.studioname
GROUP BY s.name
HAVING COUNT(*) <= 3;

-- 2019-08-1

-- УСЛОВИЕ
-- Да се напише заявка, която извежда имената и рождените дати на всички филмови звезди, 
-- чието име не съдържа "Jr." и са играли в поне един цветен филм. 
-- Първо да се изведат най-младите звезди, а звезди, родени на една и съща дата, 
-- да се изведат по азбучен ред.

-- РЕШЕНИЕ
-- 1-ви начин
SELECT si.starname, ms.birthdate
FROM starsin si
JOIN movie m
ON si.movietitle = m.title and si.movieyear = m.year
JOIN moviestar ms
ON si.starname = ms.name
WHERE si.starname NOT LIKE "%Jr%" AND m.incolor = 'Y'
GROUP BY ms.name
ORDER BY ms.birthdate DESC, ms.name ASC;

-- 2-ри начин
select ms.name, ms.birthdate, count(*)
from moviestar ms join starsin si on ms.name = si.starname
where 
	ms.name not like '%Jr.%' 
and 
	si.movietitle in (select m.title from movie m where m.incolor = 'Y')
group by ms.name
order by ms.birthdate desc, ms.name asc;

-- 2019-08-2

-- УСЛОВИЕ
-- Да се напише заявка, която извежда следната информация за всяка актриса, играла в най-много 6 филма:
-- • име;
-- • рождена година (напр. ако актрисата е родена на 1.1.1995 г., в колоната да пише 1995); 
-- • брой различни студиа, с които е работила.
-- Ако за дадена актриса няма информация в какви филми е играла, 
-- за нея също да се изведе ред с горната информация, като за брой студиа се изведе 0.

--РЕШЕНИЕ
select ms.name, year(ms.birthdate) as year, count(distinct m.studioname)
from moviestar ms 
	left join starsin si on ms.name = si.starname
    left join movie m on si.movietitle = m.title
where ms.gender = 'F'
group by ms.name
having count(*) <= 6
