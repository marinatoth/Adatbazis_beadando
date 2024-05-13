select t.nev
from oktatok ok join tanulok t on ok.id = t.oktato_id 
	join orarend ora on ora.tanulo_id= t.id 
    join kategoriak k on k.kat_id=ok.kategoria_id 
    join napok n on n.id=ora.nap_id
where n.nap = 'Hétfő' and k.rovidites = 'B'
