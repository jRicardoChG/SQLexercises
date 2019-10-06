-- So in ubuntu in this route i can create  anew database that a previewsly save in a compress file
-- i got that file from the psqltutorial page
--/var/lib/postgresql/11$pg_restore -U postgres -d dvdrental /home/ricardo/Documents/dvdrental.tar

-- comandos basicos postgresql

\l -- lista todas las bases de datos
\q -- salir de la cmd de postgres
\dt -- listar tablas de la base de datos actual
\conninfo -- saber conque usuarioestoy coenctado y a que base de datos
\db -- listar tablespaces
\dp --listar tablas y sus privilegios 
\du -- listar roles y sus privilegios por defecto

--   tipos de datos en postgresql
-- enteros y float
-- char data types
-- boolenas
-- monetary
-- fecha/ora

-- crear base de datos
create database dvdrental owner to ricardo;
-- limitar numero de conecciones
create database dvdrental with owner ricardo with connection limit = x;

--   privilegios sobre bases de ddatos y schemas
--create
--temp
--connect
--   privilegios sobre tablas
-- insert
-- select
-- update
-- delete
-- truncate
-- references
-- trigger

 -- importar base de datos con pg_restore

-- crear squemas y grupos de usuarios

create group superusuarios;
-- anadir usuarios a un grupo con permisos sobre un schema o tabla
create user ricardo grant superusuarios to ricardo;

create schema primerschema;
-- dar permisos a un grupo sobre este schema
alter default privileges in schema primerschema grant insert on tables to superusuarios with grant option;
-- definir un schema por defecto
alter database dvdrental set search_path to primerschema;

-- agregar permisos a usuario desde su definicion
alter role usuario createrole;
alter role usuario createdb;
alter role usuario bypassrls;
alter role usuario superuser;
alter role usuario replication;
alter role usuario login;

-- agregar derechos sobre squema a grupo o role, seguridad vista desde los bojetos
grant all on schema primerschema to superusuarios;
grant all on schema primerschema.tabla2 to superusuarios;
create user ricardo password "contrasena";

-- crear tabla en squema publico o crear tabla conesquema definido
create table primerschema.tabla1();
create table tabla1();   -- schema publico
alter table add column id_usuario integer;
alter table add column id_apellido integer default 12; -- darle un valor por defecto si no es ingresado
alter table add constraint pk_llave primary key (id_usuario,id_apellido); -- definir llave primaria conconstraint y tupla de llave priaria
alter table drop constraint pk_llave; -- para elimiar constraint
alter table add constraint fk_llaveforanea foreign key (id_usuario) references tablax (id_pais); -- definir llave foranea despues de crear las columnas

--   DDL
-- create
-- delete
-- truncate
-- drop
-- alter

create database "basededatos;"
delete from "tabla1" where "tabla1.columna" = "1"
-- borrar todos los records de una tabla
truncate table "tabla1"
-- borrar toda la tabla 
drop table "tabla1"
-- para base de datos solo se puede hacer drop
drop database basededatos; --no deben haber conecciones activas en la base de datos toc aahcerlo desde postgres db

-- alter command

-- renomabrar tabla
alter table "tabla1" rename to "customers";
-- cambiar dueno
alter table "tabla1" owner to root;
-- quitar un constraint 
alter table drop constraint "fk_llave";
-- quitar un valor por defecto
alter table "tabla1" alter column "id_apellido" drop default;

--   DML
-- insert into 
-- update
-- delete
-- where
-- select pero no cambia nada 

-- insertar varios records a la vez
-- se pueden ingresar sin las columnas si las cosas estan ordenadas y todos estan llenos
insert into "tabla1" ("columna1","columna2","columna3","columna4") values ("2","2","2",default),("2","2","2","2");

-- hacer una query basica
select * from "tabla1";
select * from "tabla1" order by "columna" asc/desc;
select * from "tabla1" where "columna" = '1';
select * from "tabla1" where "columna" between 3 and 5;
select * from "tabla1" where "columna" =2 or "otracolumnadiferente" = 'smith';
select * from "tabla1" where "columna" =2 and "otracolumnadiferente" = 'smith';


-- update and delete
update "tabla1" set "columna" = "nuevovalor" where "id_usuario" = 1; -- valor unico con ese id, sin un where cambia todos los valores, CUIDADO!!!!
delete from "tabla1" where "customerID" = 6; -- valor unico con ese id

--      uso de constraints en tablas
-- ayudan a asegurar la aintegridad de la informicon, poner limites ,rangos, unicidad, referencias, evitar borrar data, etc.

-- anadir constrint al crear una tabla

create table products(
    id_prod integer,
    nombre text,
    precio numeric CHECK (precio>0)    --<--- primer constraint CHECK
);
alter table "tabla1" add constraint check_datos check (columna>="now"::text::date) not valid; --<-- ::text::date es una funcion sql que trae la fecha actual, not valid evita que los datos actuales sean validados 
comment on constraint "columna" on "tabla1" is "comentario que yo queira" --<-- para crear un comentairo en el constraint

-----tipos de constraints------
NOT null --<-- otro contraint conocido, obliga a que el dato no este vacio,dato requerido
-- not null es una propiedad de la columna, en pgadmin no s epeude crear como constraint sino como una propidad de la colomna, usando sql:
alter table "tabla1" alter column "columna" set not null;

unique --<-- garantizar no valores duplicados
primary key --<-- no acepta null, los valores son unicos, solo uno por tabla: la primary key garantiza valores no nulod, unicidad, e incrementa el rendimiento atraves de indices (search/organizar los datos)
serial --<-- es valor no reutilizable automatico
---------------------------------






