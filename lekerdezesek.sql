-- 1. lekérdezés

select distinct t.nev as 'Tanuló neve'
from  jarmuvek j join oktatok ok on j.jarmu_id = ok.jarmu_id 
	join tanulok t on ok.id = t.oktato_id 
	join orarend ora on ora.tanulo_id= t.id 
    	join kategoriak k on k.kat_id=j.kategoria_id 
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
FROM kategoriak k JOIN jarmuvek j ON k.kat_id = j.kategoria_id
		JOIN oktatok o on j.jarmu_id = o.jarmu_id
                JOIN tanulok t ON o.id = t.oktato_id
GROUP BY ROLLUP(k.rovidites, o.nev)

-- 3. lekérdezés

select  iif(n.nap is null, 'Összesen', n.nap) as 'Nap',
        iif(ok.nev is null, iif(n.nap is null, 'Heti  összes','Napi összes'), ok.nev) as 'Oktató neve',
		count(*) as 'Órák száma'
from orarend ora JOIN tanulok t on ora.tanulo_id = t.id
	JOIN oktatok ok ON ok.id=t.oktato_id join napok n on n.id = ora.nap_id
GROUP BY rollup (n.nap,ok.nev)
order BY n.nap

-- 4. lekérdezés

SELECT 
  IIF(t.nev IS NULL, 'Összesen', t.nev) AS Név,
  SUM(k.oradij) AS 'Heti költség'
FROM orarend o JOIN tanulok t ON o.tanulo_id = t.id
			   JOIN oktatok ok on ok.id = t.oktato_id 
               JOIN jarmuvek j on j.jarmu_id = ok.jarmu_id 
               JOIN kategoriak k on k.kat_id=j.kategoria_id 
GROUP BY rollup (t.nev) --, t.id
ORDER BY 'Heti költség' DESC
