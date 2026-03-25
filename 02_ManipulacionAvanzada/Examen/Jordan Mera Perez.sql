--EXAMEN SQL - VERSION B

--B1 CLIENTES tipo 'S.A'
SELECT C.Num_Cli, C.Empresa, R.Nombre, C.Limite_Credito
FROM Representantes AS R
INNER JOIN Clientes AS C
ON R.Num_Empl = C.Rep_Cli 
WHERE c.Limite_Credito >= 40000 
and c.Empresa LIKE '%S.A%'
order by C.Limite_Credito DESC

--B2 Valor de inventario (productos)

SELECT Descripcion ,
	Precio ,
	Stock ,
	(Precio * Stock) as [ValorInventario]
FROM Productos
where Stock between 10 and 40
and Precio between 100 and 5000
order by ValorInventario DESC


--B3 Pedidos de empresa con 'Ltd'

SELECT p.Num_Pedido, p.Fecha_Pedido, c.Empresa, p.Importe
FROM Clientes AS C
INNER JOIN Pedidos AS P
ON C.Num_Cli = p.Cliente
where Empresa like '%Ltd%'
ORDER BY p.Fecha_Pedido ASC


--B4 Promedio de Ventas por oficina

SELECT
	o.Oficina,
	o.Ciudad,
	o.Region,
	AVG(r.Ventas * o.Oficina) as [PromedioVentaRep]
FROM Representantes AS R
inner join Oficinas as o
on r.Oficina_Rep = o.Oficina
GROUP BY o.Oficina,
	o.Ciudad,
	o.Region
ORDER BY AVG(r.Ventas * o.Oficina) DESC


--B5 Clientes con 2 o mas pedidos


SELECT DISTINCT c.Num_Cli, c.Empresa, p.Num_Pedido
FROM Clientes AS C
INNER JOIN Pedidos AS P
ON C.Num_Cli = p.Cliente
where p.Cantidad > 2




--B6 VENTAS CUMULADAS 
SELECT O.Ciudad, O.Region,
	SUM(R.Ventas) AS [TotalVentasReps],
	COUNT(R.Num_Empl) AS [Cantidad de Representantes]
FROM Representantes AS R
inner join Oficinas as o
on r.Oficina_Rep = o.Oficina
GROUP BY O.Ciudad , O.Region
HAVING O.Region IN ('Este' , 'Oeste')
order by TotalVentasReps Desc

--b7 VISTA CLIENTES-REPRESENTANTE-OFICINA

CREATE OR ALTER VIEW vw_ClientesRepOficina_B
as
SELECT c.Num_Cli ,c.Empresa, c.Limite_Credito, r.Nombre,r.Puesto,o.Ciudad, o.Region
FROM Clientes AS C
inner join Representantes AS R
on c.Rep_Cli = r.Num_Empl
inner join Oficinas as o
on r.Oficina_Rep = o.Oficina


--B8 Vistas ventas por clientes 
CREATE OR ALTER VIEW vw_VentasPorCliente_B
as
SELECT c.Num_Cli,c.Empresa ,
	SUM(p.Importe) as [TotalImporte],
	count(P.Num_Pedido) as [NUMPedidos]
FROM Clientes AS C
INNER JOIN Pedidos AS P
ON C.Num_Cli = p.Cliente
group by c.Num_Cli, c.Empresa
having SUM(p.Importe) >=30000
