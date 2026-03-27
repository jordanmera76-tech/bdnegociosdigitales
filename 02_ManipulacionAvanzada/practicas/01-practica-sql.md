# Practica de SQL con Store Procedure

En esta practica se realizo un actividad ocupando un Stored Procedure en el cual se crea una Base de Datos llamada bdpracticas utilizando datos de la Base de **NORTHWIND**


## Creacion de la Base de datos y las tablas 

Se creo lo que fue la base de datos llamada **bdpracticas** 

```sql
CREATE DATABASE bdpracticas
GO
```

Ya creada las tablas que se nos pidieron las cuales son:

- CatProducto
- CatCliente
- TblVenta
- TblDetalleVenta

Quedando de la siguiente manera

![code](/IMG/code.png)

Acontinuacion se mostrar como quedo la base de datos 

![Diagrama](/IMG/diagrama.png)

En la tabal de abajo se mostrar como esta relacionada las tablas con su respectivo FOREING KEY y PRYMARY KEY

| Tabla | Llave Primaria (PK) | Llave Foránea (FK) | Referencia a... | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| **CatProducto** | `id_producto` | *Ninguna* | - | Catálogo maestro de productos con stock actual. |
| **CatCliente** | `id_cliente` | *Ninguna* | - | Catálogo maestro de clientes (NCHAR 5). |
| **TblVenta** | `id_venta` | `id_cliente` | `CatCliente` | Cabecera de la venta con fecha automática. |
| **TblDetalleVenta** | `id_venta`, `id_producto` | `id_venta` | `TblVenta` | Detalle de productos por cada folio de venta. |
| | | `id_producto` | `CatProducto` | Relación para obtener precios y descontar stock. |

## Datos NORTHWIND a bdpracticas

Lo que se hizo a continuaciacion fue que setras paso unos datos de la Base de Datos de **NORTWIND** a **bdpracticas** que estas tienen que se sus similitudes , por ejemplo si la tabla que se creo fue de ` CatProducto ` de bdpracticas entonces deberia que ocupar la tabla `Poriducts` de NORTHWIND CON EL COMANDO **INSER INTO** como se muestra abajo

```sql

-- De la tabla Products(NORTHWND) a la tabla CatProduct(dbpracticas)
INSERT INTO CatProducto (nombre_Producto, existencia, precio)
SELECT  ProductName, UnitsInStock, UnitPrice
FROM NORTHWND.dbo.Products



-- De la tabla Customers(NORTHWND) a la tabla CatCliente(dbpracticas)
INSERT INTO CatCliente (id_cliente,nombre_Cliente,Pais,Ciudad)
SELECT CustomerID, CompanyName,Country,City
FROM NORTHWND.dbo.Customers


```
- Dato: Como pueden ver se ocupo un una linea de codigo muy particular `NORTHWND.dbo.Customers` esta es la dirección completa de un objeto en SQL Server. Sirve para decirle al sistema exactamente dónde buscar cuando la tabla no está en la base de datos que estás usando actualmente.

## Creacion de Stored Procedure

Para el ultimo paso creamos el Stored Procedure llamado **usp_agregar_venta** en el cual llamamos valores para que este pueda intepretar que es loq ue deberemos vender , como al cliente, que producto deria y cuando seria la cantidad de este 

```sql
CREATE OR ALTER PROC usp_agregar_venta
@id_cliente NCHAR(5) = 'ANATR',
@id_producto INT = 3,
@cantidad INT = 5
AS
```
### Explicación del Bloque: Registro de Venta y Validación de Cliente

Este bloque inicia el proceso de venta asegurando que el cliente sea válido y generando un número de folio.

1.  **Seguridad (`BEGIN TRANSACTION`):** Inicia la unidad de trabajo. Si algo falla después, se deshace todo para no dejar datos a medias.
2.  **Filtro de Cliente (`IF EXISTS`):** Revisa que el `@id_cliente` esté registrado. Si no existe, lanza un `;THROW 50001` y detiene el proceso de inmediato.
3.  **Creación de Factura (`INSERT`):** Crea la cabecera en `TblVenta` con la fecha actual y el ID del cliente.
4.  **Captura de Folio (`SCOPE_IDENTITY`):** Atrapa el número de `id_venta` que SQL acaba de generar y lo guarda en la variable `@idVenta`. Esto permite "amarrar" los productos a esta misma venta más adelante.

```sql
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
```

### Explicación del Bloque: Validación de Existencia de Producto

Este bloque actúa como el **Filtro de Catálogo** para asegurar que el artículo solicitado exista.

1. **Integridad (`IF NOT EXISTS`):** Consulta la tabla `CatProducto`. Si el ID no existe, activa la alerta de error.
2. **Aviso (`PRINT`):** Envía un mensaje informativo al panel de SQL para el administrador.
3. **Interrupción (`;THROW 50002`):** Detiene el proceso inmediatamente y asigna el código de error único por "Producto Inexistente".
4. **Limpieza (`CATCH`):** Envía el control al bloque de error para ejecutar el `ROLLBACK`, asegurando que no se registren ventas de productos que no existen.

```sql
 if not EXISts (SELECT id_producto from CatProducto WHERE id_producto = @id_producto)
            BEGIN
                PRINT 'El producto no existe'
                ;THROW 50002, 'El producto no existe', 1;
                RETURN;
            END

```

### Explicación del Bloque: Validación de Stock e Inserción de Detalle

Este bloque valida el stock antes de confirmar la venta para evitar inventarios negativos.

1. **Captura de Datos:** Obtiene el `precio` y la `existencia` actual del producto desde `CatProducto`.
2. **Validación de Stock:** Si la cantidad solicitada es mayor a la existencia, el sistema lanza un `;THROW 50003` y detiene el proceso de inmediato.
3. **Registro de Detalle:** Si hay suficiente stock, inserta una fila en `TblDetalleVenta` usando el `@idVenta` capturado previamente, asegurando que el producto quede vinculado a la factura correcta.

```sql
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
```

### Actualización de Inventario y Cierre de Transacción

Este bloque ejecuta la salida física del producto y confirma que toda la operación fue exitosa.

1. **Salida de Bodega (`UPDATE`):** Resta la `@cantidad` vendida del stock actual en `CatProducto`. Esto garantiza que el inventario siempre refleje lo que realmente queda disponible.
2. **Confirmación Final (`COMMIT`):** Es el comando de "Guardar". Le dice a SQL que todas las validaciones pasaron y que ya puede grabar los cambios (Venta, Detalle y Stock) de forma permanente.
3. **Mensaje de Éxito (`PRINT`):** Informa al usuario que el proceso terminó correctamente y la venta ha sido registrada.

```sql
UPDATE CatProducto 
        SET existencia = existencia - @cantidad 
        WHERE id_producto = @id_producto;

        COMMIT; 
        PRINT 'Venta realizada con éxito';
```

### Manejo de Errores y Limpieza (Bloque CATCH)

Este bloque actúa como el **Protocolo de Emergencia** del procedimiento almacenado. Se activa automáticamente si ocurre cualquier error durante la ejecución.

1. **Limpieza Automática (`ROLLBACK`):** Gracias a la función `@@TRANCOUNT > 0`, el sistema revisa si hay una transacción abierta. Si la hay, deshace absolutamente todos los cambios (Venta, Detalle y Stock) para que la base de datos quede exactamente como estaba antes de empezar.
2. **Diagnóstico de Errores (`PRINT`):** Utiliza funciones nativas de SQL para informar qué pasó:
   * **ERROR_MESSAGE()**: Muestra el texto del error (el que pusimos en el `THROW`).
   * **ERROR_NUMBER()**: Muestra el código (ej. 50001, 50002).
   * **ERROR_LINE()**: Indica en qué renglón exacto falló el código.
3. **Seguridad de Datos:** Este bloque garantiza que nunca se guarden datos incompletos o erróneos, manteniendo la integridad de la base de datos `bdpracticas`.

```sql
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Mensaje: ' + ERROR_MESSAGE();
        PRINT 'Numero de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Linea de Error: ' + cast(ERROR_LINE() AS VARCHAR);
    END CATCH
```

## 🧪 Pruebas de Funcionamiento y Validación

Para verificar que el Stored Procedure cumple con todas las reglas de negocio, se realizaron las siguientes pruebas de ejecución en SQL Server:

###  Registro de Venta Exitosa
Se ejecuta el procedimiento con datos válidos para confirmar que se inserta la cabecera, el detalle y se descuenta el stock.
```sql
EXEC usp_agregar_venta 
    @id_cliente = 'ANATR', 
    @id_producto = 3, 
    @cantidad = 5;
```

