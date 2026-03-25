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


---- Operadores Relacionales (<,>,<=,>=, = !=, O <>)

/*
    Selecionar los prductos con precio mayor a 30
    Selecionar los productos con stock o igual a 20
    Seleionar los pedidos posterires a 1997
*/

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

SELECT *
FROM Orders


SELECT 
    OrderID , OrderDate, CustomerID, ShipCountry,
    YEAR(OrderDate) AS A�O,
    Month(OrderDate) AS MES,
    DAY(orderdate) AS DIA,
    DATEPART (YEAR, OrderDate) AS A�O2,
    DATEPART (Quarter, OrderDate) AS trimestre,
    DATEPART(WEEKDAY, OrderDate) AS [Dia semana],
    DATEPART (WEEKDAY, OrderDate) AS [Dia semana Nombre]
FROM Orders
WHERE OrderDate > '1997-12-31';


SELECT 
    OrderID , OrderDate, CustomerID, ShipCountry,
    YEAR(OrderDate) AS A�O,
    Month(OrderDate) AS MES,
    DAY(orderdate) AS DIA,
    DATEPART (YEAR, OrderDate) AS A�O2,
    DATEPART (Quarter, OrderDate) AS trimestre,
    DATEPART(WEEKDAY, OrderDate) AS [Dia semana],
    DATEPART (WEEKDAY, OrderDate) AS [Dia semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997;



SELECT 
    OrderID , OrderDate, CustomerID, ShipCountry,
    YEAR(OrderDate) AS A�O,
    Month(OrderDate) AS MES,
    DAY(orderdate) AS DIA,
    DATEPART (YEAR, OrderDate) AS A�O2,
    DATEPART (Quarter, OrderDate) AS trimestre,
    DATEPART(WEEKDAY, OrderDate) AS [Dia semana],
    DATEPART (WEEKDAY, OrderDate) AS [Dia semana Nombre]
FROM Orders
WHERE DATEPART(YEAR,OrderDate) > 1997;

SET LANGUAGE SPANISH;
SELECT 
    OrderID , OrderDate, CustomerID, ShipCountry,
    YEAR(OrderDate) AS A�O,
    Month(OrderDate) AS MES,
    DAY(orderdate) AS DIA,
    DATEPART (YEAR, OrderDate) AS A�O2,
    DATEPART (Quarter, OrderDate) AS trimestre,
    DATEPART(WEEKDAY, OrderDate) AS [Dia semana],
    DATEPART (WEEKDAY, OrderDate) AS [Dia semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997;

--Operadores Logicos (not and, or)

/*
Selecionar los productos que tengan un precio myor a 20 y menos de 100 unidades en stock

OBTENER LOS PEDIDOS QUE NO TENGA REGION
*/

SELECT ProductID, CategoryID, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20 and UnitsInStock < 100;

SELECT CustomerID , CompanyName, city, region, Country
FROM Customers
WHERE country = 'USA' or country = 'CANADA';



SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE shipRegion is null;

SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE shipRegion is not null;


SELECT
FROM Products;


--Operador IN

/*
Mostrar los clientes de Alemania, Francia y UK

Obtenere los productos donde la categoria sea 1,3 o 5
*/

SELECT *
FROM Customers
Where Country IN ('Germany', 'France', 'UK')
Order by Country DESC;


SELECT *
FROM Products
WHERE CategoryID in (1, 3, 5)
Order by CategoryID DESC;


--Obtenere los productos donde la categoria sea 1,3 o 5




--Operador BETWEEN

--Mostrar los productos cuyo precio esta entre 20 y 40

SELECT *
FROM Products
WHERE UnitPrice Between 20 AND 40
Order By UnitPrice;


SELECT
    ProductID,
    ProductName,
    UnitPrice
FROM Products
Where UnitPrice > 20 and UnitPrice < 100 

SELECT
    OrderID,
    OrderDate,
    ShipRegion
    
FROM Orders
Where ShipRegion is NULL



------LIKE  

----SELECIONAR TODOS LOS CUSTOMERS QUE COMIENSEN CON LA LETRA A  esro son comodines

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName Like 'an%';

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like 'l_nd_o';

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like '%as';



---Seleccionar los clientes donde la ciudad contenga la palabra L

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE City Like '%d.f%';

---Selecionar todos los clientes en su nombre que comience con a o b 

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE 'a%' or CompanyName Like 'b%';

----- ESTO SE OCUPA  el not entonces cabia 

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE NOT CompanyName LIKE 'a%' or CompanyName Like 'b%';

---ahi se hace la convinacion de un parentesis ose que se hace primero lo parentesis 

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE NOT (CompanyName LIKE 'a%' or CompanyName Like 'b%');

--- selecionar todos los clientes que comiense con b y termine con S

sELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName like 'b%s';


SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE 'a__%';

---Selecionar todos los clientes (Nombre) que comiense con "b", "s" , "o", "p"


SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[bsp]%';

---SAelecionar todos los Coustomer que comiense con a , c, d ,e or f

SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[abcdef]%';



SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[a-f]%'
ORDER BY 2 ASC;


SELECT CustomerID, CompanyName, City, Region , Country
FROM Customers
WHERE CompanyName LIKE '[^a-f]%'
ORDER BY 2 ASC;


---Selecionar todos los clientes de estados unidos o canada que inicia con b


SELECT CustomerID , CompanyName, city, region, Country
FROM Customers
WHERE Country in ( 'canada', 'USA') or CompanyName  like 'b%'  ;


SELECT CustomerID , CompanyName, city, region, Country
FROM Customers
WHERE Country in ( 'canada', 'USA') and CompanyName  like 'b%'  ;