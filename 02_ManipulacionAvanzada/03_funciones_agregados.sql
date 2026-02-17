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

--seleciona el numero de ordeners realizada por el cliente CHOP-suey CHINESE en 1995

SELECT *
FROM Customers
WHERE CompanyName = 'Chop-suey Chinese'

Select CustomerID , count(*) AS [oRDENES REALIZADAS POR CHOP-SUEY]
fROM Orders
wHERE CustomerID = 'CHOPS' and year(OrderDate) = 1996
Group by CustomerID


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
 

