-- 1. Drop database si ya existe (opcional) 
DROP DATABASE IF EXISTS airlinedb;


-- 2. Crear la base de datos si no existe
CREATE DATABASE airlinedb
   WITH
   OWNER = postgres
   ENCODING = 'UTF8'
   LC_COLLATE = 'English_United States.1252'
   LC_CTYPE = 'English_United States.1252'
   TABLESPACE = pg_default
   CONNECTION LIMIT = -1
   IS_TEMPLATE = False;


-- Usar la base de datos creada
\c airlinedb;


--- Tabla ----




CREATE TABLE IF NOT EXISTS COMPANIA (
   compania_id SERIAL PRIMARY KEY,
   nombre VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS MODELO (
   id_modelo INT PRIMARY KEY NOT NULL,
   nombre_modelo VARCHAR(20) NOT NULL
);


CREATE TABLE IF NOT EXISTS AVION (
   id_avion SERIAL PRIMARY KEY,
   anio_avion TIMESTAMP NOT NULL,
   material_avion VARCHAR(50) NOT NULL,
   cantidad_pasajeros INT NOT NULL,
   id_modelo INT NOT NULL,
   compania_id SERIAL NOT NULL,
   FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
   FOREIGN KEY (compania_id) REFERENCES COMPANIA(compania_id)
);


CREATE TABLE IF NOT EXISTS CLIENTE (
   nro_documento INT PRIMARY KEY NOT NULL,
   nombre VARCHAR(20) NOT NULL,
   apellido VARCHAR(20) NOT NULL,
   nacionalidad VARCHAR(50) NOT NULL,
   compania_id INT NOT NULL,
   FOREIGN KEY (compania_id) REFERENCES COMPANIA(compania_id)
);


CREATE TABLE IF NOT EXISTS VUELO (
   vuelo_id SERIAL PRIMARY KEY,
   origen VARCHAR(100) NOT NULL,
   destino VARCHAR(100) NOT NULL,
   fecha_vuelo DATE NOT NULL,
   compania_id INT NOT NULL,
   id_avion INT NOT NULL,
   FOREIGN KEY (id_avion) REFERENCES AVION(id_avion),
   FOREIGN KEY (compania_id) REFERENCES COMPANIA(compania_id)
);


CREATE TABLE IF NOT EXISTS CLIENTE_COMP (
   compra_id SERIAL PRIMARY KEY,
   nro_documento INT NOT NULL,
   vuelo_id INT NOT NULL,
   FOREIGN KEY (nro_documento) REFERENCES CLIENTE(nro_documento),
   FOREIGN KEY (vuelo_id) REFERENCES VUELO(vuelo_id)
);


CREATE TABLE IF NOT EXISTS SECCION (
   id_seccion INT PRIMARY KEY NOT NULL,
   tipo_seccion VARCHAR(50) NOT NULL
);




CREATE TABLE IF NOT EXISTS PASAJE (
   id_pasaje INT PRIMARY KEY NOT NULL,
   numero_asiento VARCHAR(20) NOT NULL,
   hora_embarque TIMESTAMP NOT NULL,
   lugar_destino VARCHAR(50) NOT NULL,
   puerta VARCHAR(50) NOT NULL,
   vuelo_id INT NOT NULL,
   id_seccion INT,
   nro_documento INT NOT NULL,
   FOREIGN KEY (nro_documento) REFERENCES CLIENTE(nro_documento),
   FOREIGN KEY (vuelo_id) REFERENCES VUELO(vuelo_id),
   FOREIGN KEY (id_seccion) REFERENCES SECCION(id_seccion)
  
);




create table IF NOT EXISTS costo (
   id_costo int primary key not null,
   monto_costo int not null,
   id_pasaje int not null,
   foreign key (id_pasaje) references pasaje(id_pasaje)
);






-- Crear tabla EMPLEADO
CREATE TABLE IF NOT EXISTS EMPLEADO (
   id_empleado SERIAL PRIMARY KEY,
   nombre_empleado VARCHAR(100) NOT NULL,
   anios_servicio INT NOT NULL,
   cargo_empleado VARCHAR(50) NOT NULL,
   id_compania INT NOT NULL,
   FOREIGN KEY (id_compania) REFERENCES COMPANIA(compania_id)
);




-- Crear tabla SUELDO
CREATE TABLE IF NOT EXISTS SUELDO (
   id_sueldo SERIAL PRIMARY KEY,
   fecha_pago TIMESTAMP NOT NULL,
   cantidad_sueldo DECIMAL(10, 2) NOT NULL,
   id_empleado int not null,
   foreign key (id_empleado) references EMPLEADO(id_empleado)


);
-- Crear tabla EMP_VUELO (para empleados asignados a vuelos)
CREATE TABLE IF NOT EXISTS EMP_VUELO (
   id_emp_vuelo SERIAL PRIMARY KEY,
   vuelo_id INT NOT NULL,
   id_empleado INT NOT NULL,
   FOREIGN KEY (vuelo_id) REFERENCES VUELO(vuelo_id),
   FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);
