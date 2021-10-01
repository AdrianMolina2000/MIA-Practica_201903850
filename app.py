from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2
import os


app = Flask(__name__)


#IMPLEMENTAR CORS PARA NO TENER ERRORES AL TRATAR ACCEDER AL SERVIDOR DESDE OTRO SERVER EN DIFERENTE LOCACIÓN
CORS(app)

DB_HOST = "localhost"
DB_NAME = "postgres"
DB_USER = "postgres"
DB_PASS = "password"
try:
    con = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST)
    
    cur = con.cursor()
    
    print(con.status)
    

    @app.route("/")
    def hello():
      return "<h1 style='color:blue'>Practica 1</h1>"

#obtengo todos los registros de mi tabla movies que cree en mi BD

    @app.route('/eliminarTemporal')
    def eliminarT():
        cur.execute('''
        drop table if exists public.temporal;
        ''')
        con.commit()
        return jsonify(msg='Tabla Temporal Eliminada')

    @app.route('/eliminarModelo')
    def eliminarMR():
        cur.execute('''
        drop table if exists Renta;
        drop table if exists Categoria_pelicula;
        drop table if exists Descp_Actor;
        drop table if exists Actor;
        drop table if exists Categoria;
        drop table if exists Traduccion_Pelicula;
        drop table if exists Inventario;
        drop table if exists Idioma;
        drop table if exists Pelicula;
        drop table if exists Clasificacion;
        drop table if exists Empleado;
        drop table if exists Cliente;
        drop table if exists Ciudad;
        drop table if exists Pais;
        drop table if exists Tienda;
        ''')
        con.commit()
        return jsonify(msg='Modelo Eliminado')


    @app.route('/cargarModelo')
    def CargaMR():
        cur.execute('''
        --Tabla Pais
        CREATE TABLE Pais(
            id_Pais         SERIAL,
            nombre_Pais	    VARCHAR(50)
        );

        ALTER TABLE Pais ADD CONSTRAINT Pais_PrimaryK PRIMARY KEY (id_Pais);


        --Tabla Ciudad
        CREATE TABLE Ciudad(
            id_Ciudad       SERIAL,
            nombre_Ciudad   VARCHAR(50),
            id_Pais         INT
        );

        ALTER TABLE Ciudad ADD CONSTRAINT Ciudad_PrimaryK PRIMARY KEY (id_Ciudad);
        ALTER TABLE Ciudad ADD CONSTRAINT Ciudad_FkPais FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais);


        --Tabla Cliente
        CREATE TABLE Cliente(
            id_Cliente          	SERIAL,
            nombre_Cliente      	VARCHAR(100),
            apellido_Cliente    	VARCHAR(100),
            direccion_Cliente   	VARCHAR(100),
            correo_Cliente    		VARCHAR(100),
            fechaRegistro_Cliente 	date,
            estado_Cliente    		VARCHAR(50),
            tiendaF_Cliente    		VARCHAR(10),
            id_Ciudad 				INT
        );

        ALTER TABLE Cliente ADD CONSTRAINT Cliente_PrimaryK PRIMARY KEY (id_Cliente);
        ALTER TABLE Cliente ADD CONSTRAINT Cliente_FkCiudad FOREIGN KEY (id_Ciudad) REFERENCES Ciudad(id_Ciudad);


        --TABLA TIENDA
        CREATE TABLE Tienda(
            id_Tienda        SERIAL,
            Nombre_Tienda    VARCHAR(100),
            direccion_tienda VARCHAR(100)
        );

        ALTER TABLE Tienda ADD CONSTRAINT Tienda_PrimaryK PRIMARY KEY (id_Tienda);


        --Tabla EMPLEADO
        CREATE TABLE Empleado(
            id_Empleado			SERIAL,
            nombre_Empleado    	VARCHAR(100),
            apellido_Empleado   VARCHAR(100),
            direccion_Empleado  VARCHAR(100),
            Correo_Empleado    	VARCHAR(100),
            userName_Empleado   VARCHAR(100),
            contraseña_Empleado VARCHAR(100),
            encargado           VARCHAR(100),
            id_Tienda 			INT,
            id_CiudadE 			INT
        );

        ALTER TABLE Empleado ADD CONSTRAINT Empleado_PrimaryK PRIMARY KEY (id_Empleado);
        ALTER TABLE Empleado ADD CONSTRAINT Empleado_FkCiudad FOREIGN KEY (id_CiudadE) REFERENCES ciudad(id_Ciudad);
        ALTER TABLE Empleado ADD CONSTRAINT Empleado_FkTienda FOREIGN KEY (id_Tienda)  REFERENCES Tienda(id_Tienda);


        --Tabla Clasificacion
        CREATE TABLE Clasificacion(
            id_Clasificacion		SERIAL,
            nombre_Clasificacion    VARCHAR(100)
        );

        ALTER TABLE Clasificacion ADD CONSTRAINT Clasificacion_PrimaryK PRIMARY KEY (id_Clasificacion);


        --Tabla Categoria
        CREATE TABLE Categoria(
            id_Categoria		SERIAL,
            nombre_Categoria    VARCHAR(100)
        );

        ALTER TABLE Categoria ADD CONSTRAINT Categoria_PrimaryK PRIMARY KEY (id_Categoria);

        --Tabla actor
        CREATE TABLE Actor(
            id_Actor        SERIAL,
            nombre_Actor    VARCHAR(100),
            apellido_Actor  VARCHAR(100)
        );

        ALTER TABLE Actor ADD CONSTRAINT Actor_PrimaryK PRIMARY KEY (id_Actor);

        --Tabla PELCIULA
        CREATE TABLE Pelicula(
            id_Pelicula        		SERIAL,
            nombre_Pelicula    		VARCHAR(100),
            descripcion_Pelicula    	VARCHAR(200),
            lanzamiento_Pelicula    INT,
            duracion_Pelicula    	INT,
            dias_pelicula    		INT,
            costoRenta_Pelicula    	DECIMAL,
            costoDaño_Pelicula 		DECIMAL,
            id_Clasificacion		INT
        );

        ALTER TABLE Pelicula ADD CONSTRAINT Pelicula_PrimaryK PRIMARY KEY (id_Pelicula);
        ALTER TABLE Pelicula ADD CONSTRAINT Pelicula_FkClasificacion FOREIGN KEY (id_Clasificacion) REFERENCES Clasificacion(id_Clasificacion);


        --Tabla Renta
        CREATE TABLE Renta(
            id_Renta			SERIAL,
            fecha_Renta   		date,
            fechaRetorno_Renta  VARCHAR(100),
            fechaPago_Renta    	date,
            monto_Renta 		DECIMAL,
            id_ClienteR  		INT,
            id_EmpleadoR 		INT,
            id_PeliculaR 		INT
        );

        ALTER TABLE Renta ADD CONSTRAINT Renta_PrimaryK PRIMARY KEY (id_Renta);
        ALTER TABLE Renta ADD CONSTRAINT Renta_FkCliente FOREIGN KEY (id_ClienteR)   REFERENCES Cliente(id_Cliente);
        ALTER TABLE Renta ADD CONSTRAINT Renta_FkEmpleado FOREIGN KEY (id_EmpleadoR) REFERENCES Empleado(id_Empleado);
        ALTER TABLE Renta ADD CONSTRAINT Renta_FkPelicula FOREIGN KEY (id_PeliculaR) REFERENCES Pelicula(id_Pelicula);


        --Tabla Inventario
         CREATE TABLE Inventario(
            id_Inventario   SERIAL,
            id_Tienda 		INT,
            id_Pelicula 	INT,
            existencias 	INT
        );

        ALTER TABLE Inventario ADD CONSTRAINT Inventario_PrimaryK PRIMARY KEY (id_Inventario);
        ALTER TABLE Inventario ADD CONSTRAINT Inventario_FkTienda FOREIGN KEY (id_Tienda) REFERENCES Tienda(id_Tienda);
        ALTER TABLE Inventario ADD CONSTRAINT Inventario_FkPelicula FOREIGN KEY (id_Pelicula) REFERENCES Pelicula(id_Pelicula);


        --Tabla Categoria_Pelicula
        CREATE TABLE Categoria_Pelicula(
            id_Categoria_Pelicula	SERIAL,
            id_Categoria 			INT,
            id_Pelicula 			INT
        );

        ALTER TABLE Categoria_Pelicula ADD CONSTRAINT Categoria_Pelicula_PrimaryK PRIMARY KEY (id_Categoria_Pelicula);
        ALTER TABLE Categoria_Pelicula ADD CONSTRAINT Categoria_Pelicula_FkCategoria FOREIGN KEY (id_Categoria) REFERENCES Categoria(id_Categoria);
        ALTER TABLE Categoria_Pelicula ADD CONSTRAINT Categoria_Pelicula_FkPelicula FOREIGN KEY (id_Pelicula)   REFERENCES Pelicula(id_Pelicula);


        -- Tabla Descp_Actor
        CREATE TABLE Descp_Actor(
            id_Descp_Actor	SERIAL,
            id_Actor 		INT,
            id_Pelicula 	INT
        );

        ALTER TABLE Descp_Actor ADD CONSTRAINT Descp_Actor_PrimaryK PRIMARY KEY (id_Descp_Actor);
        ALTER TABLE Descp_Actor ADD CONSTRAINT Descp_Actor_FkActor  FOREIGN KEY (id_Actor) REFERENCES Actor(id_Actor);
        ALTER TABLE Descp_Actor ADD CONSTRAINT Descp_Actor_FkPelicula FOREIGN KEY (id_Pelicula) REFERENCES Pelicula(id_Pelicula);



        --IDIOMA
        CREATE TABLE Idioma(
            id_Idioma       SERIAL,
            nombre_idioma	VARCHAR(50)
        );

        ALTER TABLE Idioma ADD CONSTRAINT Idioma_PrimaryK PRIMARY KEY ( id_Idioma );


        --Tabla Traduccion_Pelicula
        CREATE TABLE Traduccion_Pelicula(
            id_Traduccion_Pelicula 	SERIAL,
            id_Idioma 				INT NOT NULL,
            id_Pelicula 			INT NOT NULL
        );

        ALTER TABLE Traduccion_Pelicula ADD CONSTRAINT Traduccion_Pelicula_PrimaryK PRIMARY KEY (id_Traduccion_Pelicula);
        ALTER TABLE Traduccion_Pelicula ADD CONSTRAINT Traduccion_Pelicula_FkIdioma  FOREIGN KEY (id_Idioma) REFERENCES Idioma(id_Idioma);
        ALTER TABLE Traduccion_Pelicula ADD CONSTRAINT Traduccion_Pelicula_FkPelicula FOREIGN KEY (id_Pelicula) REFERENCES Pelicula(id_Pelicula);
        
        
        --Llenar Tabla Pais
        INSERT INTO pais (nombre_pais)
        SELECT pais_tienda
        FROM temporal 
        where pais_tienda != '-'
        UNION
        SELECT pais_empleado
        FROM temporal 
        where pais_empleado != '-'
        UNION
        SELECT pais_cliente
        FROM temporal 
        where pais_cliente != '-'
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
        ''')
        con.commit()
        return jsonify(msg='Modelo Cargado')


    @app.route('/cargarTemporal')
    def CargaT():
        cur.execute('''
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
    
        COPY public.temporal from '/home/roshgard/Escritorio/[MIA]Practica1_201903850/BlockbusterData.csv' delimiter ';' csv header ENCODING 'LATIN3';   
        ''')
        con.commit()
        return jsonify(msg='Tabla Temporal Cargada')



    @app.route('/consulta1', methods=['GET'])
    def fetch1():
        cur.execute('''
        SELECT sum(existencias), tienda.nombre_tienda FROM inventario
        INNER JOIN pelicula ON Inventario.id_pelicula = pelicula.id_pelicula
        INNER JOIN tienda ON inventario.id_tienda = tienda.id_tienda
        WHERE LOWER(pelicula.nombre_pelicula) = 'sugar wonka'
        GROUP BY tienda.nombre_tienda
        ;
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)
    

    @app.route('/consulta2', methods=['GET'])
    def fetch2():
        cur.execute('''
        select cliente.nombre_cliente Nombre, cliente.apellido_cliente Apellido, count(renta.id_clienter) Rentas_totales, sum(renta.monto_renta)::varchar Pago_Total 
        from renta
        inner join cliente on cliente.id_cliente = renta.id_clienter
        group by cliente.nombre_cliente , cliente.apellido_cliente
        HAVING COUNT(renta.id_clienter) >= 40
        ;
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)
    

    @app.route('/consulta3', methods=['GET'])
    def fetch3():
        cur.execute('''
        select nombre_actor || '  ' || apellido_actor Nombre 
        from actor
        where LOWER(apellido_actor) like '%son%'
        order by nombre_actor asc
        ;
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)


    @app.route('/consulta4', methods=['GET'])
    def fetch4():
        cur.execute('''
        select actor.nombre_actor, actor.apellido_actor, pelicula.lanzamiento_pelicula
        from descp_actor
        inner join actor on actor.id_actor = descp_actor.id_actor
        inner join pelicula on pelicula.id_pelicula = descp_actor.id_pelicula
        where LOWER(pelicula.descripcion_pelicula) like '%crocodile%' 
          and LOWER(pelicula.descripcion_pelicula) like '%shark%' 
        group by actor.nombre_actor, actor.apellido_actor, pelicula.lanzamiento_pelicula 
        order by actor.apellido_actor asc
        ;
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)
    

    @app.route('/consulta5', methods=['GET'])
    def fetch5():
        cur.execute('''
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
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)

    
    @app.route('/consulta6', methods=['GET'])
    def fetch6():
        cur.execute('''
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
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)


    @app.route('/consulta7', methods=['GET'])
    def fetch7():
        cur.execute('''
        select 
        	t1.pais,
        	t1.ciudad, 
        	round(t1.total_rentas::decimal/t2.total_pais,2)::varchar Promedio
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
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)

    @app.route('/consulta8', methods=['GET'])
    def fetch8():
        cur.execute('''
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
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)


    @app.route('/consulta9', methods=['GET'])
    def fetch9():
        cur.execute('''
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
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)


    @app.route('/consulta10', methods=['GET'])
    def fetch10():
        cur.execute('''
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
        ''')
        rows = cur.fetchall()
        print(rows)

        return jsonify(rows)
  
    
    if __name__ == "__main__":
     app.run(host='0.0.0.0')        

except:
    print('Error')