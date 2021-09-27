# Consulta
-- inner join ciudad on temporal.ciudad_cliente =ciudad.nombre_ciudad
Select sum(existencias),TIENDA.NOMBRE_TIENDA from Inventario
Inner join pelicula on Inventario.id_pelicula = pelicula.id_pelicula
INNER JOIN TIENDA ON INVENTARIO.ID_TIENDA= TIENDA.ID_TIENDA
where pelicula.nombre_pelicula='SUGAR WONKA'
group by  TIENDA.NOMBRE_TIENDA;


#Consulta2

select cl.nombre_cliente   name_ ,cl.apellido_cliente  last_, sum(rent.monto_renta)  mount_,
count (rent.id_clienter)  Total_ from  renta rent
inner   join cliente cl on cl.id_cliente = rent.id_clienter

HAVING COUNT(rent.id_clienter) >=40



group by cl.nombre_cliente , cl.apellido_cliente;

#Consulta3

SELECT DISTINCT
    cl.nombre_cliente,
    cl.apellido_cliente,
    p.nombre_pelicula
FROM
         renta rent
    INNER JOIN cliente  cl ON cl.id_cliente = rent.id_clienter
    INNER JOIN pelicula p ON p.id_pelicula = rent.id_pelicular
WHERE
        p.dias_pelicula < to_date(rent.fecharetorno_renta, 'DD/MM/YYYY  HH24:MI') - rent.fecha_renta
    AND rent.fecharetorno_renta NOT IN '-'
GROUP BY
    cl.nombre_cliente,
    cl.apellido_cliente,
    p.nombre_pelicula


    #consulta 4
SELECT DISTINCT nombre_actor ||' ' || apellido_actor  as efe from actor
where
(select instr(actor.apellido_actor,'son' )from dual ) >=1

ORDER BY efe ;

#consulta 5
select apellido_Actor, count(*) as efe from actor


having count(*)>=2


group by apellido_Actor


#consulta 6


select  A.nombre_actor, A.apellido_actor,P.LANZAMIENTO_PELICULA from DESCP_ACTOR D

INNER JOIN  ACTOR A ON A.ID_ACTOR= D.ID_ACTOR
INNER JOIN  PELICULA  P ON P.ID_PELICULA= D.ID_PELICULA

WHERE (select instr(P.nombre_pelicula,'SPOILER' )from dual ) >=1

GROUP BY  A.nombre_actor, A.apellido_actor,P.LANZAMIENTO_PELICULA
ORDER BY A.APELLIDO_aCTOR;
;

# Consulta 7

SELECT CATEGORIA.NOMBRE_CATEGORIA , COUNT(pELICULA.NOMBRE_PELICULA) AS Cantidad
FROM CATEGORIA  INNER JOIN categoria_pelicula CA ON CA.id_CATEGORIA = cATEGORIA.ID_CATEGORIA
INNER JOIN PELICULA  ON pELICULA.ID_PELICULA = CA.id_pelicula
HAVING COUNT(pELICULA.NOMBRE_PELICULA) BETWEEN 55 AND 65
GROUP BY cATEGORIA.NOMBRE_CATEGORIA ORDER BY Cantidad DESC;

#Consulta 8
select DISTINCT CT.nombre_categoria , (AVG(P.COSTODAÑO_PELICULA-P.COSTORENTA_PELICULA)) prom from categoria_pelicula c


INNER JOIN PELICULA P ON P.ID_PELICULA=C.ID_PELICULA
INNER JOIN CATEGORIA CT ON C.ID_CATEGORIA= CT.ID_CATEGORIA


having (AVG(P.COSTODAÑO_PELICULA-P.COSTORENTA_PELICULA)) >17
group by ct.nombre_categoria


;
--Consulta 9

select  distinct actor.nombre_Actor, actor.apellido_Actor,pelicula.nombre_pelicula from
descp_actor D

INNER JOIN  ACTOR ON ACTOR.ID_ACTOR= D.ID_ACTOR
INNER JOIN  PELICULA   ON PELICULA.ID_PELICULA= D.ID_PELICULA
    where

pelicula.id_pelicula in
(select distinct  d.id_pelicula as p
from descp_actor d
          having count(*) >= 1
group by d.id_pelicula)

and actor.id_Actor in



(select id_actor as a
from descp_actor
having count(*)>=1
group by id_actor)

;

--CONSULTA 10

select NOMBRES || ' ' || APELLIDOS
from
     (
         SELECT (SELECT REGEXP_SUBSTR(NOMBRE_aCTOR, '[^ ]+', 1, 1)
                 FROM DUAL)                                                     NOMBRES,

                (SELECT REGEXP_SUBSTR(APELLIDO_aCTOR, '[^ ]+', 1, 1) FROM DUAL) APELLIDOS
         FROM ACTOR

         UNION
         SELECT (SELECT REGEXP_SUBSTR(NOMBRE_CLIENTE, '[^ ]+', 1, 1)
                 FROM DUAL)                                                       NOMBRES,

                (SELECT REGEXP_SUBSTR(APELLIDO_CLIENTE, '[^ ]+', 1, 1) FROM DUAL) APELLIDOS
         FROM CLIENTE
     ) T1

         INNER JOIN
     (
         SELECT (SELECT REGEXP_SUBSTR(NOMBRE_aCTOR, '[^ ]+', 1, 1)
                 FROM DUAL)                                                     nombReA,

                (SELECT REGEXP_SUBSTR(APELLIDO_aCTOR, '[^ ]+', 1, 1) FROM DUAL) apellidoA         FROM ACTOR
         WHERE NOMBRE_aCTOR LIKE 'Matthew' and apellido_Actor like'Johansson'
     ) T2
     ON NOMBRES = NOMBREA
WHERE APELLIDOS <> APELLIDOA
;

-Consulta 11

select cliente_Datos.nombre,
       cliente_Datos.pais_cliente,
       cliente_Datos.numero_cliente,
  cliente_Datos.numero_cliente  *100 /count(rent.id_pelicular)
from (select CL.NOMBRE_CLIENTE || ' ' || CL.APELLIDO_CLIENTE NOMBRE,
             P.NOMBRE_PAIS                                   PAIS_CLIENTE,
             cliente_MAX.t                                   numero_cliente,
             cl.id_cliente                                   id_client
      FROM (select id_clienter IDC, count(id_clienter) t
            from renta

            group by id_Clienter
            order by t DESC
           ) cliente_MAX

               INNER JOIN CLIENTE CL ON CL.ID_CLIENTE = CLIENTE_MAX.IDC
               INNER JOIN CIUDAD CI ON CI.Id_CIUDAD = CL.ID_CIUDAD
               INNER JOIN PAIS P ON P.ID_PAIS = CI.ID_PAIS


      WHERE ROWNUM = 1
     ) cliente_Datos


         inner join renta rent on cliente_Datos.id_client = rent.id_clienter
         inner join cliente client
                    on client.id_cliente = rent.id_clienter
         INNER JOIN CIUDAD CIty ON CIty.Id_CIUDAD = CLient.ID_CIUDAD
         INNER JOIN PAIS Pa ON Pa.ID_PAIS = CIty.ID_PAIS

  group by  cliente_Datos.nombre,
       cliente_Datos.pais_cliente,
       cliente_Datos.numero_cliente
;

--consulta 13

SELECT PaisC, Cliente, RENTAS_t
FROM
(SELECT PaisC, MAX(total_rentas) AS RENTAS_t
FROM
(SELECT   CL.NOMBRE_cliente||' '|| CL.APELLIDO_cliente  Nombre_Cliente,COUNTRY.NOMBRE_pais  PaisC, COUNT(rent.id_CLIENTEr)  total_rentas
FROM PAIS COUNTRY INNER JOIN CIUDAD c ON c.id_PAIS = COUNTRY.ID_PAIS

INNER JOIN CLIENTE CL ON CL.id_CIUDAD = c.ID_CIUDAD
INNER JOIN renta RENT ON CL.ID_CLIENTE = RENT.id_CLIENTEr
GROUP BY  CL.NOMBRE_cliente||' '|| CL.APELLIDO_cliente,COUNTRY.NOMBRE_pais
ORDER BY COUNTRY.NOMBRE_pais , COUNT(RENT.id_CLIENTEr) DESC )
GROUP BY PaisC ORDER BY PaisC




)
INNER JOIN
(SELECT  CL.NOMBRE_cliente||' '|| CL.APELLIDO_cliente Cliente, COUNTRY.NOMBRE_pais  Nombre_Pais, COUNT(RENT.id_CLIENTEr)  COUNT_rENTAS
FROM PAIS COUNTRY INNER JOIN CIUDAD c ON c.id_PAIS = COUNTRY.ID_PAIS
INNER JOIN CLIENTE CL ON CL.id_CIUDAD = c.ID_CIUDAD
INNER JOIN renta RENT ON CL.ID_CLIENTE = RENT.id_CLIENTEr
GROUP BY CL.NOMBRE_cliente||' '|| CL.APELLIDO_cliente , COUNTRY.NOMBRE_pais
ORDER BY COUNTRY.NOMBRE_pais , COUNT(RENT.id_CLIENTEr) DESC ) ON PaisC = Nombre_Pais



WHERE COUNT_rENTAS = RENTAS_t;
--CONSULTA 14

SELECT  total.ciudad , total.pais ,total.n_rentas FROM

(select t.ciudad ciudad,t.pais pais ,max(t.cont) n_rentas from
(select CI.NOMBRE_CIUDAD ciudad, PI.NOMBRE_PAIS pais ,cat.nombre_categoria categoria,COUNT(*) cont
FROM PAIS PI
         INNER JOIN CIUDAD CI ON CI.ID_PAIS = PI.ID_PAIS
         INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
         INNER JOIN RENTA RENT ON CL.ID_CLIENTE = RENT.ID_CLIENTER
         INNER JOIN PELICULA P ON RENT.ID_PELICULAR = P.ID_PELICULA
         INNER JOIN CATEGORIA_PELICULA CAT_P ON P.ID_PELICULA = CAT_P.ID_PELICULA
         INNER JOIN CATEGORIA  CAT ON CAT_P.ID_CATEGORIA = CAT.ID_CATEGORIA

         group by   CI.NOMBRE_CIUDAD, PI.NOMBRE_PAIS,cat.nombre_categoria) t

group by  t.ciudad, t.pais order by  t.ciudad, t.pais desc)TOTAL

INNER JOIN

   ( select CI.NOMBRE_CIUDAD ciudad, PI.NOMBRE_PAIS pais ,cat.nombre_categoria categoria,COUNT(*) cont
FROM PAIS PI
         INNER JOIN CIUDAD CI ON CI.ID_PAIS = PI.ID_PAIS
         INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
         INNER JOIN RENTA RENT ON CL.ID_CLIENTE = RENT.ID_CLIENTER
         INNER JOIN PELICULA P ON RENT.ID_PELICULAR = P.ID_PELICULA
         INNER JOIN CATEGORIA_PELICULA CAT_P ON P.ID_PELICULA = CAT_P.ID_PELICULA
         INNER JOIN CATEGORIA  CAT ON CAT_P.ID_CATEGORIA = CAT.ID_CATEGORIA

         group by   CI.NOMBRE_CIUDAD, PI.NOMBRE_PAIS,cat.nombre_categoria) T2

 ON TOTAL.pais =t2.pais
and TOTAL.CIUDAD=T2.CIUDAD
AND total.n_rentas=t2.cont
where categoria='Horror' and t2.categoria='Horror'
order by  total.pais asc
;
--CONSULTA 15?
select t1.PAIS,t1.CIUDAD, round(t1.total_rentas / t2.total_pais,2) efe
from (SELECT PAIS.NOMBRE_PAIS     AS PAIS,
             CIUDAD.NOMBRE_CIUDAD AS CIUDAD,
             COUNT(*)             AS total_rentas
      FROM PAIS
               INNER JOIN
           CIUDAD
           ON
               PAIS.ID_PAIS = CIUDAD.ID_PAIS
               INNER JOIN
           CLIENTE
           ON
               CIUDAD.ID_CIUDAD = CLIENTE.ID_CIUDAD
               INNER JOIN
           RENTA
           ON
               RENTA.ID_CLIENTER = CLIENTE.ID_CLIENTE
      GROUP BY PAIS.NOMBRE_PAIS,
               CIUDAD.NOMBRE_CIUDAD) t1
         inner join
     (SELECT PAIS.NOMBRE_PAIS pais, COUNt(*) total_pais
      FROM PAIS
               INNER JOIN CIUDAD ON CIUDAD.ID_PAIS = PAIS.ID_PAIS
      GROUP BY PAIS.NOMBRE_PAIS) t2
     on t1.PAIS = t2.pais
order by t1.PAIS
--CONSULTA 16
SELECT T.PAIS, T.CONT * 100 / T2.CONT || '%' as tt
FROM (
         select distinct PI.NOMBRE_PAIS pais, COUNT(*) cont
         FROM PAIS PI
                  INNER JOIN CIUDAD CI ON CI.ID_PAIS = PI.ID_PAIS
                  INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
                  INNER JOIN RENTA RENT ON CL.ID_CLIENTE = RENT.ID_CLIENTER
                  INNER JOIN PELICULA P ON RENT.ID_PELICULAR = P.ID_PELICULA
                  INNER JOIN CATEGORIA_PELICULA CAT_P ON P.ID_PELICULA = CAT_P.ID_PELICULA
                  INNER JOIN CATEGORIA CAT ON CAT_P.ID_CATEGORIA = CAT.ID_CATEGORIA
         WHERE CAT.NOMBRE_CATEGORIA = 'Sports'
         group by PI.NOMBRE_PAIS) t
         INNER JOIN
     (select distinct PI.NOMBRE_PAIS pais, COUNT(*) cont
      FROM PAIS PI
               INNER JOIN CIUDAD CI
                          ON CI.ID_PAIS = PI.ID_PAIS
               INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
               INNER JOIN RENTA RENT ON CL.ID_CLIENTE = RENT.ID_CLIENTER

      group by PI.NOMBRE_PAIS) T2
     ON T.pais = T2.pais


group by t.pais, T.CONT * 100 / T2.CONT || '%'
ORDER BY T.PAIS desc



--consulta 17
.
select   pi.nombre_pais ,ci.nombre_ciudad  ,count(*)from

             (select distinct CI.NOMBRE_CIUDAD ciudad, PI.NOMBRE_PAIS pais, COUNT(*) cont
FROM PAIS PI
         INNER JOIN CIUDAD CI ON CI.ID_PAIS = PI.ID_PAIS
         INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
         INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
         INNER JOIN RENTA RENT ON CL.ID_CLIENTE = RENT.ID_CLIENTER

where  ci.nombre_ciudad='Dayton'
group by CI.NOMBRE_CIUDAD, PI.NOMBRE_PAIS)t1,

PAIS PI
         INNER JOIN CIUDAD CI ON CI.ID_PAIS = PI.ID_PAIS
         INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
         INNER JOIN CLIENTE CL ON CL.ID_CIUDAD = CI.ID_CIUDAD
         INNER JOIN RENTA RENT ON CL.ID_CLIENTE = RENT.ID_CLIENTER
     where pi.nombre_pais='United States'
having count(*)>t1.cont
group by CI.NOMBRE_CIUDAD, PI.NOMBRE_PAIS,t1.cont



;
--consulta 18

SELECT  t.NOMBRE, t.apellidoC, trunc( to_date(renta.fecharetorno_renta, 'DD/MM/YYYY  HH24:MI')  )
FROM RENTA
         inner join
     (select  CLIENTE.ID_CLIENTE ID_C, cliente.nombre_cliente NOMBRE, cliente.apellido_cliente apellidoC, count(*) efe

      from renta
               inner join cliente on renta.id_clienter = cliente.id_cliente

      group by  cliente.ID_CLIENTE,cliente.nombre_cliente, cliente.apellido_cliente
      having count(*) > 2
      order by efe desc) T
     ON T.ID_C = RENTA.ID_CLIENTER

         INNER JOIN
     (select renta.ID_EMPLEADOR empelado, renta.FECHA_RENTA renta, sum(renta.MONTO_RENTA)
      from renta
      group by renta.ID_EMPLEADOR, renta.FECHA_RENTA
      having sum(renta.MONTO_RENTA) > 15
     ) t2
     on t2.renta = renta.FECHA_RENTA
         and RENTA.ID_EMPLEADOR = t2.empelado
where renta.FECHARETORNO_RENTA !='-'

order by trunc( to_date(renta.fecharetorno_renta, 'DD/MM/YYYY  HH24:MI')  )desc
--consulta 19



select extract(month  from  renta.FECHA_RENTA)  mes,efe.NOMBRE from renta,
(select CL.NOMBRE_CLIENTE || ' ' || CL.APELLIDO_CLIENTE NOMBRE,
             P.NOMBRE_PAIS                                   PAIS_CLIENTE,

             cl.id_cliente                                   id_client
      FROM (select id_clienter IDC, count(id_clienter) t
            from renta

            group by id_Clienter
            order by t DESC
           ) cliente_MAX

               INNER JOIN CLIENTE CL ON CL.ID_CLIENTE = CLIENTE_MAX.IDC
               INNER JOIN CIUDAD CI ON CI.Id_CIUDAD = CL.ID_CIUDAD
               INNER JOIN PAIS P ON P.ID_PAIS = CI.ID_PAIS


      WHERE ROWNUM = 1) efe
  where renta.ID_CLIENTER =efe.id_client

union all


select extract(month  from  renta.FECHA_RENTA)  mes,efe.NOMBRE from renta,
(select CL.NOMBRE_CLIENTE || ' ' || CL.APELLIDO_CLIENTE NOMBRE,
             P.NOMBRE_PAIS                                   PAIS_CLIENTE,

             cl.id_cliente                                   id_client
      FROM (select id_clienter IDC, count(id_clienter) t
            from renta

            group by id_Clienter
            order by t asc
           ) cliente_MAX

               INNER JOIN CLIENTE CL ON CL.ID_CLIENTE = CLIENTE_MAX.IDC
               INNER JOIN CIUDAD CI ON CI.Id_CIUDAD = CL.ID_CIUDAD
               INNER JOIN PAIS P ON P.ID_PAIS = CI.ID_PAIS


      WHERE ROWNUM = 1) efe
  where renta.ID_CLIENTER =efe.id_client



--consulta 20


select  T.ciudad,'ENGLISH','100%'
from

(select ciudad.nombre_ciudad ciudad,count(renta.ID_CLIENTER)  efe from
renta inner join cliente on cliente.ID_CLIENTE = renta.ID_CLIENTER
inner join ciudad on CIUDAD.ID_CIUDAD= cliente.ID_CIUDAD
where (select extract(month  from  renta.FECHA_RENTA)from dual) = 7 and  (select extract(year  from  renta.FECHA_RENTA)from dual) =2005
group by  ciudad.nombre_ciudad order by efe asc
    )T;
    
