/* ===================================================== Stored Procedures===============================*/

CREATE DATABASE bdstored;
go

use bdstored;
go
-- Ejemplo Simple



CREATE PROCEDURE uso_Mensaje_Saludar
 --No tendra parametro
AS
BEGIN
	PRINT 'Hola mundo Transact SQL desde SQL SERVER'
END
GO
-- Ejecutar
EXECUTE uso_Mensaje_Saludar
GO


CREATE PROCEDURE uso_Mensaje_Saludar2
 --No tendra parametro
AS
BEGIN
	PRINT 'Hola mundo Ing en Ti'
END
GO
--ejecutar
EXEC uso_Mensaje_Saludar2
GO


CREATE PROC uso_Mensaje_Saludar3
 --No tendra parametro
AS
BEGIN
	PRINT 'Hola mundo ENTORNOS VIRTUALES Y REDES DIUITALES';
END
GO

CREATE OR ALTER PROC usp_Mensaje_Saludar3       ---asi para crear o alterar la tabla
 --No tendra parametro
AS
BEGIN
	PRINT 'Hola mundo ENTORNOS VIRTUALES Y NEGOCIOS DIGITALES';
END
GO
--Ejecutar
EXEC usp_Mensaje_Saludar3

DROP PROCEDURE uso_Mensaje_Saludar3    ---Elimnina el procedure
go


-- Crear un SP que muestre la fecha actual del sistema

CREATE OR ALTER PROC usp_Servidor_FechaActual

AS
BEGIN
	SELECT CAST(GETDATE () AS DATE) AS [Fecha del sistema]
END
GO;

EXEC usp_Servidor_FechaActual
go
-- Crear un ST que muestre la base de Datos (DB_NAME())

CREATE OR ALTER PROC spu_Dbname_get

AS
BEGIN
	SELECT 
		DB_NAME() as [nombre de la base de datos],
		HOST_NAME() AS [Machine],
		SUSER_NAME() AS [SQLUSER], 
		SYSTEM_USER AS [SYSTEM USER],
		APP_NAME() AS [APPLICATION]
END
go

EXEC spu_Dbname_get
GO


/*======================================================== STORED PROCEDURES CON PARAMETROS ===================================================*/

CREATE OR ALTER PROC usp_persona_saludar
	@nombre VARCHAR(50)
AS
BEGIN
	PRINT 'Hola ' + @nombre
END
GO

EXEC usp_persona_saludar 'Israel';
EXEC usp_persona_saludar 'Artemio';
EXEC usp_persona_saludar 'Irais';
EXEC usp_persona_saludar @nombre='Artemio';

DECLARE @name VARCHAR(50)
SET @name ='Yael'

EXEC usp_persona_saludar @name
go

/* TODO: EJEMPLO CON consulta, vamos a crear una tabla de clientes basad en la tabla de customer
de Northwind*/

SELECT CustomerID, CompanyName
INTO Customers
FROM NORTHWND.dbo.Customers
GO


---CREAR UN SP que busque un cliente en especifico 
SELECT *
FROM Customers
go

CREATE OR ALTER PROC spu_Customer_buscar
@id NCHAR(10)
AS
BEGIN

	SET @id = TRIM(@id)
	
	
	IF LEN(@id) <= 0 OR LEN(@id) > 5
	BEGIN
		PRINT ('EL ID DEBE ESTAR EN EL RANGO DE 1 A 5 DE TAMA�O');
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
	BEGIN
		PRINT 'EL CLIENTE NO EXISTE EN LA BD'
	END

	SELECT CustomerID as [NUMERO], CompanyName as [Cliente]
	FROM Customers
	where CustomerID = @id
END
go

SELECT *
FROM Customers
WHERE CustomerID = 'ANTON'

EXEC spu_Customer_buscar 'YUTTT'

SELECT *
FROM NORTHWND.dbo.Categories
where not Exists (
select 1
from Customers
where CustomerID = 'ANTON'
)
GO

--EJERCICIOS : Crear un SP que reciba un numero y que verifique que no sea negativo , si es negativo imprimir valor no valido y si no multiplicarlo x5
--para mostrarlo ocupar un SELECT

CREATE OR ALTER PROC usp_numero_multiplicar
@number INT
AS
BEGIN
	IF @number <= 0
		BEGIN
			PRINT 'El numero no puede ser negativo ni cero'
			RETURN;
		END;
	SELECT (@number * 5) AS [OPERACION]
END;
GO;

EXEC usp_numero_multiplicar -34
EXEC usp_numero_multiplicar -34
EXEC usp_numero_multiplicar 0
EXEC usp_numero_multiplicar 5
go;

--EJERCICIO 2: Crear un SP que reciba un numbre y que lo escriba en MAYUSCULAS
CREATE OR ALTER PROC usp_nombre_mayusculas
@name VARCHAR(15)
AS
BEGIN
	SELECT UPPER(@name) AS [NAME]
END
GO;

EXEC usp_nombre_mayusculas 'monico'
GO

---TODO: PARAMETROS DE SALIDA

/*====================================================Parametros de Salida =======================================================*/


----CON SET
CREATE OR ALTER PROC spu_numeros_sumar
	@a INT,
	@b INT,
	@resultado INT OUTPUT
	AS
	BEGIN
		SET @resultado = @a + @b
	END
GO

DECLARE @res INT
EXEC spu_numeros_sumar 5,7,@RES OUTPUT;
SELECT @res AS [Resultado]
GO

------Con SELECT
CREATE OR ALTER PROC spu_numeros_sumar2
	@a INT,
	@b INT,
	@resultado INT OUTPUT
	AS
	BEGIN
		SELECT @resultado = @a + @b
	END
GO

DECLARE @res INT
EXEC spu_numeros_sumar2 5,7,@RES OUTPUT;
SELECT @res AS [Resultado]
GO


---- CREAR UN SP QUE DEVUELVA EL AREA DE UN CIRCULO

CREATE or alter PROC usp_area_circulo
@radio DECIMAL(10,2),
@area  DECIMAL(10,2) OUTPUT
AS
BEGIN
	--SET @area = PI() * @radio * @radio
	SET @area = PI() * POWER(@radio,2);
END
GO

DECLARE @r DECIMAL(10,2);
EXEC usp_area_circulo 2.4, @r OUTPUT
SELECT @r AS [area del circulo]
GO
--crea un sp que reciba idcliente y devuelva el nombre

CREATE OR ALTER PROC usp_cliente_obtener
	@id NCHAR(10),
	@name NVARCHAR(40) OUTPUT
AS
BEGIN
	IF LEN(@id) = 5
	BEGIN
		IF EXISTS (select 1 from Customers WHERE CustomerID = @id)
		BEGIN
			SELECT @name = CompanyName
			FROM Customers
			WHERE CustomerID = @id


			RETURN;
		END


		PRINT ' customer no Existe'
		RETURN;
	END

	PRINT 'El ID DEBE SER DE TAMAÑO 5'
END
GO

SELECT *
FROM Customers

DECLARE @name NVARCHAR(40)
EXEC usp_cliente_obtener 'ANTONI', @name OUTPUT
SELECT @name AS [NOMBRE DEL CLIENTE]
GO

/*=================================================================== CASE =========================================================*/

CREATE OR ALTER PROC spu_evaluar_calificacion
@calif INT
AS
BEGIN
	SELECT
		CASE
			WHEN @calif >=90 then 'EXELENTE'
			WHEN @calif >=70 THEN 'APROBADO'
			WHEN @calif >=60 THEN 'REGULAR'
			ELSE 'NO APROBADO'
		END AS [RESULTADO]
END

EXEC spu_evaluar_calificacion 100
EXEC spu_evaluar_calificacion 75
EXEC spu_evaluar_calificacion 55
EXEC spu_evaluar_calificacion 65
EXEC spu_evaluar_calificacion 55
go

---CASE dentro de un select
use NORTHWND
GO

CREATE TABLE bdstored.dbo.Prorodutos
(
	nombre VARCHAR (50),
	precio money
)

---Inserta los datos basados en la consulta (SELECT)
INSERT INTO bdstored.dbo.Prorodutos
SELECT 
	ProductName,UnitPrice
	FROM NORTHWND.dbo.Products

--EJERCICIO CON CASE

SELECT
	nombre, 
	precio,
	CASE
		WHEN precio >= 200 THEN 'CARO'
		WHEN precio >= 100 THEN 'MEDIO'
		ELSE 'Barato'
	END AS [CATEGORIA]
FROM bdstored.dbo.Prorodutos
GO

---SELECIONAR los clientes , con su nombre, pais , ciudad y region (Los Valores Nulos, 
--Vizualizalos con la leyenda sin region), Ademas quiero que todo el resultado Este en Mayusculas

use NORTHWND
GO

CREATE OR ALTER VIEW vw_buena
AS
	SELECT 
		UPPER(CompanyName) AS [CompanyName],
		UPPER(c.Country) AS [Country],
		UPPER(c.City) AS [City],
		UPPER(ISNULL(c.Region, 'Sin Region' )) AS [Region Limpia],
		LTRIM(UPPER(CONCAT(e.FirstName, ' ', e.LastName))) AS [FullName],
		ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
		CASE
			WHEN SUM(od.Quantity * od.UnitPrice) >=30000 AND SUM(od.Quantity * od.UnitPrice) <=55000 THEN 'GOLD'
			WHEN SUM(od.Quantity * od.UnitPrice) >=10000 AND SUM(od.Quantity * od.UnitPrice) < 30000 THEN 'SILVER'
			ELSE 'BRONCE'
		END AS [Medallon]
	FROM NORTHWND.dbo.Customers AS c
	INNER JOIN
	NORTHWND.dbo.Orders AS O
	ON C.CustomerID = o.CustomerID
	INNER JOIN NORTHWND.dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN NORTHWND.dbo.Employees AS e
	ON e.EmployeeID = o.EmployeeID
	GROUP BY c.CompanyName, c.Country,c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName)
GO



CREATE OR ALTER PROC spu_informe_clientes_empleados
@nombre VARCHAR(50),
@region VARCHAR(50)
AS
BEGIN
	SELECT *
		FROM vw_buena
		WHERE FullName = @nombre
		AND [Region Limpia] = @region
END
GO






---Todo el proceso en uso de CASE
	SELECT 
		UPPER(CompanyName) AS [CompanyName],
		UPPER(c.Country) AS [Country],
		UPPER(c.City) AS [City],
		UPPER(ISNULL(c.Region, 'Sin Region' )) AS [Region Limpia],
		LTRIM(UPPER(CONCAT(e.FirstName, ' ', e.LastName))) AS [FullName],
		ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
		CASE
			WHEN SUM(od.Quantity * od.UnitPrice) >=30000 AND SUM(od.Quantity * od.UnitPrice) <=55000 THEN 'GOLD'
			WHEN SUM(od.Quantity * od.UnitPrice) >=10000 AND SUM(od.Quantity * od.UnitPrice) < 30000 THEN 'SILVER'
			ELSE 'BRONCE'
		END AS [Medallon]
	FROM NORTHWND.dbo.Customers AS c
	INNER JOIN
	NORTHWND.dbo.Orders AS O
	ON C.CustomerID = o.CustomerID
	INNER JOIN NORTHWND.dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN NORTHWND.dbo.Employees AS e
	ON e.EmployeeID = o.EmployeeID
	WHERE UPPER(CONCAT(e.FirstName, ' ', e.LastName)) = UPPER('ANDREW FULLER') AND
		UPPER(ISNULL(c.Region, 'Sin Region' )) = UPPER('Sin Region')
	GROUP BY c.CompanyName, c.Country,c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName)
	ORDER BY FullName ASC, [Total] DESC
go


/* ===================================================================== Manejo de Errores   =====================================================================================*/

USE bdstored
go


-- SIN TRY - CATCH
SELECT 10/0
go


-- CON TRY - CATCH
BEGIN TRY
	SELECT 10/0;
END TRY 
BEGIN CATCH
	PRINT 'OCURRIO UN ERROR';
END CATCH
GO

---- EJEMPLO DE USO DE FUNCIONES PARA OBTENER INFORMACION DEL ERROR
BEGIN TRY
	SELECT 10/0;
END TRY 
BEGIN CATCH
	PRINT 'Mensaje ' + ERROR_MESSAGE();
	PRINT 'Numero de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
	PRINT 'Linea de Error: ' + cast(ERROR_LINE() AS VARCHAR);
	PRINT 'Estado del ERROR: ' + CAST(ERROR_STATE() AS VARCHAR);
END CATCH
go

CREATE TABLE clientes (
	id INT PRIMARY KEY,
	nombre VARCHAR(35)
);
GO

INSERT INTO clientes
VALUES(1, 'PANFILO');
GO

BEGIN TRY
	INSERT INTO clientes
	VALUES(1, '');
END TRY
BEGIN CATCH
	PRINT 'ERROR AL INSERTAR: ' + ERROR_MESSAGE();
	PRINT 'ERROR EN LA LINEA: ' + CAST(ERROR_LINE() AS VARCHAR );
END CATCH
GO 


BEGIN TRANSACTION 

INSERT INTO clientes
VALUES(2, 'PANFILO');

INSERT INTO clientes
VALUES(2, 'AMERICO ANGEL');

SELECT * FROM clientes

COMMIT;
ROLLBACK
GO

--EJEMPLO DXE UJSO DE TRANSACCIONES JUNTO CON EL try catch

SELECT * 
FROM clientes

COMMIT;
ROLLBACK;

BEGIN TRY
	BEGIN TRANSACTION;
	INSERT INTO clientes
	Values (3,'VALDERABANO');
	INSERT INTO clientes
	values (4,'ROLES ALINA');
	COMMIT;
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 1
	BEGIN
		ROLLBACK;
	END
		PRINT 'Se hizo rollback por error';
		PRINT 'ERROR' + ERROR_MESSAGE();
END CATCH
GO

CREATE OR ALTER PROC usp_insertar_cliente
	@id INT,
	@nombre VARCHAR(35)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION


		INSERT INTO clientes
		VALUES (@id, @nombre)

		COMMIT
		PRINT 'Cliente 	Insertado'
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 1
			BEGIN
				ROLLBACK
			END
			PRINT 'ERROR: ' + ERROR_MESSAGE();
	END CATCH
END
GO



SELECT * FROM clientes


UPDATE clientes
SET nombre = 'AMERICO AZUL'
WHERE id = 2

IF @@ROWCOUNT < 1
BEGIN
	PRINT @@ROWCOUNT;
	PRINT 'NO EXISTE EL CLIENTE';
END
ELSE
PRINT 'CLIENTE ACTUALIZADO';




CREATE TABLE teams
(
	id int not null IDENTITY PRIMARY KEY,
	nombre NVARCHAR(15),
	
);

INSERT INTO teams (nombre)
VALUES ('CRUZ AZUL');

--Forma de tener un identity forma uni=2
DECLARE @id_insertado INT 
SET @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO: ' + CAST(@id_insertado AS VARCHAR);
SELECT @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado AS VARCHAR);
GO


INSERT INTO teams (nombre)
VALUES ('AGUILAS');

--Forma de tener un identity forma 2
DECLARE @id_insertado2 INT 
SET @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO: ' + CAST(@id_insertado AS VARCHAR);
SELECT @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado AS VARCHAR);