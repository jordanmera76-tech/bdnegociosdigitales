/*
JOINS
1. INNER JOIN
2. LEFT JOIN
3. RIGT JOIN
4. FULL JOIN
*/

SELECT *
FROM Categories
inner join Products
ON Products.CategoryID = Categories.CategoryID ;

SELECT Categories.CategoryID,	
	Categories.CategoryName ,
	Products. ProductID,
	Products. ProductName,
	Products.UnitPrice,
	Products.UnitsInStock,
	(Products.UnitPrice * Products.UnitsInStock)
	AS [Precio Inventario]
FROM Categories
inner join Products
ON Products.CategoryID = Categories.CategoryID 
WHERE Categories.CategoryID = 9



--Crear un tabla a partir de una consulta

SELECT TOP 0 CategoryID, CategoryName
INTO Categoria
FROM Categories;

ALTER TABLE Categoria
ADD CONSTRAINT pk_Categoria
PRIMARY KEY (CategoryId);

INSERT INTO Categoria
VALUES ('C1'), ('C2'),('C3'),('C4'),('C5');

SELECT TOP 0
	ProductID AS [Numero_producto],
	ProductName AS [Nombre_producto],
	CategoryID AS [Catego_id]
INTO Producto
FROM Products

ALTER TABLE Producto
ADD CONSTRAINT pk_Producto
PRIMARY KEY (Numero_producto)

ALTER TABLE Producto
ADD CONSTRAINT fk_Producto_Categoria
FOREIGN KEY (Catego_id)
REFERENCES Categoria (CategoryID)
ON DELETE CASCADE;

INSERT INTO Producto
VALUES ('P1', 1), 
	   ('P2', 1), 
	   ('P3', 2), 
	   ('P4', 2), 
	   ('P5', 3), 
	   ('P6', NULL);

-- INNER JOIN

SELECT *
FROM Categoria AS C
INNER JOIN Producto AS P
ON C.CategoryID = P.Catego_id;

-- LEFT JOIN

SELECT *
FROM Categoria AS C
LEFT JOIN Producto AS P
ON C.CategoryID = P.Catego_id;

-- RIGHT JOIN

SELECT *
FROM Categoria AS C
RIGHT JOIN Producto AS P
ON C.CategoryID = P.Catego_id;

-- FULL JOIN

SELECT *
FROM Categoria AS C
FULL JOIN Producto AS P
ON C.CategoryID = P.Catego_id;

-- Simular el RIGHT JOIN  del query anterior con un LEFT JOIN

SELECT 
	C.CategoryID, 
	C.CategoryName, 
	P.Numero_producto, 
	P.Nombre_producto, 
	P.Catego_id
FROM Categoria AS C
RIGHT JOIN Producto AS P
ON C.CategoryID = P.Catego_id;

SELECT 
	C.CategoryID, 
	C.CategoryName, 
	P.Numero_producto, 
	P.Nombre_producto, 
	P.Catego_id
FROM Producto AS P
LEFT JOIN Categoria AS C
ON C.CategoryID = P.Catego_id;

SELECT *
FROM Categoria

SELECT *
FROM Producto

-- Visualizar todas las categorias que no tienen productos

SELECT *
FROM Categoria AS C
LEFT JOIN Producto AS P
ON C.CategoryID = P.Catego_id
WHERE Numero_producto IS NULL

-- Seleccionar todos los productos que no tienen categoria

SELECT *
FROM Categoria AS C
RIGHT JOIN Producto AS P
ON C.CategoryID = P.Catego_id
WHERE C.CategoryID IS NULL

-- Guardar en una tabla de productos nuevos todos aquellos productos que fueron agregados recientemente y no están en la tbal de apoyo

SELECT  * FROM Products

--voy a crear la tbla product new a partir de products, mediante una tabal






SELECT  TOP 0 
	ProductID  [product_number],
	ProductName AS [product_name],
	UnitPrice AS [unit_price],
	UnitsInStock AS [stock],
	(UnitPrice * UnitsInStock) AS [total]
	INTO products_new
FROM Products


Alter table products_new
ADD CONSTRAINT pk_products_new      ---primary key
primary key ([product_number])



SELECT p.ProductID, p.ProductName,
p.UnitPrice, p.UnitsInStock,
(p.UnitPrice * p.UnitsInStock) AS [Total],     ---consulta con todo
pw.*
FROM products AS p
left JOIN products_new as pw
ON p.ProductID = pw.product_number


SELECT 
	p.ProductID, 
	p.ProductName,
	p.UnitPrice, 
	p.UnitsInStock,
(p.UnitPrice * p.UnitsInStock) AS [Total],     ---consulta con todo
pw.*
FROM products AS p
inner JOIN products_new as pw
ON p.ProductID = pw.product_number



INSERT INTO products_new
SELECT  
	p.ProductName,
	p.UnitPrice, 
	p.UnitsInStock,
(p.UnitPrice * p.UnitsInStock) AS [Total]  ---se puso el INSERT INTO
FROM Products AS p
left JOIN products_new as pw
ON p.ProductID = pw.product_number
Where pw.product_number is null

SELECT*
FROM products_new





drop table products_new





