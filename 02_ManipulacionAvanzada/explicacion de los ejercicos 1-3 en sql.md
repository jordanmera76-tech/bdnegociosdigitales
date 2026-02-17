#  Guía Completa de Comandos SQL de los archivos del 1 al 3


## Repaso de comados de una configuracion de un Base de Datos
Este documento contiene la totalidad del código del archivo `01-sql-ldd.sql`, desglosado por secciones con explicaciones detalladas de cada operación.

---

### 1. Configuración de Base de Datos y Tablas Básicas
En esta parte se prepara el entorno y se crean las primeras estructuras de almacenamiento.

```sql
-- Crea una Base de Datos
CREATE DATABASE tienda;
GO

use tienda;

-- Crear tabla cliente
CREATE TABLE cliente (
    id int not null,
    nombre nvarchar(30) not null,
    apaterno nvarchar(10) not null,
    amaterno nvarchar(10) null,
    sexo nchar(1) not null,
    edad int not null,
    direccion nvarchar(80) not null,
    rfc nvarchar(20) not null,
    limitecredito money not null default 500.0
);
GO
```
  **CREATE DATABASE**: Comando DDL para crear el contenedor lógico.

**USE**: Establece la base de datos sobre la cual se ejecutarán los siguientes comandos.

**NOT NULL / NULL**: Define si una columna permite estar vacía o es obligatoria.

**DEFAULT**: Establece un valor automático (500.0) si no se inserta uno manualmente.

### 2. Llaves Primarias e Inserciones de Datos
Aquí se define una tabla con una Primary Key y se puebla con registros.

```sql
CREATE TABLE clientes(
   cliente_id INT NOT NULL PRIMARY KEY,
   nombre nvarchar(30) NOT NULL,
   apellido_paterno nvarchar(20) NOT NULL,
   apellido_materno nvarchar (20),
   edad INT NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   limite_credito MONEY NOT NULL
);
GO


-- Inserciones individuales y masivas
INSERT INTO clientes VALUES (1, 'GOKU', 'LINTERNA', 'SUPERMAN', 450, '1578-01-17', 100);
INSERT INTO clientes VALUES (2, 'PANCRACIO', 'RIVERO', 'PATROCLO', 20, '2005-01-17', 10000);

-- Inserción especificando columnas
INSERT INTO clientes (nombre, cliente_id, limite_credito, fecha_nacimiento, apellido_paterno, edad)
VALUES ('Arcadia', 3, 45800, '2000-01-22', 'Ramirez', 26);

-- Inserción múltiple
INSERT INTO clientes VALUES 
(5, 'Soyla', 'Vaca', 'Del Corral', 42, '1983-04-06', 78955),
(6, 'Bad Bunny', 'Perez', 'Sinsentido', 22,'1999-05-06', 85858);
```

**PRIMARY KEY**: Asegura que el cliente_id nunca se repita.

**INSERT INTO**: Añade filas a la tabla. El script muestra inserciones individuales y masivas (separadas por comas).

### 3. Automatización con Identity y Default
Uso de funciones del sistema para ahorrar trabajo manual.

```sql
CREATE TABLE clientes_2(
  cliente_id int not null identity(1,1),
  nombre nvarchar(50) not null,
  edad int not null,
  fecha_registro date default GETDATE(),
  limite_credito money not null,
  CONSTRAINT pk_clientes_2 PRIMARY KEY (cliente_id)
);

-- Ejemplo de inserción usando valores por defecto
INSERT INTO clientes_2 (nombre, edad, limite_credito)
VALUES ('Batman', 45, 89000);
```

**identity(1,1)**: El sistema genera el ID automáticamente (1, 2, 3...).

**GETDATE()**: Captura la fecha y hora exacta del servidor en el momento del registro.

### 4. Restricciones Avanzadas (Constraints)
Definición de reglas de negocio para mantener la calidad de los datos.

```sql
CREATE TABLE suppliers (
  supplier_id int not null identity(1,1),
  [name] nvarchar(30) not null,
  CONSTRAINT pk_supplers PRIMARY KEY ( supplier_id ),
  CONSTRAINT unique_name UNIQUE ([name]),
  CONSTRAINT chk_credit_limit CHECK (credit_limit > 0.0 and credit_limit <= 50000),
  CONSTRAINT chk_tipo CHECK (tipo IN ('A', 'B', 'C'))
);
```
**UNIQUE**: Impide que existan dos proveedores con el mismo nombre.

**CHECK**: Valida que el crédito esté en un rango lógico y que el tipo de cliente sea solo una de las letras permitidas.

### 5. Integridad Referencial (Llaves Foráneas)
Relación entre productos y proveedores con reglas de borrado.

```sql
CREATE TABLE products (
   product_id INT NOT NULL IDENTITY (1,1),
   [name] NVARCHAR (40) NOT NULL,
   supplier_id INT,
   CONSTRAINT fk_products_suppliers
   FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id)
   ON DELETE SET NULL
   ON UPDATE SET NULL
);
```
**FOREIGN KEY**: Conecta un producto con un proveedor existente.

**ON DELETE SET NULL**: Si borras un proveedor de la tabla suppliers, los productos que le pertenecían no se borran; simplemente su supplier_id pasa a estar vacío (NULL).

### 6. Mantenimiento y Actualizaciones (DML/DDL)
Modificación de registros y estructura.

```sql
-- Actualizar registros específicos
UPDATE products SET supplier_id = 10 WHERE supplier_id = 2;

-- Borrar registros (Integridad referencial)
DELETE FROM suppliers WHERE supplier_id = 1;

-- Modificar estructura de la tabla
ALTER TABLE products ALTER COLUMN supplier_id INT NULL;

-- Eliminar tablas
DROP TABLE products;
```
**UPDATE**: Cambia valores en filas existentes usando filtros (WHERE).

**DELETE**: Elimina filas. Es necesario tener cuidado con las relaciones padre-hijo.

**ALTER TABLE**: Cambia la configuración de una columna (ej. permitir que sea nula).

**DROP TABLE**: Elimina la tabla y toda su información permanentemente.


## Guía Maestra de Consultas: SQL-LMD Completo
Este documento contiene el código íntegro del script `02-Consultas Simples.sql` de Manipulación de Datos, organizado por bloques funcionales para facilitar su comprensión.

### 1. Consultas Globales y Proyección
El inicio del script se enfoca en explorar las tablas y seleccionar columnas específicas (proyección) para optimizar la carga de datos.

```sql
---Consultas simples con SQL-LMD (lenguaje de manipulacion de base de datos)

SELECT *
FROM Categories;

SELECT *
FROM Products;

SELECT *
FROM Orders;

SELECT *
FROM [Order Details];

--Proyecccion (selecion algunos campos)
SELECT ProductID,
ProductName,
UnitPrice,
UnitsInStock
FROM Products;
```

### 2. Alias de Columnas y Personalización de Cabeceras
Se asignan nombres temporales a las columnas para que los resultados sean más legibles en reportes

```sql
--Alias de Columnas
SELECT ProductID AS [NUMERO DE PRODUCTO],
ProductName 'NOMBRE DE PRODUCTO',
UnitPrice AS [PRECIO UNITARIO],
UnitsInStock AS STOCK
FROM Products;

SELECT 
CompanyName AS CLIENTE,
City AS CIUDAD,
Country AS PAIS
FROM Customers;
```

### 3. Campos Calculados
Operaciones aritméticas realizadas directamente en la consulta para generar información que no existe físicamente en las tablas.

```sql
-- Campos calculado es un campo que no se encuentra en la columna 
-- SELECIONAR LOS PRODUCTOS Y CALCULAR EL VALOR DEL INVENTARIO

SELECT *, (UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

SELECT ProductID,
      ProductName,
      UnitPrice,
      UnitsInStock,
      (UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;


SELECT *
FROM [Order Details]

SELECT OrderID,
 ProductID,
 UnitPrice,
      Quantity,
      (UnitPrice * Quantity) AS Importe
FROM [Order Details]

--Selecionar la venta con el Calculo del importe con descuento

SELECT OrderID ,
    UnitPrice,
    Quantity,
    Discount,
    (UnitPrice * Quantity) AS Importe,
    (UnitPrice * Quantity) - ((UnitPrice * Quantity) * Discount) AS [Importe con Descuento 1],
    (UnitPrice * Quantity) * (1 - Discount) AS [Importe con decuento 2] 
FROM [Order Details]
```

### 4. Operadores Relacionales y Manejo de Fechas
Filtrado basado en comparaciones (>, <=) y el uso de funciones de sistema para desglosar el tiempo.

```sql
---- Operadores Relacionales (<,>,<=,>=, = !=, O <>)

SELECT 
    ProductID AS [numero de Producto],
    ProductName AS [Nombre del Producto],
    UnitPrice AS [Precio Unitario],
    UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice>30
ORDER BY UnitPrice DESC;


SELECT 
    ProductID AS [numero de Producto],
    ProductName AS [Nombre del Producto],
    UnitPrice AS [Precio Unitario],
    UnitsInStock AS [Stock]
FROM Products
WHERE UnitsInStock <= 20;

-- Manejo de Fechas
SET LANGUAGE SPANISH; -- Configura el idioma para funciones de fecha
SELECT 
    OrderID , OrderDate, CustomerID, ShipCountry,
    YEAR(OrderDate) AS AÑO,
    Month(OrderDate) AS MES,
    DAY(orderdate) AS DIA,
    DATEPART (YEAR, OrderDate) AS AÑO2,
    DATEPART (Quarter, OrderDate) AS trimestre,
    DATEPART(WEEKDAY, OrderDate) AS [Dia semana],
    DATENAME (WEEKDAY, OrderDate) AS [Nombre Dia] -- Nota: DATENAME es ideal para nombres
FROM Orders
WHERE YEAR(OrderDate) > 1997;
```
### 5. Operadores Lógicos y Operadores de Conjunto (IN, BETWEEN, IS NULL)
Filtros más robustos para segmentar la información con precisión.

```sql
--Operadores Logicos (not and, or)

SELECT ProductID, CategoryID, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20 and UnitsInStock < 100;

SELECT CustomerID , CompanyName, city, region, country
FROM Customers
WHERE country = 'USA' or country = 'CANADA';

-- Manejo de valores Nulos
SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE shipRegion is null;

SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE shipRegion is not null;

--Operador IN
SELECT *
FROM Customers
Where Country IN ('Germany', 'France', 'UK')
Order by Country DESC;

SELECT *
FROM Products
WHERE CategoryID in (1, 3, 5)
Order by CategoryID DESC;

--Operador BETWEEN
SELECT *
FROM Products
WHERE UnitPrice Between 20 AND 40
Order By UnitPrice;
```

### 6. Búsqueda con Patrones y Comodines (LIKE)
Esta sección es clave para búsquedas de texto parcial utilizando caracteres especiales.

```sql
------LIKE  

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName Like 'an%'; -- Inicia con 'an'

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like 'l_nd_o'; -- Carácter desconocido en medio

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like '%as'; -- Termina con 'as'

-- Uso de Rangos y Negación en LIKE
SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[bsp]%'; -- Inicia con b, s o p

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[a-f]%'
ORDER BY 2 ASC; -- Inicia de la 'a' a la 'f'

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[^a-f]%'
ORDER BY 2 ASC; -- Que NO inicie de la 'a' a la 'f'
```

### 7. Combinación de Filtros Complejos
El cierre del script muestra cómo integrar países y patrones de texto en una sola condición.

```sql
--- Selecionar todos los clientes de estados unidos o canada que inicia con b

SELECT CustomerID , CompanyName, city, region, Country
FROM Customers
WHERE Country in ( 'canada', 'USA') or CompanyName like 'b%' ;

SELECT CustomerID , CompanyName, city, region, Country
FROM Customers
WHERE Country in ( 'canada', 'USA') and CompanyName like 'b%' ;
```



## Guía de Funciones de Agregado y Agrupamiento

Este documento detalla el uso de funciones estadísticas y la lógica de segmentación de datos aplicada en el script `03_funciones_agregados.sql`. Estas herramientas son esenciales para transformar miles de registros en información resumida y útil.

### 1. Introducción y Conteo de Registros (COUNT)
En esta sección se definen las funciones principales y se realizan los primeros conteos para conocer el volumen de datos.

Comandos: `COUNT(*)`, `COUNT(campo)`, `DISTINCT`.

```sql
/*
Funciones de agregado
1.sum()
2.max()
3.min()
4.avg()
5.count(*)
6.count(campo)
*/

SELECT DISTINCT Country
FROM Customers


---Agregacion count (*) cuenta el numero de registros
--- que tiene una tabla


SELECT Count(*) as [Total de Ordenes]
From Orders;

SELECT ShipCountry, COUNT(*) AS [Total de orders]
FROM Orders
group by ShipCountry ;


SELECT Count(ShipCountry) , ShipCountry 
FROM Orders
WHere ShipCountry = 'Germany'
group by ShipCountry ;

SELECT *
FROM Customers;

----Con un campo adentro cuenta tod lo que esta en el capo pero los null no los cuenta "(campoque esta)"

SELECT count (CustomerID)
FROM Customers;

SELECT count (Region)
FROM Customers;

--Seleciona de cuantas ciudades son las ciudades de los clientes 

SELECT City
FROM Customers
Order by City ASC;

SELECT count(City)
FROM Customers;

---El DISTINCT cuenta todas las distintas ciudades
SELECT DISTINCT City
FROM Customers
Order by City ASC;
--Hay que eliminar primero las duplicasdas y despues el contar las ciudades
SELECT Count(DISTINCT City) AS [ciudades clientes]
FROM Customers;
```

**COUNT(*)** : Cuenta todas las filas de la tabla o del grupo, sin importar lo que contengan.

**COUNT(campo)** : Cuenta cuántas veces aparece un valor en una columna específica.

**DISTINCT** : borra los repetidos de tu lista.

### 2. Análisis de Valores Extremos (MAX y MIN)
Esta parte se enfoca en encontrar los límites superiores e inferiores de los datos.

Comandos: `MAX()`, `MIN()`, `ORDER BY " que quieres ordenar " DESC O ASC`.

```sql
--SELECIONA EL PRECI MAXIMO DE LOS PRODUCTOS

SELECT *
FROM Products
Order BY UnitPrice DESC;


SELECT MAX(UnitPrice) as [Precio mas alto]
FROM Products;


--Selecionar la fecha de compra mas actual
Select *
From Orders

SELECT MAX(OrderDate) as [Ultima fecha de compra]
FROM Orders;


---Selecionar el a;o de la fecha de compra mas reciente

SELECT Year(MAX(OrderDate)) as [Fecha mas reciente] ---Esta bien esta parte
FROM Orders;

SELECT MAX(DATEPART(year, OrderDate))
FROM Orders;

SELECT DATEPART(year, MAX (OrderDate)) AS [Año]
FROM Orders;



---Cual es la minima cantidad de lo spedidios

SELECT *
From [Order Details]

Select MIN (Quantity) as [MInima cantida de productos]
From [Order Details]

--Cual es el importe mas bajo de las compras

SELECT (UnitPrice * Quantity * (1-Discount)) AS [Importe]
FROM [Order Details]
Order by Importe ASC


SELECT (UnitPrice * Quantity * (1-Discount)) AS [Importe]
FROM [Order Details]
Order by 1 ASC


SELECT (UnitPrice * Quantity * (1-Discount)) AS [Importe]
FROM [Order Details]
Order by (UnitPrice * Quantity * (1-Discount)) ASC

SELECT MIN ( (UnitPrice * Quantity * (1-Discount))) AS [Importe mas bajo]
FROM [Order Details]
```
**MAX()** : Busca el valor más alto de una columna.

**MIN()** : Busca el valor más bajo de una columna.

**ORDER BY ... ASC / DESC** : Sirve para acomodar tus resultados en una lista ordenada

### 3. Sumatorias y Totales Percibidos (SUM)
Aquí se realizan cálculos acumulativos para determinar valores financieros totales.

Comandos: `SUM()`, `Operadores aritméticos (*, -)`.

```sql
--SUM es la suma de todo esto 
---Quiero el total de los precios de los productos
SELECT SUm (UnitPrice)
FROM Products


---Ontener el total de dinero percibido por las ventas
SELECT sum ( (UnitPrice * Quantity * (1-Discount))) AS [Importe mas bajo]
FROM [Order Details]

SELECT SUm (UnitPrice) AS [Total dedinero percibido]
FROM [Order Details]

---Ontener el total de dinero percibido por las ventas
SELECT sum ( (UnitPrice * Quantity * (1-Discount))) AS [Importe mas bajo]
FROM [Order Details]

---Selecionar la ventas totales de los prodcutos 4,10,20

SELECT *
FROM Products;

Select sum (UnitPrice )
From Products
Where ProductID in (4,10,20);


Select 
	ProductID,
	sum (UnitPrice * Quantity)
From [Order Details]
Where ProductID in (4,10,20)
Group by ProductID;
```

**SUM()**: Es una sumadora automática para toda una columna.

**Operadores Aritméticos (*, -)**: Se usan para hacer cálculos fila por fila, como si fuera una calculadora común.


### 4. Agrupamiento por Clientes y Tiempo
Se segmentan los datos para entender el comportamiento de clientes específicos y periodos temporales.

Comandos: `GROUP BY`, `WHERE`, `IN`, `DATEPART`.

```sql
---SELECIONAR EL NUMERO DE ORDERS HECHAS POR LOS SIGUIENTES CLIENYTES
--Around the horn
--Bólido Comidas preparadas,
--CHOP-suey CHINESE
SELECT *
FROM Orders

SELECT COUNT(*) AS TotalOrdenes
FROM Orders
WHERE CustomerID = 'AROUT';

SELECT COUNT(*) AS TotalOrdenes
FROM Orders
WHERE CustomerID = 'CHOPS';

SELECT COUNT(*) AS TotalOrdenes
FROM Orders
WHERE CustomerID IN ('AROUT', 'CHOPS');

--Sleecionar el total de ordenes del segundo trimestre de 1995 
SELECT COUNT(*) AS [Numero de Ordenes]
from Orders
WHERE DATEPART(QUARTER, OrderDate) = 3
AND DATEPART(YEAR,OrderDate) =1997


--Seleciona el numero de ordenes entre 1996 a 1997
SELECT COUNT(*) AS [Numero de ordenes]
FROM Orders
WHERE DATEPART (YEAR, OrderDate) BETWEEN 1996 AND 1997;

--seleciona el numero de ordeners realizada por el cliente CHOP-suey CHINESE en 1995

SELECT *
FROM Customers
WHERE CompanyName = 'Chop-suey Chinese'

Select CustomerID , count(*) AS [oRDENES REALIZADAS POR CHOP-SUEY]
fROM Orders
wHERE CustomerID = 'CHOPS' and year(OrderDate) = 1996
Group by CustomerID
```

**GROUP BY** (Agrupar por...) : Junta todas las filas que tienen el mismo valor en una columna

**WHERE** (Donde...) : Solo muéstrame las filas que cumplan esta condición

**IN** (Dentro de...) : Te permite buscar varios valores específicos a la vez sin escribir tanto código.

**DATEPART** (Parte de la fecha) : Sirve para sacar un trozo específico de una fechaz

### 5. Segmentación por Patrones de Texto e Idioma
Uso de filtros de texto para conteos basados en nombres o ubicaciones geográficas.

Comandos: `LIKE`, `SET LANGUAGE`, `ROUND`, `AVG`.

```sql
--Seleciona el numero de clientes que comienzan con A o que comeinza con B
SELECT COUNT (*) [Numero de Clientes]
From Customers
where CompanyName LIKE'A%' 
OR CompanyName LIKE 'B%'

--SELECIONAR EL NUMERO DEL CLIENTES QUE COMIENZA CON b O QUE TERMINA CON s
SELECT COUNT (*) [Numero de Clientes]
From Customers
where CompanyName LIke 'B%S'

SELECT COUNT(*) AS TotalClientes
FROM Customers
WHERE CompanyName LIKE '[AB]%';

----Selecionar el numero de Productos (conteo ) por categoria
---- mostraar categoriaid, el total de los productos
---- Ordenar de mayor a mayor por el totaldeproductos

SELECT CategoryID,Count(*) AS [Total de productos]
FROM Products
Group by CategoryID
Order by [Total de productos] DESC


--Selecionar el precio promedio por el provedor de los productos
--Redondear a dos decimales el resultado
-- ordenar de forma descendente por el precio promedio

SELECT SupplierID, ROUND(AVG(UnitPrice), 2) AS [Precio promedio]
FROM Products
GROUP BY SupplierID
Order by [Precio promedio] DESC

--Selecionar el nuemro de clientes por paies ordenalos por pais alfabericamente

SELECT CustomerID ,Count(Country) AS [numero de paises por cliente]
FROM Customers
where CustomerID like '[a-z]%'
Group by CustomerID
```

**LIKE** (Como...): Se usa cuando no sabes el nombre exacto, pero tienes una idea

**SET LANGUAGE** (Configurar idioma) : Le dice a SQL en qué idioma quieres que te devuelva

**ROUND** (Redondear) : ecorta los números decimales para que queden más limpios.

**AVG** (Promedio) : Suma todos los valores de una columna y los divide entre el total de filas 

### 6. La cláusula GROUP BY fundamental ara agrupar filas que tienen los mismos valores
Permitir que realices cálculos estadísticos sobre esos grupos.

Comandos: `INNER JOIN`, `ON`, `AS (Alias de tabla)`, `GROUP BY`.

```SQL
/*	
 GRUP BY Y HAVING
*/


Select 
	customers.CompanyName, 
	COUNT(*) AS [Numero de Ordenes]
FROM Orders
INNER JOIN
Customers
ON Orders.CustomerID = Customers.CustomerID
Group BY Customers.CompanyName
Order BY 2 DESC;

Select 
	c.CompanyName, 
	COUNT(*) AS [Numero de Ordenes]
FROM Orders AS o
INNER JOIN
Customers AS c
ON o.CustomerID = c.CustomerID
Group BY c.CompanyName
Order BY 2 DESC;

---

---Obtner la cantidad total vendida agrupada por producto y pedido

SELECT *
FROM [Order Details Extended]


SELECT * , (UnitPrice * Quantity ) AS [TOTAL]
FROM [Order Details Extended]


SELECT 
	ProductID , 
	SUM(UnitPrice * Quantity ) AS [TOTAL]
FROM [Order Details Extended]
GROUP BY ProductID
Order BY ProductID

SELECT 
	ProductID , 
	OrderID,
	SUM(UnitPrice * Quantity ) AS [TOTAL]
FROM [Order Details Extended]
GROUP BY ProductID, OrderID
Order BY ProductID , [TOTAL] DESC


SELECT *,
	(UnitPrice * Quantity) AS [TOTAL]
	FROM [Order Details]
	WHERE OrderID = 10847
	and ProductID = 1

-- Selecionar la cantidad minima vendida por producto en cada pedido

SELECT ProductID , min(Quantity) AS [Cantidad Minima]
From [Order Details]
GROUP BY ProductID


---Seleccionar la cantidad naxima vendida por producto en cada pedido
select ProductID, OrderID , MAX(Quantity) AS [Cantidad MAXIMA POR PEDIDO]
FROM [Order Details]
GROUP BY ProductID, OrderID
order by ProductID, OrderID
```

**INNER JOIN** (Unir tablas): Sirve para combinar las filas de dos tablas distintas en una sola vista

**ON** (En donde...): e dice a SQL cuál es la columna que conecta a las dos tablas

**AS** (Alias de tabla) : Sirve para ponerle un nombre corto a una tabla

### 7. Filtrado de Grupos (HAVING) y Flujo Lógico
Esta sección final muestra cómo filtrar los resultados una vez que ya han sido agrupados.

Comandos: `HAVING`, `CONCAT`, `SUM`.

```sql
--Flujo logico de ejecucion en scl
--1 from
--2 join
--3 WHERE
--4 GROUP NY
--5 HEAVING
--6 SELECT
--7 DISTING
--8 ORDER BY


--heaving
--Mostrar los clientes que haya realizadomas de 10 pedidos

SELECT CustomerID,Count(*) AS [Numero de Ordenes]
FROM Orders
GROUP BY CustomerID
Order by 2 desc


SELECT CustomerID, ShipCountry,Count(*) AS [Numero de Ordenes]
FROM Orders
where ShipCountry in ('Germany', 'France' , 'Brazil')
GROUP BY CustomerID, ShipCountry
HAVING Count(*) > 10
Order by 2 desc



SELECT C.CompanyName, Count(*) AS [Numero de Ordenes]
FROM Orders AS O
INNER JOIN
Customers AS C
on O.CustomerID = C.CustomerID
GROUP BY c.CompanyName
HAVING Count(*) > 10
Order by 2 desc


---Selecionar los empleados que haya gestionado pedidos por un total superior
-- a 100,000 en ventas (mostrar el id del empleado , el nombre del empleado y total de compras)

SELECT *
FROM Employees AS e
INNER JOIN Orders AS o
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS od
ON O.OrderID = od.OrderID


SELECT  
	Concat(e.FirstName, '', e.LastName) AS [Nombre completo] ,
	ROUND(sum(od.Quantity * od.UnitPrice *(1-od.Discount)),2) AS [Importe]
FROM Employees AS e
INNER JOIN Orders AS o
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS od
ON O.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName
HAVING sum(od.Quantity * od.UnitPrice *(1-od.Discount)) >100000
ORDER BY  [Importe] desc

--selecionar el numero de productos vendidos en mas de 20 pedidos distintos
--Mostrar el ID del producto, el NOMBRE del produdcto el numero de ordenes

SELECT 
	p.ProductID,
	p.ProductName,
	COUNT(O.OrderID) AS [NUMERO DE Pedidos]
FROM Products AS P
INNER JOIN [Order Details] AS Od
ON p.ProductID = od.ProductID
INNER JOIN Orders AS O
ON o.OrderID = od.OrderID
GROUP BY p.ProductID,
	p.ProductName
Having COUNT(O.OrderID) > 20



--selecionar los productos no descontinuados, 
--calcular el precio promedio vendido,
--mostrar solo aquelos que se alla vendido en menos de 15 pedidos distintos

SELECT p.ProductName, AVG(Od.UnitPrice) AS [Precio Promedio]
FROM Products AS P
INNER JOIN [Order Details] AS Od
ON p.ProductID = Od.ProductID
WHERE p.Discontinued = 0
GROUP BY p.ProductName 
HAVING AVG(Od.UnitPrice) < 15

--SELECIONAR El prcio maximo de productos por categoria
---solo si la suma de unidades es menor a 200
--- y ademas que no esten descontinuados

SELECT c.CategoryID, c.CategoryName, p.ProductName, MAX(P.UnitPrice) AS [Precio maximo]
FROM Products AS P
INNER JOIN Categories AS C
ON p.CategoryID = c.CategoryID
where P.Discontinued = 0
 GROUP BY P.ProductName , c.CategoryID, C.CategoryName
 Having SUM(P.UnitsInStock) < 200
 ORDER BY c.CategoryName, p.ProductName
```
**HAVING** (Teniendo...): Es exactamente igual que un WHERE, pero solo funciona después de haber agrupado datos con GROUP BY.

**CONCAT** (Concatenar / Unir): Sirve para unir dos o más palabras o columnas de texto en una sola.
