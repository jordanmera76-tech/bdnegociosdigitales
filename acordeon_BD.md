# 📑 Guía Maestra de Estudio: SQL & Modelo Relacional

Este documento combina la sintaxis esencial, el mapa de conexiones de tu base de datos y consejos estratégicos para evitar errores comunes.

---

##  1. Acordeón de Comandos SQL 

| Categoría | Función / Operador | ¿Qué hace? | Ejemplo Sencillo |
| :--- | :--- | :--- | :--- |
| **Básicos** | `AS` | Renombra una columna (Alias). | `SELECT City AS Ciudad FROM Customers;` |
| **Básicos** | `DISTINCT` | Elimina duplicados de la lista. | `SELECT DISTINCT Country FROM Customers;` |
| **Cálculos** | `*, +, -, /` | Realiza operaciones matemáticas. | `SELECT (UnitPrice * Quantity) AS Total;` |
| **Filtros** | `WHERE` | Filtra registros según una condición. | `WHERE UnitPrice > 30;` |
| **Filtros** | `BETWEEN` | Filtra valores dentro de un rango. | `WHERE UnitPrice BETWEEN 20 AND 40;` |
| **Filtros** | `IN` | Busca valores dentro de una lista. | `WHERE Country IN ('USA', 'UK');` |
| **Patrones** | `LIKE '%'` | Busca textos que inicien, terminen o contengan algo. | `WHERE City LIKE 'A%';` |
| **Agregados** | `COUNT(*)` | Cuenta el número total de filas. | `SELECT COUNT(*) FROM Orders;` |
| **Agregados** | `SUM()` | Suma todos los valores de una columna. | `SELECT SUM(UnitPrice) FROM Products;` |
| **Agregados** | `MAX() / MIN()` | Encuentra el valor más alto o más bajo. | `SELECT MAX(OrderDate) FROM Orders;` |
| **Grupos** | `GROUP BY` | Agrupa resultados para funciones de agregado. | `SELECT Country, COUNT(*) FROM Customers GROUP BY Country;` |
| **Grupos** | `HAVING` | Filtra los grupos (se usa después del GROUP BY). | `HAVING COUNT(*) > 5;` |
| **Fechas** | `YEAR()` | Extrae el año de una fecha. | `SELECT YEAR(OrderDate) FROM Orders;` |
| **Fechas** | `DATEPART()` | Extrae una parte específica (trimestre, día, etc.). | `SELECT DATEPART(QUARTER, OrderDate);` |

---
##   Comodines para LIKE 

| Comodín | Significado | Ejemplo |
| :--- | :--- | :--- |
| `%` | 0 o más caracteres. | `LIKE 'A%'` (Ana, Argentina) |
| `_` | Un solo carácter. | `LIKE 'L_nd_o'` (London) |
| `[]` | Un carácter en un set. | `LIKE '[AB]%'` (Inicia con A o B) |
| `[^]` | NO en el set. | `LIKE '[^A-F]%'` (No inicia A-F) |

---

## 2. Mapa de Conexiones (Relaciones de la BD)

Utiliza esta tabla para identificar las llaves primarias (PK) y foráneas (FK) al realizar tus `INNER JOIN`.

| Tabla Origen | Columna (FK) | Tabla Destino | Columna (PK) | Relación |
| :--- | :--- | :--- | :--- | :--- |
|   **Oficinas**   | `Jef` |  **Representantes** | `Num_Empl` | jefe referente |
| **Representantes** | `Oficina_Rep` | **Oficinas** | `Oficina` | Ubicación del vendedor. |
| **Representantes** | `Jefe` | **Representantes** | `Num_Empl` | Jerarquía interna. |
| **Clientes** | `Rep_Cli` | **Representantes** | `Num_Empl` | Vendedor asignado. |
| **Pedidos** | `Cliente` | **Clientes** | `Num_Cli` | Cliente que compra. |
| **Pedidos** | `Rep` | **Representantes** | `Num_Empl` | Vendedor del pedido. |
| **Pedidos** | `Fab`, `Producto` | **Productos** | `Id_fab`, `Id_producto` | **¡Llave Compuesta!** |
---


## 🚨 Alertas de Examen: ¡No olvides esto!

1. **La Trampa de la Llave Compuesta:** Al unir `Pedidos` con `Productos`, **siempre** debes usar ambas columnas en el `ON`:
   * `... ON P.Fab = PR.Id_fab AND P.Producto = PR.Id_producto`
2. **WHERE vs HAVING:** * Usa `WHERE` para filtrar filas individuales **antes** de agrupar.
   * Usa `HAVING` para filtrar resultados de funciones (`SUM`, `COUNT`) **después** del `GROUP BY`.
3. **Flujo Lógico:** SQL no lee de arriba a abajo. Primero busca las tablas (`FROM/JOIN`), luego filtra (`WHERE`), luego agrupa (`GROUP BY`) y al final selecciona las columnas (`SELECT`).