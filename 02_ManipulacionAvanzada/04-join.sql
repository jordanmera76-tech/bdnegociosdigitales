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
ON Products.CategoryID = Categories.CategoryID ;
WHERE ON Categori