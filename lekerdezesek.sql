-- 1. lekérdezés

SELECT DISTINCT t.nev AS 'Tanuló neve'
FROM  jarmuvek j JOIN oktatok ok ON j.jarmu_id = ok.jarmu_id 
	JOIN tanulok t ON ok.id = t.oktato_id 
	JOIN orarend ora ON ora.tanulo_id= t.id 
    	JOIN kategoriak k ON k.kat_id=j.kategoria_id 
    	JOIN napok n ON n.id=ora.nap_id
WHERE n.nap = 'Hétfő' AND k.rovidites = 'B'

-- 2. lekérdezés
	
SELECT IIF(GROUPING_ID(k.rovidites) = 1, 'Végösszeg', CAST(k.rovidites AS nvarchar(4))) AS 'Jogosítvány típusa',
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

SELECT iif(n.nap IS NULL, 'Összesen', n.nap) AS 'Nap',
        iif(ok.nev IS NULL, iif(n.nap IS NULL, 'Heti  összes','Napi összes'), ok.nev) AS 'Oktató neve',
		COUNT(*) AS 'Órák száma'
FROM orarend ora JOIN tanulok t ON ora.tanulo_id = t.id
	JOIN oktatok ok ON ok.id=t.oktato_id JOIN napok n ON n.id = ora.nap_id
GROUP BY ROLLUP(n.nap,ok.nev)
ORDER BY n.nap

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

-- 5. lekérdezés

SELECT IIF(GROUPING(alkorosztaly) = 1, 'Összesen', alkorosztaly) AS 'Korosztály',
    COUNT(*) AS 'Tanulók száma'
FROM 
    (SELECT 
        CASE
            WHEN DATEDIFF(year, szul_dat, GETDATE()) < 21 THEN 'Serdülő'
            WHEN DATEDIFF(year, szul_dat, GETDATE()) BETWEEN 21 AND 34 THEN 'Fiatal felnőtt'
            WHEN DATEDIFF(year, szul_dat, GETDATE()) BETWEEN 35 AND 59 THEN 'Középkorú'
            ELSE 'Idős'
        END AS alkorosztaly
    FROM tanulok) AS belso
GROUP BY ROLLUP(alkorosztaly)
ORDER BY COUNT(*)

-- 6. lekérdezés
	
SELECT 
    o.nev AS oktato, 
    k.megnevezes, 
    j.rendszam, 
    j.muszaki_vizsga, 
	(-1)*(DATEDIFF(day, dateadd(day, 730, j.muszaki_vizsga), getdate())) AS 'napok a következő műszaki vizsgáig',
    j.marka,
    j.tipus
FROM jarmuvek j 
	LEFT JOIN kategoriak k on k.kat_id=j.kategoria_id 
    LEFT JOIN oktatok o ON j.jarmu_id=o.jarmu_id
ORDER BY j.muszaki_vizsga
