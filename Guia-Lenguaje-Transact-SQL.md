## 3. Programación y Lógica (Avanzado)
| Categoría | Función / Comando | ¿Qué hace? | Ejemplo Sencillo |
| :--- | :--- | :--- | :--- |
| **Variables** | `DECLARE @` | Crea un espacio temporal en memoria. | `DECLARE @ID INT = 10;` |
| **Control** | `IF / ELSE` | Ejecuta código según una condición. | `IF @Stock > 0 PRINT 'Ok' ELSE PRINT 'No';` |
| **Control** | `WHILE` | Repite un bloque mientras sea cierto. | `WHILE @I < 5 BEGIN SET @I += 1; END;` |
| **Objetos** | `STORED PROC` | Guarda un bloque de código reutilizable. | `CREATE PROCEDURE Alta @Nom VARCHAR...` |
| **Objetos** | `TRIGGER` | Se dispara solo al insertar/editar/borrar. | `CREATE TRIGGER trg_Audit ON Ventas...` |
| **Errores** | `TRY...CATCH` | Atrapa errores para que el sistema no falle. | `BEGIN TRY ... END TRY BEGIN CATCH...` |
| **Transacción** | `BEGIN TRAN` | Inicia un grupo de cambios "todo o nada". | `BEGIN TRANSACTION; UPDATE...` |
| **Transacción** | `COMMIT` | Guarda los cambios de forma permanente. | `IF @Error = 0 COMMIT;` |
| **Transacción** | `ROLLBACK` | Deshace los cambios si algo salió mal. | `IF @Error <> 0 ROLLBACK;` |
| **Lógica** | `CASE` | El "IF-THEN" dentro de un SELECT. | `SELECT CASE WHEN X=1 THEN 'A' ELSE 'B' END;` |
| **Nulos** | `ISNULL()` | Reemplaza un NULL por un valor por defecto. | `SELECT ISNULL(Tel, 'N/A');` |