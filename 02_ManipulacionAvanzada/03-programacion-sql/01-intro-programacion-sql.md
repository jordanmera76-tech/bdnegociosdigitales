# Lenguaje Transact-SQL (mss)

## 👽Fundamentos programables 

1. Que es la parte programable de T-SQL

Es todo lo que permite :

- Usar variables 
- Controlar el flujo (if / ese, while)
- Crear procedimiento almacenado (Stroed Procedures)
- Disparadores (Trigger)
- Manejar errores
- Crear funciones
- Usar Transaciones

Es convertir SQL en un Lenguaje casi C/J pero dentro del motor de base de datos

2. Variables /

📌 Una variable almacena un valor temporal

```sql
/* ============================================================================================ Variables en Transact-SQL =================================================================*/

DEclARE @EDAD INT;     ---DECLARACION DE VARIABLES
SET @EDAD = 21;

PRINT @EDAD
SELECT @EDAD AS [EDAD]

DECLARE @nombre as Varchar(30) = 'San Gallardo';
SELECT @nombre AS [Nombre];
SET @nombre = 'San Adonai'
SELECT @nombre AS [Nombre]

--------------------------------------------------EJERCICIO---------------------------
/* 
Ejericio 1

- Declarar una variable @Precio
- Asignar el valor 150
- Calcular el IVA
- Mostrar el total
*/

DECLARE @precio as Money = 150
Declare @IVA Decimal (10,2)
declare @Total Money
SET @IVA = @precio * 0.16;
SET @Total = @precio + @IVA 

SELECT @precio AS [Precio],
	CONCAT(@IVA, '$') AS [IVA(16%)],
	CONCAT('$', @Total) AS [Total]

```
3️⃣ IF/ELSE

📌📌 Definicion

Permite ejecutar codigo segun condicion

```sql

----------------------------------------------- IF/ELSE -----------------------------------------------

DECLARE @edad INT = 18;
SET @edad = 18;

if not @edad >= 18
	PRINT 'Eres mayor de edad';
ELSE
	Print 'Eres menor de edad'

--CALIFICACION SI ES MAYOR DE 70 ES APROBADO SI ES MENOR REPROBADO 

DECLARE @CALI DECIMAL(10,2) ;
SET @CALI = 11

IF @CALI >=0 AND @CALI <=10
BEGIN   
   if @CALI > 7
		PRINT 'APROBASTE'
   ELSE
		
		PRINT 'REPROBASTE'
END
ELSE
BEGIN
	SELECT CONCAT(@CALI, '  Esta fuera de rango') AS [Respuesta]
END
GO;
```

4️⃣ WHILE (Ciclos)

```sql 

/* =================================================      WHILE       =================================================================*/

DECLARE @limite int = 5
DEClARE @i int = 1

WHILE (@i <= @limite)
Begin
	PRINT CONCAT('Numero: ', @i)
	SET @i = @i + 1
END


```

