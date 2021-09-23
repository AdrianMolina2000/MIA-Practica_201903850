drop table if exists public.temporal;


CREATE TABLE temporal (
    NOMBRE_CLIENTE          VARCHAR(200),
    CORREO_CLIENTE          VARCHAR(200),
    CLIENTE_ACTIVO          VARCHAR(200),
    FECHA_CREACION          VARCHAR(200),
    TIENDA_PREFERIDA        VARCHAR(200),
    DIRECCION_CLIENTE       VARCHAR(200),
    CODIGO_POSTAL_CLIENTE   VARCHAR(200),
    CIUDAD_CLIENTE          VARCHAR(200),
    PAIS_CLIENTE            VARCHAR(200),
    FECHA_RENTA             VARCHAR(200),
    FECHA_RETORNO           VARCHAR(200),
    MONTO_A_PAGAR           VARCHAR(200),
    FECHA_PAGO              VARCHAR(200),
    NOMBRE_EMPLEADO         VARCHAR(200),
    CORREO_EMPLEADO         VARCHAR(200),
    EMPLEADO_ACTIVO         VARCHAR(200),
    TIENDA_EMPLEADO         VARCHAR(200),
    USUARIO_EMPLEADO        VARCHAR(200),
    CONTRASENIA_EMPLEADO    VARCHAR(200),
    DIRECCION_EMPLEADO      VARCHAR(200),
    CODIGO_POSTAL_EMPLEADO  VARCHAR(200),
    CIUDAD_EMPLEADO         VARCHAR(200),
    PAIS_EMPLEADO           VARCHAR(200),
    NOMBRE_TIENDA           VARCHAR(200),
    ENCARGADO_TIENDA        VARCHAR(200),
    DIRECCION_TIENDA        VARCHAR(200),
    CODIGO_POSTAL_TIENDA    VARCHAR(200),
    CIUDAD_TIENDA           VARCHAR(200),
    PAIS_TIENDA             VARCHAR(200),
    TIENDA_PELICULA         VARCHAR(200),
    NOMBRE_PELICULA         VARCHAR(200),
    DESCRIPCION_PELICULA    VARCHAR(200),
    ANIO_LANZAMIENTO        VARCHAR(200),
    DIAS_RENTA              VARCHAR(200),
    COSTO_RENTA             VARCHAR(200),
    DURACION                VARCHAR(200),
    COSTO_POR_DANIO         VARCHAR(200),
    CLASIFICACION           VARCHAR(200),
    LENGUAJE_PELICULA       VARCHAR(200),
    CATEGORIA_PELICULA      VARCHAR(200),
    ACTOR_PELICULA          VARCHAR(200)
    );
    
   
COPY public.temporal from '/home/roshgard/Escritorio/[MIA]Practica1_201903850/BlockBusterData2.csv' delimiter ';' csv header;       













