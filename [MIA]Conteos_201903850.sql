select *
from 
  (select count(*) pais from pais) pais, 
  (select count(*) ciudad from ciudad) ciudad,
  (select count(*) empleado from empleado) empleado,
  (select count(*) cliente from cliente) cliente,
  (select count(*) clasificacion from CLASIFICACION) clasificacion,
  (select count(*) pelicula from pelicula) pelicula,
  (select count(*) categoria from CATEGORIA) Categoria,
  (select count(*) actor from actor) actor,
  (select count(*) traduccion_pelicula from  TRADUCCION_PELICULA) traduccion_pelicula,
  (select count(*) categoria_pelicula from CATEGORIA_PELICULA) categoria_pelicula,
  (select count(*) inventario from INVENTARIO) inventario,
  (select count(*) idioma from  idioma) idioma,
  (select count(*) descp_Actor from DESCP_ACTOR) Descp_Actor,
  (select count(*) renta from renta) renta,
  (select count(*) tienda from tienda) tienda
;
