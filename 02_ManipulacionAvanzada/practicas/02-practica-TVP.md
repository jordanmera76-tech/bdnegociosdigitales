# 🛒Documentación de Proceso: Registro de Ventas con TVP (SQL Server)

## 1. Introducción
Este Documento implementa una solución para el registro de transacciones comerciales en SQL Server. La característica principal es el uso de **Table-Valued Parameters (TVP)**, que permite enviar múltiples filas de datos (un "carrito de compras") al servidor en una sola llamada, mejorando significativamente la eficiencia frente a las inserciones individuales.




## 2. Definición del Tipo de Tabla (TVP)
Para manejar el detalle de la venta, se creó un tipo de dato de tabla definido por el usuario. Este actúa como un contenedor temporal para los productos.

```sql
CREATE TYPE dbo.TVP_DetalleVenta AS TABLE
(
    id_producto INT,
    cantidad INT
)
```

## 3. Arquitectura del Procedimiento Almacenado

El procedimiento usp_agregar_venta_TVP encapsula toda la lógica de negocio necesaria para procesar una venta de forma atómica.

```sql
CREATE OR ALTER PROC usp_agregar_venta_TVP
@id_cliente NCHAR(5) ,
@detalle TVP_DetalleVenta READONLY
AS.....
```

 Parámetros de Entrada:

* **@id_cliente NCHAR(5)**: Identificador del cliente.

* **@detalle TVP_DetalleVenta READONLY**: Parámetro de solo lectura que contiene los ítems de la venta.

## 4. Comparacion de Cofigo sin y con TVP

* 🙋‍♂️**Codigo A (Manual/Individual)**

```sql
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

```

* 💻 **Codigo B (Automático/TVP)**


```sql
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
            ------- Ejecucion de Erroes se quedan igual-------
    END CATCH
```

Característica |    Código A (Manual/Individual)    | Código B (Automático/TVP)    |
--------------|------------------------------------|--------------------------------|
Entrada de datos	| @id_producto, @cantidad (Escalares) | @detalle (Variable de Tabla) |
Poder de proceso1 | registro por ejecución | $N$ registros por ejecución
Validación de stock	| Manual (Variable vs Variable) |	Lógica de conjuntos (Tabla vs Tabla)
Manejo de Memoria	| Usa variables locales (RAM pequeña) |	Usa memoria de tabla temporal (Estructura)
Rendimiento	| Lento para ventas grandes |	Optimizado para ventas de cualquier tamaño

## 5.Ejemplo de Ejecución Paso a Paso

Hecho lo anterior y que hemos puesto lo anterior como esta echo en la en EL **Codigo B** ahora enseñaremos como se realiza la ejecuacion del codigo con la estructura **TVP**

```sql
-- 1. Preparar el contenedor de datos
DECLARE @carrito_detalle TVP_DetalleVenta;

-- 2. Simular carga de productos (Carrito de compras)
INSERT INTO @carrito_detalle (id_producto, cantidad)
VALUES 
(3, 5), -- 5 unidades del producto ID 3
(2, 3); -- 3 unidades del producto ID 2

-- 3. Llamada al proceso principal
EXEC usp_agregar_venta_TVP
    @id_cliente = 'ALFKI',
    @detalle = @carrito_detalle;

-- 4. Verificación de resultados
SELECT * FROM TblVenta ORDER BY id_venta DESC;
SELECT * FROM TblDetalleVenta WHERE id_venta = (SELECT MAX(id_venta) FROM TblVenta);
```

## 6. Conclusiones

En conclusión, el uso de **TVP (Table-Valued Parameters)** es la mejor forma de manejar ventas porque nos permite procesar todo un "carrito de compras" de un solo golpe, en lugar de ir producto por producto.