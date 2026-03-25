/* ============================================================================================ Variables en Transact-SQL =================================================================*/

DEclARE @EDAD INT;     ---DECLARACION DE VARIABLES
SET @EDAD = 21;

PRINT @EDAD
SELECT @EDAD AS [EDAD]

DECLARE @nombre as Varchar(30) = 'San Gallardo';
SELECT @nombre AS [Nombre];
SET @nombre = 'San Adonai'
SELECT @nombre AS [Nombre]
GO
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