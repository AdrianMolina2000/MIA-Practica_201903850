--Consulta 1
SELECT sum(existencias), tienda.nombre_tienda FROM inventario
INNER JOIN pelicula ON Inventario.id_pelicula = pelicula.id_pelicula
INNER JOIN tienda ON inventario.id_tienda = tienda.id_tienda
WHERE LOWER(pelicula.nombre_pelicula) = 'sugar wonka'
GROUP BY tienda.nombre_tienda
;


--Consulta 2
select cliente.nombre_cliente Nombre, cliente.apellido_cliente Apellido, count(renta.id_clienter) Rentas_totales, sum(renta.monto_renta) Pago_Total 
from renta
inner join cliente on cliente.id_cliente = renta.id_clienter
group by cliente.nombre_cliente , cliente.apellido_cliente
HAVING COUNT(renta.id_clienter) >= 40
;


--Consulta 3
select nombre_actor || '  ' || apellido_actor Nombre 
from actor
where LOWER(apellido_actor) like '%son%'
order by nombre_actor asc
;

--Consulta 4
select actor.nombre_actor, actor.apellido_actor, pelicula.lanzamiento_pelicula
from descp_actor
inner join actor on actor.id_actor = descp_actor.id_actor
inner join pelicula on pelicula.id_pelicula = descp_actor.id_pelicula
where LOWER(pelicula.descripcion_pelicula) like '%crocodile%' 
  and LOWER(pelicula.descripcion_pelicula) like '%shark%' 
group by actor.nombre_actor, actor.apellido_actor, pelicula.lanzamiento_pelicula 
order by actor.apellido_actor asc
;

--Consulta 5
select 
	cliente_datos.nombre,
   	cliente_datos.pais_cliente,
    cliente_datos.peliculas_rentadas,
  	cliente_Datos.peliculas_rentadas*100/count(renta.id_renta) Porcentaje
from(
	select 
		cliente.id_cliente id_cliente,
		cliente.nombre_cliente || ' ' || cliente.apellido_cliente nombre,
        pais.nombre_pais pais_cliente,
        cliente_renta.total_rentadas peliculas_rentadas
	from(
    	select 
    		id_clienter, 
    		count(id_clienter) total_rentadas
        from renta
        group by id_clienter
	)cliente_renta
    
    inner join cliente on cliente.id_cliente = cliente_renta.id_clienter
    inner join ciudad on ciudad.id_ciudad = cliente.id_ciudad 
    inner join pais on pais.id_pais = ciudad.id_pais 
    order by cliente_renta.total_rentadas desc
    limit 1
)cliente_datos

inner join renta on renta.id_clienter = cliente_datos.id_cliente
inner join cliente on cliente.id_cliente = renta.id_clienter

group by  
cliente_datos.nombre,
cliente_datos.pais_cliente,
cliente_datos.peliculas_rentadas
--order by cliente_datos.peliculas_rentadas asc
order by cliente_datos.pais_cliente asc
;


--Consulta 6
select 
	total1.pais, 
	total2.ciudad, 
	round((total2.total_clientes::decimal*100/total1.total_clientes),2) || '%' porcentaje, 
	total1.total_clientes 
from(
	select 
		pais.nombre_pais pais, 
		COUNT(*) total_clientes
    from pais 
    inner join ciudad on ciudad.id_pais = pais.id_pais
    inner join cliente on cliente.id_ciudad = ciudad.id_ciudad 
    group by pais.nombre_pais 
)total1
	
inner join(
	select 
		pais.nombre_pais pais, 
		ciudad.nombre_ciudad ciudad, 
		COUNT(*) total_clientes
	    
		from pais 
	    inner join ciudad on pais.id_pais = ciudad.id_pais 
	    inner join cliente on ciudad.id_ciudad = cliente.id_ciudad          
	    group by ciudad.nombre_ciudad, pais.nombre_pais
)total2 on total1.pais = total2.pais
group by total1.pais, total2.ciudad, porcentaje, total1.total_clientes
order by total1.pais
;

--Consulta 7
select 
	t1.pais,
	t1.ciudad, 
	round(t1.total_rentas::decimal/t2.total_pais,2) Promedio
from(
	select 
		pais.nombre_pais pais, 
		ciudad.nombre_ciudad ciudad, 
		COUNT(*) total_rentas
	from pais
    inner join ciudad on pais.id_pais = ciudad.id_pais
    inner join cliente on ciudad.id_ciudad = cliente.id_ciudad 
    inner join renta on renta.id_clienter = cliente.id_cliente
    group by pais.nombre_pais, ciudad.nombre_ciudad
    order by pais
)t1 
inner join(
	select 
		pais.nombre_pais pais, 
		COUNT(*) total_pais
    from pais
    inner join ciudad on ciudad.id_pais = pais.id_pais
    group by pais.nombre_pais
    order by pais
)t2 on t1.pais = t2.pais
order by t1.pais
;


--Consulta 8
select t1.pais, round(t1.cont::decimal*100/t2.cont,2) || '%' prom
from(
	select distinct pais.nombre_pais pais, COUNT(*) cont
    from pais
    inner join ciudad on ciudad.id_pais = pais.id_pais
    inner join cliente on cliente.id_ciudad = ciudad.id_ciudad 
    inner join renta on renta.id_clienter = cliente.id_cliente
    inner join pelicula on renta.id_pelicular = pelicula.id_pelicula
    inner join categoria_pelicula ON categoria_pelicula.id_pelicula = pelicula.id_pelicula 
    inner join categoria ON categoria.id_categoria = categoria_pelicula.id_categoria  
    where Lower(categoria.nombre_categoria) = 'sports'
    group by pais.nombre_pais
)t1 inner join(
	select distinct pais.nombre_pais pais, COUNT(*) cont
    from pais
    inner join ciudad on ciudad.id_pais = pais.id_pais
    inner join cliente on cliente.id_ciudad = ciudad.id_ciudad
    inner join renta on renta.id_clienter = cliente.id_cliente 
    group by pais.nombre_pais
)t2 on t1.pais = t2.pais
group by t1.pais, round(t1.cont::decimal*100/t2.cont,2) || '%'
order by t1.pais asc
;


--Consulta 9
select 
	pais.nombre_pais,
	ciudad.nombre_ciudad,
	count(*)
from(
	select distinct 
		ciudad.nombre_ciudad ciudad, 
		pais.nombre_pais pais, 
		COUNT(*) cont
	from pais 
    inner join ciudad on ciudad.id_pais = pais.id_pais 
    inner join cliente on cliente.id_ciudad = ciudad.id_ciudad
    inner join renta on renta.id_clienter = cliente.id_cliente
	where Lower(ciudad.nombre_ciudad) = 'dayton'
	group by ciudad.nombre_ciudad, pais.nombre_pais 
)t1, pais

inner join ciudad ciudad on ciudad.id_pais = pais.id_pais 
inner join cliente on cliente.id_ciudad = ciudad.id_ciudad
inner join renta on renta.id_clienter = cliente.id_cliente
where lower(pais.nombre_pais) = 'united states'
group by ciudad.nombre_ciudad, pais.nombre_pais, t1.cont
having count(*) > t1.cont
;


--Consulta 10
select 
	total.pais, 
	total.ciudad,
	total.n_rentas 
from(
	select 
		t1.ciudad ciudad, 
		t1.pais pais,
		max(t1.cont) n_rentas 
	from(
		select 
			ciudad.nombre_ciudad ciudad, 
			pais.nombre_pais pais, 
			categoria.nombre_categoria categoria,
			COUNT(*) cont
		from pais
        inner join ciudad on ciudad.id_pais = pais.id_pais
        inner join cliente on cliente.id_ciudad = ciudad.id_ciudad
        inner join renta on renta.id_clienter = cliente.id_cliente
        inner join pelicula on pelicula.id_pelicula = renta.id_pelicular 
        inner join categoria_pelicula on categoria_pelicula.id_pelicula = pelicula.id_pelicula
        inner join categoria on categoria.id_categoria = categoria_pelicula.id_categoria
        group by ciudad.nombre_ciudad, pais.nombre_pais, categoria.nombre_categoria
	)t1
	group by t1.ciudad, t1.pais 
	order by t1.ciudad, t1.pais desc
)total
inner join( 
	select 
		ciudad.nombre_ciudad ciudad, 
		pais.nombre_pais pais, 
		categoria.nombre_categoria categoria,
		COUNT(*) cont
	from pais
    inner join ciudad on ciudad.id_pais = pais.id_pais 
    inner join cliente on cliente.id_ciudad = ciudad.id_ciudad
    inner join renta on renta.id_clienter = cliente.id_cliente
    inner join pelicula on pelicula.id_pelicula = renta.id_pelicular 
    inner join categoria_pelicula on categoria_pelicula.id_pelicula = pelicula.id_pelicula
    inner join categoria on categoria.id_categoria = categoria_pelicula.id_categoria
    group by ciudad.nombre_ciudad, pais.nombre_pais, categoria.nombre_categoria 
)t2 on total.pais = t2.pais 
	and total.ciudad = t2.ciudad
	and total.n_rentas = t2.cont
where lower(categoria) = 'horror' and lower(t2.categoria)='horror'
order by total.pais asc
;
