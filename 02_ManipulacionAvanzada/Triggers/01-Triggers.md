# TRIGGERS EN SQL SERVER

## 1. Que es un Trigger?
 Un trigger (disparador)es un bloque de  codigo sql que se ejecuta automaticamente  cuando ocurre un evento en una tabla .

 ✨Eventos principales:

 - INSERT
 - UPDATE
 - DELETE   
 Nota: no se ejecutan manualmente , se activan solos

 ## 2. Para que sirve un Trigger?
 - Validaciones 
 - Auditoria (guardar historial)
 - Reglas de negocio
 - Automatización de procesos

 ## 3. Tipos de 
 
 - After Triggers
 se ejecuta despues del evento
 - Before Triggers
 se ejecuta antes del evento
 - INSTEAD OF Triggers
 remplaza la operacion original por otra

 ## 4. Sintaxis  basica 

 ```sql

 CREATE OR ALTER TRIGGER nombre_trigger
 ON nombre_tabla
 AFTER INSERT
 AS 
 BEGIN
 END;

```
## 5.Tablas especiales

| Tabla    | Edad | 
| :------------- | :--: | 
| INSERTED   |  NUEVOS DATOS| 
| María García   |  34  | 
| Carlos López   |  42  | 
| Ana Martínez   |  25  | 
