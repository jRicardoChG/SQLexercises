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
select a,b,c from "tabla1";
select a as nombre, b as apellido from "tabla1";
select distinct a from "tabla1"; --<-- solovalore distintos, si selecciono varias columnas una union de estas columnas debe ser unica
select tabla1.nombre from "tabla1";
-- wildcards
select tabla1.* from "tabla1";
select * from "tabla" where [condicion] <operador logico> [condicion]
-- estas condicones pueden ser
-- between
-- is null, is not null
-- group by
select columnax from "tabla1" group by columnax;
select region,sum(amount) from sales group by region 
-- se usa apra hacer calculos y asociar estos calculos con otra tbla


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

----- segundo curso psql

--    foreign key contraints
-- para mantener integridad referencial
-- solo se puedenrefenciar primary keys de otras tablas
-- recordar que una primary key debe ser unica en una tabla, pero puede estar formada por varias columnas de la misma tabla
-- si la primary key de una tabla esta formada por varias columnas, la foreignkeyque haga referencia a esa primary key debe formarse de todas las columnas que la componen, con el mismo data type
-- borrar una foreign key se prohibe para asegurar integridad
-- para borrar records que tienen asociada una foreign key, se usa ON DELETE CASCADE
-- 
-- ejemplos

create table products (
    product_no integer primary key,
    nombre text,
    precio numeric
);

create table orders(
    order_id integer primary key,
    product_no integer references products (product_no) on delete restrict, --<-- no deja eliminar un record si tiene otros records asociados, debe ser borrado primero el record asociado para poder borrar el original
    cantidad integer
);

create table orders(
    order_id integer primary key,
    product_no integer,
    cantidad integer,
    constraint fk_productno foreign key product_no references products (product_no) on delete cascade, --<-- si se borra, todos los records asociados se borran tambien 
    constraint pk_orderid primary key (order_id)  
);


-- ejemplos de querys where
-- repaso expresiones regluares con querys
-- wildcard characters para regexp sql
-- + 1 o mas veces; * 0 o mas veces; ? 1 o 0 veces; | una u otra; no las dos; {n veces}; () agrupar; % <-- indica cualquier caracter, tal como el punto en las regexp posix.
-- mas infromacion https://www.postgresql.org/docs/9.5/functions-matching.html

-- like
-- not like
-- not null
-- null
-- between
-- in para varios valores ala vez dela misma columna
-- not in degacion de in

select * from "tabla" where columna1 like '%col%';    --<-- busca de la columna columna1 todo lo que contenga el string "col", al principio, en medio o al final
select * from customer where last_name like 'A%' and last_name like '%a' limit 30;
select * from customer where last_name is not null limit 30;

-- where con operadores matematicos
-- group by casi siempre se usa con funciones de gragacion que se definen antes del from de la query
-- count cuenta los elementos existentes
-- sum suma los valores de los records que se usan
-- min
-- max
-- avg

select payment.amount,payment.rental_id from payment where payment.amount < 5 limit 10; 
select payment.customer_id,avg(payment.amount) from payment group by payment.customer_id limit 10;
-- usando group by y haciendo un where sobre el resultado de la funcion avg
select customer,media from (select payment.customer_id as customer,avg(payment.amount) as media from payment group by payment.customer_id)as tabla1 where media >=4 limit 20;
-- uniendo where con group by , sin embargo el where no se puede aplicar al resultado del avg
select payment.customer_id as customer,avg(payment.amount) as media from payment where customer_id = 4 group by payment.customer_id limit 10;
-- usando where between y group by
select payment.customer_id as customer,avg(payment.amount) as media from payment where customer_id between 2 and 4 group by payment.customer_id limit 10;

-- haciendo una query en la que se unen dos tablas pero no hay un join
-- en esta query existe una tabla llamada cateogrias en general y una tabla que indica la categoria a la cual pertenece un film existente en la base de datos, queremos saber el id del film y su categoria en letras
select category.name,film_category.film_id from category,film_category where category.category_id = film_category.category_id limit 20;
-- ahora hago esta misma query pero agrupando por cateogria y deseando saber cuantos filmes hay por categoria
select category.name,count(film_category.film_id) from category,film_category where category.category_id = film_category.category_id group by category.name limit 10;


-- usando DISTINCT

-- en este caso se que hay 16000 veces que se han hecho retas de dvds
select customer_id from rental order by customer_id asc;
-- pero cunatos usuairos diferentes hay?
select distinct customer_id from rental order by customer_id asc;
-- y si solo quiero el numero de records?
select count(tabla1.customerid) from (select distinct customer_id  as customerid from rental) as tabla1;

-- usando orderby

-- en este caso se muestra como se puede ahcer order by en dos o mas colmunas a la vez sol oes posible cuando hay varios reocrds para cada columna
select customer_id,rental_date from rental order by customer_id asc,rental_date desc;
-- y usando group by? deseo saber la cantidad de rentas que se hicieron por usuario y la que tiene la menor fecha;
select customer_id,min(rental_date),count(rental_date) from rental group by customer_id order by customer_id asc;


-- item functions

select sum(payment.amount) as "suma delas rentas totales" from payment;
select min(payment.amount) as "suma delas rentas totales" from payment;
select max(payment.amount) as "suma delas rentas totales" from payment;
select count(payment.amount) as "suma delas rentas totales" from payment;

select payment.staff_id, sum(payment.amount) from payment group by payment.staff_id;


