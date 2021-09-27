
--Llenar Tabla Pais
INSERT INTO pais (nombre_pais)
SELECT DISTINCT pais_tienda
FROM temporal 
UNION
SELECT DISTINCT pais_empleado
FROM temporal 
UNION
SELECT DISTINCT pais_cliente
FROM temporal 
where pais_tienda != '-'
  and pais_empleado != '-'
  and pais_cliente != '-'
;

--llenando la Tabla Ciudad
INSERT INTO ciudad(nombre_ciudad, id_pais)
SELECT DISTINCT ciudad_tienda, id_pais
FROM temporal, pais
WHERE ciudad_tienda != '-'
  AND nombre_pais = pais_tienda
UNION
SELECT DISTINCT ciudad_empleado, id_pais
FROM temporal, pais
WHERE ciudad_empleado != '-' 
  AND nombre_pais = pais_empleado
UNION
SELECT DISTINCT ciudad_cliente, id_pais
FROM temporal, pais
WHERE ciudad_cliente != '-'
  AND nombre_pais = pais_cliente
;

--Llenando Tabla Tienda
INSERT INTO tienda(nombre_tienda, direccion_tienda)
SELECT DISTINCT temporal.nombre_tienda, temporal.direccion_tienda
FROM temporal
WHERE temporal.nombre_tienda != '-'
  AND temporal.direccion_tienda != '-';
 

--Llenando Tabla Cliente
INSERT INTO cliente(nombre_cliente, apellido_cliente, direccion_cliente, correo_cliente, fecharegistro_cliente, 
					estado_cliente, tiendaf_cliente, id_ciudad)		
					
SELECT DISTINCT split_part(temporal.nombre_cliente, ' ', 1),
				split_part(temporal.nombre_cliente, ' ', 2),  
                temporal.direccion_cliente,
                temporal.correo_cliente,
                TO_DATE(temporal.fecha_creacion, 'DD/MM/YYYY'),
                temporal.cliente_activo,
                temporal.tienda_preferida,
                ciudad.id_ciudad 
                
FROM temporal
	inner join ciudad on temporal.ciudad_cliente = ciudad.nombre_ciudad
    inner join tienda on temporal.tienda_preferida = tienda.nombre_tienda
    inner join pais	on pais.nombre_pais = temporal.pais_cliente 
    	   AND ciudad.id_pais = pais.id_pais
WHERE ciudad.nombre_ciudad = temporal.ciudad_cliente
  AND temporal.fecha_creacion != '-'
;


--Llenando Tabla Empleado
INSERT INTO empleado(nombre_empleado, apellido_empleado, direccion_empleado, correo_empleado, username_empleado,
                      contraseña_empleado, encargado, id_tienda, id_ciudade)
                      
SELECT DISTINCT split_part(temporal.nombre_empleado, ' ', 1),
				split_part(temporal.nombre_empleado, ' ', 2), 
                temporal.direccion_empleado,
                temporal.correo_empleado,
                temporal.usuario_empleado,
                temporal.contrasenia_empleado,
                temporal.encargado_tienda,
                tienda.id_tienda,
                ciudad.id_ciudad
FROM temporal, tienda, ciudad
WHERE ciudad.nombre_ciudad = temporal.ciudad_empleado
  AND tienda.nombre_tienda = temporal.nombre_tienda
;


--Tabla Clasificacion
INSERT INTO clasificacion(nombre_clasificacion)
SELECT DISTINCT temporal.clasificacion
from temporal
where temporal.clasificacion != '-';


--Tabla Categoria
INSERT INTO categoria(nombre_categoria)
SELECT DISTINCT temporal.categoria_pelicula
from temporal
where temporal.categoria_pelicula != '-';


--Tabla Actor
INSERT INTO actor (nombre_actor, apellido_actor)
SELECT DISTINCT split_part(temporal.actor_pelicula, ' ', 1),
				split_part(temporal.actor_pelicula, ' ', 2)
FROM temporal
where temporal.actor_pelicula != '-';


--llenando la Tabla Pelicula
INSERT INTO pelicula(nombre_pelicula, descripcion_pelicula, lanzamiento_pelicula, duracion_pelicula, dias_pelicula,
                     costorenta_pelicula, costodaño_pelicula, id_clasificacion)
SELECT DISTINCT temporal.nombre_pelicula, 
				temporal.descripcion_pelicula,
				temporal.anio_lanzamiento::INT,
                temporal.duracion::INT,
                temporal.dias_renta::INT,
                temporal.costo_renta::DECIMAL,
                temporal.costo_por_danio::DECIMAL,
                clasificacion.id_clasificacion                 
FROM temporal, clasificacion
WHERE temporal.nombre_pelicula != '-'
  AND temporal.descripcion_pelicula != '-'
  AND temporal.anio_lanzamiento != '-'
  AND temporal.duracion != '-'
  AND temporal.dias_renta != '-'
  AND temporal.costo_renta != '-'
  AND temporal.costo_por_danio != '-'
  AND clasificacion.nombre_clasificacion = temporal.clasificacion;

 
--LLENANDO LA TABLA RENTA
INSERT INTO renta(fecha_renta, fecharetorno_renta, fechapago_renta, monto_renta, id_clienter, id_empleador, id_pelicular)
select distinct TO_DATE(temporal.fecha_renta, 'DD/MM/YYYY HH24:MI'), 
				temporal.fecha_retorno,
				TO_DATE(temporal.fecha_pago, 'DD/MM/YYYY HH24:MI'),
				temporal.monto_a_pagar::DECIMAL, 
				cliente.id_cliente,
                empleado.id_empleado,
                pelicula.id_pelicula
FROM temporal, cliente, empleado, pelicula
WHERE temporal.monto_a_pagar != '-'
  AND temporal.fecha_renta != '-'
  AND temporal.fecha_pago != '-'
  AND cliente.correo_cliente = temporal.correo_cliente
  AND empleado.username_empleado = temporal.usuario_empleado
  AND pelicula.nombre_pelicula = temporal.nombre_pelicula;

 
--Llenando la tabla Inventario

INSERT INTO inventario(id_pelicula, id_tienda, existencias)
SELECT DISTINCT pelicula.id_pelicula,
                tienda.id_tienda,
                count(*)
FROM pelicula, tienda, temporal
WHERE temporal.nombre_pelicula = pelicula.nombre_pelicula
  and temporal.tienda_pelicula = tienda.nombre_tienda
  group by id_pelicula, id_tienda
;


--lleando la tabla categoria pelicula
INSERT INTO categoria_pelicula(id_categoria, id_pelicula)
SELECT DISTINCT categoria.id_categoria, pelicula.id_pelicula
FROM categoria,
     pelicula,
     temporal
where temporal.categoria_pelicula = categoria.nombre_categoria
  and temporal.nombre_pelicula = pelicula.nombre_pelicula
;


--llenado la tabla descp actor
INSERT INTO descp_actor(id_actor, id_pelicula)
SELECT DISTINCT actor.id_actor, pelicula.id_pelicula
FROM actor, pelicula, temporal
WHERE temporal.actor_pelicula = actor.nombre_actor || ' ' || actor.apellido_ACTOR
  AND temporal.nombre_pelicula = pelicula.nombre_pelicula
;


--llenado la tabla idioma
INSERT INTO idioma(nombre_idioma)
SELECT DISTINCT lenguaje_pelicula FROM temporal
WHERE lenguaje_pelicula != '-'
;


--llenado la tabla traduccion pelicula
insert into traduccion_pelicula (id_Idioma, id_pelicula)
select distinct idioma.id_idioma , pelicula.id_pelicula 
from idioma, pelicula, temporal
where temporal.lenguaje_pelicula = idioma.nombre_idioma
  AND temporal.nombre_pelicula = pelicula.nombre_pelicula
;
