# 📒 Acordeón de Transact-SQL y S.P.U. 

Este acordeón está diseñado como una guía de consulta rápida, estructurando los conceptos desde lo más básico hasta la lógica compleja de procedimientos y manejo de errores vistos en tus prácticas.

## 1. Fundamentos y Variables

Las variables en T-SQL son temporales y se identifican con el prefijo ` @ `.

* Declaración y Asignación:

```SQL
DECLARE @nombre VARCHAR(30) = 'Mande'; -- Declarar e inicializar
SET @nombre = 'Mande' -- Asignar valor
SELECT @nombre = 'Mande' -- Asignar mediante consulta

```

* Impresión de resultados:
    * `PRINT @variable `: Muestra texto en la pestaña de mensajes.
    * `SELECT @variable` AS [Alias]: Muestra el valor en una tabla de resultados.


## 2. Control de Flujo (Lógica)
Estructuras para tomar decisiones o repetir procesos.

**IF / ELSE**

Evalúa condiciones. Usa `BEGIN...END` si vas a ejecutar más de una línea de código.

```SQL
IF @condicion
    BEGIN ... END
ELSE
    BEGIN ... END
``` 

**WHILE (Ciclos)**

Repite un bloque de código mientras la condición sea verdadera.

```SQL
WHILE (@i <= @limite)
BEGIN
    SET @i = @i + 1;
END
```

**CASE (Switch)**

Ideal para clasificar datos en consultas `SELECT`.

```SQL
SELECT nombre,
    CASE
        WHEN precio >= 200 THEN 'CARO'
        WHEN precio >= 100 THEN 'MEDIO'
        ELSE 'BARATO'
    END AS Categoria
FROM Productos;
```

## 3. Stored Procedures (SP)
Objetos de la base de datos que encapsulan lógica reutilizable.

* Creación/Modificación:

```SQL
CREATE OR ALTER PROC usp_Nombre -- Prefijo sugerido: usp_ o spu_
@parametro1 INT,              -- Parámetro de entrada
@salida INT OUTPUT            -- Parámetro de salida
AS
BEGIN
    -- Lógica del procedimiento
END
```

* Ejecución:

 ```SQL
EXEC usp_Nombre @parametro1 = 10; -- Con parámetros
 ```

*  **Parámetros de Entrada**: Permiten enviar datos al procedimiento.

```SQL
CREATE PROC usp_saludar @nombre VARCHAR(50)
AS PRINT 'Hola ' + @nombre;
```
* **Parámetros de Salida (OUTPUT)**: Devuelven valores al usuario.

```SQL
CREATE PROC spu_sumar @a INT, @b INT, @res INT OUTPUT
AS SET @res = @a + @b;
```

## 4. Manejo de Errores (TRY...CATCH)

Permite que el código no "truene" y puedas capturar el error de forma controlada.

**Estructura:**

```SQL
BEGIN TRY
    -- Código peligroso (ej. SELECT 10/0)
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE(); -- Captura el mensaje
    PRINT 'Línea: ' + CAST(ERROR_LINE() AS VARCHAR);
END CATCH
```

| Bloque | Función Principal | Qué se ocupa dentro |
| :--- | :--- | :--- |
| **BEGIN TRY , END TRY** | **Zona de Ejecución**: Contiene todo el código que "podría" fallar. | Aquí colocas los `INSERT`, `UPDATE` o `DELETE` que modifican tus tablas. |
| **BEGIN CATCH, END CATCH** | **Zona de Rescate**: Se activa automáticamente si el TRY detecta un error. | Se ocupa para hacer `ROLLBACK` (deshacer cambios) e informar al usuario qué falló. |

## 5. Transacciones (Atomocidad)
Aseguran que un grupo de operaciones se realicen todas o ninguna.

* BEGIN TRANSACTION: Inicia el proceso.

* COMMIT: Guarda los cambios permanentemente.

* ROLLBACK: Deshace los cambios si algo salió mal.

* Patrón Seguro:

```SQL
BEGIN TRY
    BEGIN TRANSACTION;
    -- Operaciones de Insert/Update
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK; -- Si hay transacciones abiertas, deshacer
END CATCH
```
## 6. Funciones de Identidad y Filas Afectadas
Estas funciones son vitales cuando insertas datos y necesitas saber qué pasó inmediatamente después.

* **SCOPE_IDENTITY()**: Recupera el último valor de identidad (ID autoincrementable) generado en el bloque de código actual. Es más seguro que @@IDENTITY porque se limita al ámbito actual.

* **@@ROWCOUNT**: Devuelve el número de filas afectadas por la última instrucción (útil para validar si un UPDATE o DELETE realmente encontró el registro).

```SQL
INSERT INTO Tabla (Nombre) VALUES ('Ejemplo');
DECLARE @NuevoID INT = SCOPE_IDENTITY(); -- Guardar el ID recién creado

UPDATE Clientes SET Nombre = 'Mande' WHERE id = 100;
IF @@ROWCOUNT < 1 PRINT 'No se encontró el cliente'; -- Validar afectación

```


 ## 🚨Funciones de Diagnóstico de Errores

Estas funciones solo son válidas dentro del bloque **CATCH**. Permiten obtener información detallada sobre la excepción ocurrida para facilitar la depuración.

| Función | Descripción | Ejemplo de Salida |
| :--- | :--- | :--- |
| **ERROR_MESSAGE()** | Devuelve el texto descriptivo del error. | "El cliente no existe" |
| **ERROR_NUMBER()** | Muestra el código numérico del error (personalizado o interno). | 50001, 547, 8134 |
| **ERROR_LINE()** | Indica el número de línea exacto donde falló el código. | 45 |
| **ERROR_STATE()** | Devuelve el número del estado del error para diagnóstico avanzado. | 1 |
| **ERROR_PROCEDURE()**| Devuelve el nombre del procedimiento donde ocurrió el fallo. | "usp_agregar_venta" |
| **ERROR_SEVERITY()** | Devuelve el nivel de gravedad del error detectado. | 16 |

```sql
BEGIN CATCH
    -- Si hay una transacción abierta, se deshace para mantener la integridad
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

    -- Impresión de diagnóstico usando las funciones de la tabla anterior
    PRINT 'Mensaje: ' + ERROR_MESSAGE();
    PRINT 'Número de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Línea de Error: ' + CAST(ERROR_LINE() AS VARCHAR);
END CATCH
```




