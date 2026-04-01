/*============================= Creacion del USP_Agregar_Venta con TVP =========================  */

CREATE TYPE dbo.TVP_DetalleVenta AS TABLE
(
    id_producto INT,
    cantidad INT
)
GO

CREATE OR ALTER PROC usp_agregar_venta_TVP
@id_cliente NCHAR(5) ,
@detalle TVP_DetalleVenta READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
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

        IF EXISTS (SELECT D.id_producto FROM @detalle D LEFT JOIN CatProducto C ON D.id_producto = C.id_producto WHERE C.id_producto IS NULL)
            BEGIN
                PRINT 'El producto no existe'
                ;THROW 50002, 'El producto no existe', 1;
                RETURN;
            END
        

        IF EXISTS (SELECT 1 FROM @detalle D JOIN CatProducto C ON D.id_producto = C.id_producto 
            WHERE D.cantidad > C.existencia)
                BEGIN
                    PRINT 'Uno o más productos no tienen stock suficiente'
                    ;THROW 50003, 'Uno o más productos no tienen stock suficiente', 1;
                    RETURN;
                END
                

        INSERT INTO TblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        SELECT @idVenta, D.id_producto, C.precio, D.cantidad
        FROM @detalle D
        JOIN CatProducto C ON D.id_producto = C.id_producto;

        UPDATE C
        SET C.existencia = C.existencia - D.cantidad
        FROM CatProducto C
        JOIN @detalle D ON C.id_producto = D.id_producto;

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

DECLARE @carrito_detalle TVP_DetalleVenta;

INSERT INTO @carrito_detalle (id_producto, cantidad)
VALUES 
(3, 5),
(2, 3);

EXEC usp_agregar_venta_TVP
@id_cliente = 'ALFKI',
@detalle = @carrito_detalle;

SELECT *
FROM CatCliente

SELECT *
FROM CatProducto
GO