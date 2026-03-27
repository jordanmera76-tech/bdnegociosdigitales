

CREATE DATABASE bdpracticas
GO

use bdpracticas
GO


/*=================== Creacion de la tablas =============================     */


CREATE TABLE CatProducto (
    id_producto INT IDENTITY ,
    nombre_Producto VARCHAR(40),
    existencia INT,
    precio MONEY
    CONSTRAINT PK_CatProducto PRIMARY KEY (id_producto)
)

SELECT * FROM CatProducto
GO



CREATE TABLE CatCliente (
    id_cliente NCHAR(5) ,
    nombre_Cliente NVARCHAR(40),
    Pais NVARCHAR(15),
    Ciudad NVARCHAR(15)
    CONSTRAINT PK_CatCliente PRIMARY KEY (id_cliente)
);

SELECT * FROM CatCliente
GO



CREATE TABLE TblVenta (
    id_venta INT IDENTITY ,
    fecha DATE,
    id_cliente NCHAR(5),
    CONSTRAINT PK_TblVenta PRIMARY KEY (id_venta),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente) REFERENCES CatCliente(id_cliente)
)

SELECT * FROM TblVenta
GO



CREATE TABLE TblDetalleVenta(
    id_venta INT ,
    id_producto INT,
    precio_venta MONEY,
    cantidad_vendida INT,
    CONSTRAINT PK_TblDetalleVenta PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT FK_Detalle_Venta FOREIGN KEY (id_venta ) REFERENCES TblVenta (id_venta),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (id_producto) REFERENCES CatProducto (id_producto)
)

SELECT * FROM TblDetalleVenta
GO

/*================================= Pasar Northwind a BDpracticas ======================================================  */

INSERT INTO CatProducto (nombre_Producto, existencia, precio)
SELECT  ProductName, UnitsInStock, UnitPrice
FROM NORTHWND.dbo.Products

SELECT *
FROM NORTHWND.dbo.Products
GO


INSERT INTO CatCliente (id_cliente,nombre_Cliente,Pais,Ciudad)
SELECT CustomerID, CompanyName,Country,City
FROM NORTHWND.dbo.Customers

SELECT *
FROM NORTHWND.dbo.Customers
GO



/*============================= Creacion del USP_Agregar_Venta =========================  */

CREATE OR ALTER PROC usp_agregar_venta
@id_cliente NCHAR(5) = 'ANATR',
@id_producto INT = 3,
@cantidad INT = 5
AS
BEGIN
    BEGIN TRY
    BEGIN TRANSACTION;
        IF EXISTS  (SELECT id_cliente  FROM CatCliente WHERE id_cliente = @id_cliente)
            BEGIN
                INSERT into TblVenta
                (fecha,id_cliente) values (GETDATE(),@id_cliente)
                DECLARE @idVenta INT;
                SET @idVenta = SCOPE_IDENTITY();  

            END
        ELSE
            BEGIN
                PRINT 'El cliente no existe'
                ;THROW 50001, 'El cliente no existe', 1;
                RETURN;
            END

        if not EXISts (SELECT id_producto from CatProducto WHERE id_producto = @id_producto)
            BEGIN
                PRINT 'El producto no existe'
                ;THROW 50002, 'El producto no existe', 1;
                RETURN;
            END



        DECLARE @precio MONEY;
        DECLARE @cant_Act int;
        SELECT @precio  = precio, @cant_Act = existencia 
        FROM CatProducto 
        WHERE id_producto = @id_producto

        IF (@cantidad > @cant_Act)
            BEGIN
                PRINT 'No hay existencia suficiente. Store termina.';
                ;THROW 50003, 'No hay existencia suficiente. Store termina.', 1;
                RETURN;   
        END

        INSERT Into TblDetalleVenta 
        (id_venta,id_producto,precio_venta,cantidad_vendida) 
        VALUES (@idVenta,@id_producto,@precio,@cantidad)

        UPDATE CatProducto 
        SET existencia = existencia - @cantidad 
        WHERE id_producto = @id_producto;

        COMMIT; 
        PRINT 'Venta realizada con éxito';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Mensaje: ' + ERROR_MESSAGE();
        PRINT 'Numero de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Linea de Error: ' + cast(ERROR_LINE() AS VARCHAR);
    END CATCH
END
GO


EXEC usp_agregar_venta


SELECT *
FROM CatCliente

SELECT *
FROM CatProducto