--Eliminacion del modelo
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

--Creacion de Modelo

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




