--usando sleects en SQLServer

select * from SalesLT.Product;
select ProductID, Name, ListPrice, StandardCost from SalesLT.Product;
-- operaciones en el select
select ListPrice - StandardCost as Margin from SalesLT.Product;
-- el as no simepre es necesario para nomrbar columnas (NO SE RECOMIEDNA)
select ListPrice - StandarCost Margin from SalesLT.Product;
-- en el ejemplo la columna size tiene vbalores nulos, vamos a sumar color (string) con Size (string)
-- el resultado ocncatena los valores sitrng, pero NULL sigue siendo NULL
select Color,Size Color + Size as suma from SalesLT.Product;
-- NO se pueden hacer operacione sentre columnas de difernete tipo de valor

 -- working wuith datatypes
--numeros exactos
 tinyint
 smallint
 int
 bigint
 bit
 decimal/numeric
 numeric
 money
 smallmoney
-- numeros aproximados
float
real 
--chars
char 
varchar
text
nchar
nvarchar
ntext
--date/Time
date
datetime
Time
datetime2
smalldatetime
datetimeoffset
-- binarios
binary
varbinary
image
-- otros
cursor
sql_variant
table
timestamp
xml
geography
geometry
hierarchyid

-- conversion entre tipos de variables
-- hay algunos tipños en los que la conversion es automatica
-- covnersiones explicitas
-- CAST/ TRY_CAST : 
-- COVERT/TRY_CONVERT : preferible apra pasar fechas a strings formatenadola
-- PARSE/TRY_PARSE : covnertir a numero, si los try fallan retornan un null
-- STR : covnertir a string

-- ejemplos

-- cast
select CAST(ProductID as varchar(5)) + ':' + Name as ProductName
from SalesLT.Product;

-- convert

select CONVERT(varchar(5),ProductID) + ':' + Name as ProductName
from tabla;

-- convert dates
select SellStartDate, -- tal cual esta en la base de datos
    CONVERT(nvarchar(30),SellStartDate) as convertedDate -- esto le da un oformato por defecto
    CONVERT(nvarchar(30),SellStartDate,126) as ISO8601Format -- formato iso
from tabla;

-- try to cast

select Nombre, CAST(Size as Integer) as tamanoNumerico -- falla porque los tamaños van de S,M,L
from tabla; 

select Nombre, TRY_CAST(Size as Integer) as NumericSize -- retorna nulos a los que no puede convertir
from tabla;

-- Working with NULLS
-- cualquier operacion que este asociada a un NULL retorna NULL
-- comapraciones con NULL
NULL = NULL retorna false
NULL is NULL retorna true

-- funcioens de SQL para manejar los NULLs

ISNULL(columna,valor)
-- retorna 'valor' si el registro en esa columan es NULL

NULLIF(columna,esto)
-- retirna NULL si la columna es igual a 'esto'

COALESCE(columna1,columna2,...)
-- retona el valor de la primera columna no nula de las que se listaron en la funcion

-- ejemplos

-- trata de convertir, si falla cas retorna null y isnull lo convierte a 0
Select nombre, ISNULL(TRY_CAST(Size as integer),0) as tamanoNum
from tabla;

-- valores nulos seran iguales a string vacios en la salida
select productNumber, ISNULL(Color,'') + ',' + ISNULL(Size,'') as ProductDetails
from tabla;

-- si es null se convierte en multi en la salida
select nombre, NULLIF(color,'Multi') as singleColor
from tabla;

-- retorna la primera columna no nula de las mencionadas 
select nombre,COALESCE(fechadiscontinua,sellenddate,sellstartdate) as ultimaactividad
from tabla;

-- case when permite definir la salida bajo una consdicion
-- case when columna condicion then 'salida' else 'salida2' end as 'nombre opcional'  
-- para comparar un vlor con nulo se usa IS o retornara siempre false.
select nombre,  case 
                    when sellendDate IS NULL then 'OnSale' 
                    else 'agotado'
                end as statusVentas
from tabla;

-- varios when en un solo case
select nombre, case
                    when 'S' then 'Small'
                    when 'M' then 'Medium'
                    when 'L' then 'Large'
                    when 'XL' then 'Extra-Large'
                    else ISNULL(Size, 'n/a')
                end as PrdocutSize
from tabla;


