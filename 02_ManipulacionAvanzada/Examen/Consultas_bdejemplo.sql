use bdejemplo

SELECT * FROM Clientes
SELECT * FROM Representantes
SELECT * FROM Productos
SELECT * FROM Oficinas
SELECT * FROM Pedidos

--CREAR un vista que visualise el total de las importes agrupados por producto 

SELECT * FROM Pedidos
SELECT * FROM Productos

CREATE OR ALTER VIEW VW_importes_productos
AS
SELECT PR.Descripcion AS [Nombre del Producto],
	sum(p.Importe) AS [TOTAL],
	sum(p.Importe * 1.15) as [IMPORTE DESCUENTO]
FROM Pedidos AS P
INNER JOIN Productos as pr
on P.Fab = PR.Id_fab
AND P.Producto = PR.Id_producto
GROUP BY pr.Descripcion

SELECT *
FROM VW_importes_productos
WHERE [Nombre del Producto] like '%brazo%'
AND [IMPORTE DESCUENTO] > 34000

---SELECIONAR los nombres de los representante y la soficionas donde trabajan

CREATE OR ALTER VIEW vw_oficinas_representantes
as
SELECT r.Nombre,
	r.Ventas  AS [ventasrepresetante],
	o.Oficina,
	o.Ciudad,
	o.Region,
	o.Ventas as [ventasoficiales]
FROM Representantes AS R
inner join Oficinas as o
on r.Oficina_Rep = o.Oficina


SELECT *
FROM Representantes
WHERE Nombre = 'Daniel Ruidrobo'

SELECT Nombre, Ciudad
FROM vw_oficinas_representantes
ORDER BY Nombre DESC


---Selecionar los pedidos con fecha en importe, el nombre del representante
--que lo realizo y al cliente que lo solicito

SELECT 
	P.Num_Pedido, 
	P.Fecha_Pedido, 
	P.Importe, 
	C.Empresa, 
	r.Nombre
FROM Pedidos AS P
INNER JOIN Clientes AS C
ON C.Num_Cli = P.Cliente
INNER JOIN Representantes AS R
on r.Num_Empl = p.Rep


---Selecionar los pedidos con fecha en importe, el nombre del representante
--que atendio al cliente y al cliente que lo solicito

SELECT 
	P.Num_Pedido, 
	P.Fecha_Pedido, 
	P.Importe, 
	C.Empresa, 
	r.Nombre
FROM Pedidos AS P
INNER JOIN Clientes AS C
ON C.Num_Cli = P.Cliente
INNER JOIN Representantes AS R
on r.Num_Empl = c.Rep_Cli




----EJERCICIOS PARA EL EXAMEN 

--Bloque 1: Vistas (Views) 
--1. Vista de Rendimiento por Oficina
--Crea una vista llamada VW_Rendimiento_Oficinas
--que muestre el nombre de la Ciudad, la Región y el Total de Ventas 
--acumulado de todos los representantes que trabajan en esa oficina.
CREATE OR ALTER VIEW VW_Rendimiento_Oficinas
as
SELECT  
	o.Ciudad,
	 o.Region,
	sum(r.Ventas) as [total de ventas]
FROM Oficinas AS O
INNER JOIN Representantes AS R
on o.Oficina = r.Oficina_Rep
group by o.Ciudad, o.Region

 


--2. Vista de Pedidos Detallados
--Crea una vista llamada VW_Detalle_Pedidos 
--que muestre el Num_Pedido, la Empresa (del cliente) y la Descripcion del producto vendido.
CREATE OR ALTER VIEW VW_Detalle_Pedidos
as
select p.Num_Pedido, c.Empresa, pr.Descripcion
from Pedidos as p
inner join Clientes as c
on p.Cliente = c.Num_Cli
inner join Productos as pr
on p.Fab = pr.Id_fab

---Bloque 2: Consultas Variadas (Joins, Agregados y Filtros) 
--3. El "Top" de Vendedores
--Selecciona el Nombre del representante y la Ciudad de su oficina,
--pero solo de aquellos cuya cuota sea mayor a 250,000.

SELECT R.Nombre , O.Ciudad , R.Cuota
FROM Representantes AS R
INNER JOIN Oficinas AS O
ON R.Oficina_Rep = O.Oficina
WHERE R.Cuota > 250000

--4. Conteo de Clientes por Vendedor
--Muestra el Nombre del representante y cuántos clientes tiene asignados cada uno. 
--Solo muestra a los que tengan más de 3 clientes.

SELECT R.Nombre, COUNT(C.Num_Cli) [numero de clientes]
FROM Clientes AS C
INNER JOIN Representantes AS R
ON C.Rep_Cli = R.Num_Empl
GROUP BY R.Nombre
HAVING COUNT(C.Num_Cli) > 3

SELECT * FROM Representantes
SELECT * FROM Clientes

--5. Productos "Peligrosos" (Bajo Stock)
--Muestra la Descripción del producto y el Precio, 
--pero solo de los productos cuyo fabricante (Id_fab) sea 'ACI' y tengan un stock entre 10 y 50 unidades.

SELECT  Id_fab,Descripcion, Precio
FROM Productos
WHERE Id_fab like 'ACI'
and Stock between 10 and 50

--6. Importe Total por Fabricante
--Calcula cuánto dinero se ha vendido en total (SUM) agrupado por el código del fabricante (Fab) de la tabla Pedidos.

select p.Fab, sum(r.Ventas) [venta totales]
from Pedidos as p
inner join Representantes as r
on p.Rep = r.Num_Empl
group by p.Fab

--7. Buscando a los "Jefes"
--Muestra el Nombre de los representantes que tienen asignada una oficina en la región 'Este'.

select r.Nombre, o.Region
from Representantes as r
inner join Oficinas as o
on r.Oficina_Rep = o.Oficina
where o.Region  in ('Este')

--8. Pedidos de Clientes con "L"
--Selecciona el Num_Pedido y el Importe de todos los pedidos realizados por clientes cuyo nombre de empresa comience con la letra 'A' o 'B'.

select p.Num_Pedido , p.Importe , c.Empresa
from Pedidos as p
inner join Clientes as c
on p.Cliente = c.Num_Cli
where c.Empresa like '[AB]%'






-----ejercicio .2

--Bloque 3: Vistas y Lógica de Negocio 

--1. Vista de Clientes con "Potencial"
--Crea una vista llamada VW_Clientes_VIP que muestre la Empresa y su Límite de Crédito, 
--pero solo de aquellos cuyo límite sea mayor a 50,000 y que estén asignados a un representante de la oficina 12.

CREATE OR ALTER VIEW VW_Clientes_VIP
as
select c.Empresa, c.Limite_Credito, r.Oficina_Rep
from Representantes as r
inner join Clientes as c
on r.Num_Empl = c.Rep_Cli

select * 
from VW_Clientes_VIP
where Limite_Credito > 50000
and Oficina_Rep = 12

select* 
from Representantes



--2. Vista de Productos Caros por Fabricante
--Crea una vista llamada VW_Productos_Premium que muestre el fabricante (Id_fab), la descripción y el precio, donde el precio sea mayor a 500.

CREATE OR ALTER VIEW VW_Productos_Premium
as
select Id_fab, Descripcion, Precio
from Productos
where Precio  > 500


--3. El Rendimiento del "Jefe"
--Muestra el Nombre del representante y sus Ventas, pero solo si sus ventas son mayores a su Cuota. Ordénalos de mayor a menor venta.

select Nombre, Ventas, Cuota
from Representantes
where Ventas > Cuota

--4. Pedidos por Trimestre
--Cuenta cuántos pedidos se realizaron en cada trimestre del año 1990.

select  DATEPART(QUARTER, Fecha_Pedido)  as [trimestre],
	COUNT(*) as [total de pedidos]
from Pedidos
where year(Fecha_Pedido) = 1990
group by DATEPART(QUARTER, Fecha_Pedido)
ORDER BY [Trimestre] ASC;

--5. Inventario por Fabricante
--Calcula el valor total del inventario (Precio * Stock) por cada fabricante.

select sum(p.Precio * p.Stock) as [valor total], p.Id_fab
from Productos as p
inner join Pedidos as pe
on p.Id_fab = pe.Fab and p.Id_producto = pe.Producto
group by p.Id_fab


--6. Clientes sin Región Definida
--Muestra el nombre de la Empresa y la Ciudad de todos los clientes que NO tienen una región asignada en la base de datos de oficinas.

select c.Empresa, o.Ciudad
from Representantes as r
inner join Clientes as c
on r.Num_Empl = c.Rep_Cli
inner join Oficinas as o
on r.Oficina_Rep = o.Oficina
where o.Region is  null

--7. Ventas "Pequeñas"
--Muestra el Num_Pedido, el Importe y el nombre del Producto de todos los pedidos donde la cantidad sea menor a 5 unidades.

select Num_Pedido, Importe, Producto
from Pedidos
where Cantidad < 5

select *
from Pedidos
select *
from Productos

SELECT P.Num_Pedido, P.Importe, PR.Descripcion
FROM Pedidos AS P
INNER JOIN Productos AS PR 
ON P.Fab = PR.Id_fab AND P.Producto = PR.Id_producto
WHERE P.Cantidad < 5;


--8. Buscando Vendedores Jóvenes
--Muestra el Nombre y la Edad de los representantes que tengan entre 20 y 40 años y cuyo nombre empiece con 'D' o 'B'.

select Nombre, Edad
from Representantes
where Edad between 20 and 40
and Nombre like '[DB]%'