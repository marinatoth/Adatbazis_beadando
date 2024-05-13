-- 1. lekérdezés

select t.nev
from oktatok ok join tanulok t on ok.id = t.oktato_id 
	join orarend ora on ora.tanulo_id= t.id 
    join kategoriak k on k.kat_id=ok.kategoria_id 
    join napok n on n.id=ora.nap_id
where n.nap = 'Hétfő' and k.rovidites = 'B'

-- 2. lekérdezés
	
SELECT IIF(GROUPING_ID(k.rovidites) = 1, 'Végösszeg', CAST(k.rovidites as nvarchar(4))) AS 'Jogosítvány típusa',
       CASE 
         WHEN GROUPING_ID(k.rovidites, o.nev) = 1 THEN 'Részösszeg'
         WHEN GROUPING_ID(k.rovidites, o.nev) = 3 THEN 'Végösszeg'
         ELSE o.nev 
       END AS 'Oktató neve',
       COUNT(*) AS 'Tanulók száma'
FROM jarmuvek j JOIN oktatok o on j.jarmu_id = o.jarmu_id
				JOIN kategoriak k ON j.kategoria_id = k.kat_id
                JOIN tanulok t ON o.id = t.oktato_id
GROUP BY ROLLUP(k.rovidites, o.nev)

-- 3. lekérdezés
