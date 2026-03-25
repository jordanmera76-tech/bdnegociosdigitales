--Subconsultas ecalares (un valor)

--Escalar en SELECT

SELECT 
	o.OrderID, 
	(od.Quantity * od.UnitPrice) AS [Total], 
	(SELECT AVG((od.Quantity * od.UnitPrice)) FROM [Order Details] AS od) as [AVGTOTAL]
FROM Orders AS o
INNER JOIN [Order Details] as od
ON o.OrderID = od.OrderID

--Mostrar el nombre del producto y el precio promedio de todos los productos

SELECT ProductName ,
	(SELECT AVG(UnitPrice) FROM Products) AS [Propedio de todos los productos]
FROM Products

--Mostrar cada empleado y la cantidad total de pedidos que tiene 


SELECT e.EmployeeID,FirstName, LastName, COUNT(o.OrderID) AS [Numero de Ordenes]
from Employees AS e
Inner join Orders AS o
on e.EmployeeID = o.EmployeeID
Group BY e.EmployeeID,FirstName, LastName

SELECT  e.EmployeeID,FirstName, LastName,
(
	SELECT COUNT(*)
	FROM Orders as o
	where e.EmployeeID = o.EmployeeID
)
FROM  Employees AS e



--Mostrar cada cliente y la fecha de su ultimo pedido

select o.OrderID, c.CompanyName,
	(SELECT SUM(od.Quantity * od.UnitPrice)
	FROM [Order Details] AS od
	WHere od.OrderID = o.OrderID) AS [Total]
from Orders AS O
INNER JOIN Customers AS C
on O.CustomerID = c.CustomerID




--Datos ejemplo

CREATE DATABASE bdsubconsultas ;
go


CREATE TABLE clientes(
	id_cliente int not null identity (1,1) primary key,
	nombre nvarchar(50) not null,
	ciudad nvarchar(20) not null
);
go

CREATE TABLE pedidos(
	id_pedido int not null identity (1,1) primary key,
	id_cliente int not null,
	total money not null,
	fecha date not null,
	CONSTRAINT fk_pedidos_clientes
	FOREIGN KeY (id_cliente)
	REFERENCES clientes(id_cliente)
);
go


INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

select *
from pedidos

select *
from clientes

--SELECIONAR los pedidos donde el total sea igual a al total maximo de ellos 

SELECT MAX(TOTAL)
FROM pedidos         ---SE INICIA POR LA SUBCONSULTA


SELECT  *
FROM pedidos
WHERE total = 1500

SELECT  *
FROM pedidos
WHERE total = (
	SELECT MAX(TOTAL)
FROM pedidos  
)

SELECT top 1 P.id_pedido, C.nombre, P.fecha, P.total
FROM pedidos AS P                                    ---- aui sew ocupo un top para ver solo un dato 
INNER JOIN clientes AS C
ON P.id_cliente = C.id_cliente
ORDER BY p.total DESC

SELECT  P.id_pedido, C.nombre, P.fecha, P.total
FROM pedidos AS P
INNER JOIN clientes AS C                             --- aqui se ocupo una subconsulta para llegar aun mimo esultado
ON P.id_cliente = C.id_cliente
where p.total = (
	SELECT MAX(TOTAL)
FROM pedidos  
)


--- SELECIONAR los pedidos al promedio

select AVG(total)
from pedidos

select * from pedidos
where total > (
	select AVG(total)
from pedidos
)


--Selecionar todos los pedidos del cliente que tenga el menor id

SELECT  MIN(id_cliente)
FROM pedidos

SELECT *
FROM pedidos
WHERE id_cliente = (
	SELECT  MIN(id_cliente)
FROM pedidos
)

SELECT id_cliente, COUNT(*) AS [Numero de Pedidos]
FROM pedidos
WHERE id_cliente = (
	SELECT  MIN(id_cliente)
FROM pedidos
)
GROUP BY id_cliente


---MOSTRAR los pedidos delpedido de la ultima orden

SELECT MAX(FECHA)
FROM pedidos

SELECT p.id_pedido, c.nombre, p.fecha, p.total
FROM pedidos AS p
inner join clientes as c
on p.id_cliente = c.id_cliente
where fecha = (
	SELECT MAX(FECHA)
FROM pedidos
)

--mostar todos los pedidos con un total que sea el mas bajo

select min(total)
from pedidos

select *
from pedidos
where total = (
	select min(total)
	from pedidos
)


--selecionar los pedidos con el nombre del cliente cuyo total (freight) sea mayor
-- al promedio general de freight

USE NORTHWND

select AVG(Freight)
FROM Orders


SELECT o.OrderID, c.CompanyName, CONCAT( o.Freight, ' ',E.LastName) AS [FULLNAME]
FROM Orders AS o
inner join Customers as c
ON o.CustomerID = c.CustomerID
inner join Employees as E
on e.EmployeeID = o.EmployeeID
where o.Freight > (
	select AVG(Freight)
FROM Orders
)
ORDER BY O.Freight desc

use bdsubconsultas
go

-- Subqueris con IN, ANY, ALL
--La clasula IN

--Clientes que han hecho pedidos

SELECT id_cliente
FROM pedidos




SELECT * 
FROM clientes 
WHERE id_cliente IN (
	SELECT id_cliente 
	FROM pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM clientes AS c
INNER JOIN pedidos AS p
ON c.id_cliente = p.id_cliente;


---CLIENTES que han echo pedidos 

SELECT  id_cliente
FROM pedidos
where total > 800


SELECT *
FROM pedidos
where id_cliente IN (
	SELECT  id_cliente
FROM pedidos
where total > 800
)

SELECT *
FROM pedidos
WHERE id_cliente  IN (1,3,1)


---Selecionar todos los clientes de la ciudad de mexico que han hecho pedidos 

SELECT id_cliente
FROM pedidos

SELECT *
FROM clientes
WHERE ciudad = 'CDMX'
AND id_cliente IN (
	SELECT id_cliente
FROM pedidos
)

----Selecionar clientes que no han echo pedidos 

SELECT *
FROM pedidos as p
INNER JOIN clientes as c
on p.id_cliente = c.id_cliente

SELECT *
FROM pedidos as p
Right JOIN clientes as c
on p.id_cliente = c.id_cliente

SELECT C.id_cliente, C.nombre, C.ciudad
FROM pedidos as p
Right JOIN clientes as c
on p.id_cliente = c.id_cliente
WHERE p.id_pedido is NULL


SELECT  *
FROM clientes 
where id_cliente not in (
	SELECT id_cliente
	FROM pedidos 
)

--seleccionar los pedidos de clientes de monterrey


SELECT *
FROM clientes
WHERE ciudad = 'Monterrey'
AND id_cliente IN (
	SELECT id_cliente
FROM pedidos
)

SELECT *
FROM pedidos
WHERE id_cliente IN (
		SELECT id_cliente
		FROM clientes
		where ciudad = 'Monterrey'
)



--Operador ANY
-- Selecionar a pedidos mayores que algun pdido de luis (id_clientes=2)

--primero la subconsulta

SELECT total
FROM pedidos
WHERE id_cliente = 2

--CONSULTA PRINCIPAL
SELECT *
FROM pedidos
where total  > ANY (
	SELECT total
FROM pedidos
WHERE id_cliente = 2
)


--seleccionar los pedidos mayores (total) de algun pedido de Ana
SELECT total 
FROM pedidos
WHERE id_cliente = 1

SELECT *
FROM pedidos 
WHERE total> ANY (SELECT total
FROM pedidos 
WHERE  id_cliente =1)



SELECT total
FROM clientes 
WHERE id_cliente =1


SELECT*
FROM pedidos 
WHERE total > ANY (
SELECT total
FROM pedidos 
WHERE id_cliente =1
);

--seleccionar los pedidos mayores algun pedido superior (total) a 500

SELECT total
FROM pedidos
WHERE total > 500

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
FROM pedidos
WHERE total > 500
)


--all

--Selecionar los pedidos deonde el total sea mayor a todos los totales de los pedidos de luis 

use bdsubconsultas

SELECT total
FROM pedidos
where id_cliente = 2

SELECT total
from pedidos

SELECT *
FROM pedidos
where total > ALL(
	SELECT total
FROM pedidos
where id_cliente = 2
)

--Selecionar Todos los clientes donde su ID sea menor que todos los clientes de la ciudad de Mexico

SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX'

SELECT id_cliente
FROM clientes
where id_cliente < all(
	SELECT id_cliente
	FROM clientes
	WHERE ciudad = 'CDMX'
)

--Sbconsultas correlacionadas

--Selecionar los clientes cuyo total de compras sea mayor a 1000

SELECT sum(total)
FROM pedidos AS P

SELECT *
FROM clientes AS C
WHERE (
	SELECT sum(total)
	FROM pedidos AS P
	WHERE c.id_cliente = c.id_cliente
)> 1000

SELECT sum(total)
FROM pedidos AS P
WHERE p.id_cliente = 3

---Selecionar todos los clientes que han  echo mas de un pedido

SELECT count(*)
FROM pedidos AS p 

SELECT c.id_cliente,c.nombre, c.ciudad
FROM clientes as c
where (
SELECT count(*)
FROM pedidos AS p 
where id_cliente = c.id_cliente
) > 1


--Selecionar el total de pedidos en donde su total debe ser mayor al promedio de los totales hechos por los clientes 

select avg(total)
from pedidos as p
where p.id_cliente = p.id_cliente

SELECT *
FROM pedidos as p
where total >(
	select avg(total)
from pedidos as p
)


---Selecionar todos los clientes cuyo pedio maximo sea mayor a 1,200

SELECT MAX(TOTAL)
from pedidos as p



SELECT *
FROM clientes AS C
where (
SELECT MAX(TOTAL)
from pedidos as p
where p.id_cliente = c.id_cliente
) > 1200



SELECT * FROM pedidos
SELECT * FROM clientes


