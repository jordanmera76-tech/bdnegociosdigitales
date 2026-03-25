* Que es un sub consulta

Una subconsulta (Subquery) es un Select dentro de otro select, Puede decolver

1. Un solo valor (Escalar)
1. Una lista de valores (Una columna, varias filas)
1. Una tabla (varias columnas y/o varias filas)
1. Segun lo que devuelva, se elige el operador correcto (* IN, EXISTS, etc).

Una subconsulta es una consulta anidadd dentro de otra consulta  que permite resolver problemas en varios
niveles ed informacion 

```
Dependiendo de donde se coloque y que retone camabia su compartiemto
```
5 grandes formas de usarlas:

1. subconsultas escalares 
2. Subconsultas con IN, ANY, ALL
3. Subconsultas correlacionadas
4. Subconsultas en Select
5. Subconsultas en from (Tablas derivadas).


1. Escalar

Devuelven un unico valor, por eso se pueden utilizar con operadores =,>,<.

EJEMPLO:

```sql
SELECT  *
FROM pedidos
WHERE total = (
	SELECT MAX(TOTAL)
FROM pedidos  
)
```

## Subconsultas con IN. ANY, ALL

Devuelve varios valores con una sola columna (in)


```SQL
SELECT *
FROM clientes
WHERE ciudad = 'Monterrey'
AND id_cliente IN (
	SELECT id_cliente
FROM pedidos
)

SELECT *
FROM pedidos
WHERE id_cliente IN (
		SELECT id_cliente
		FROM clientes
		where ciudad = 'Monterrey'
)

SELECT  *
FROM clientes 
where id_cliente not in (
	SELECT id_cliente
	FROM pedidos 
)

SELECT *
FROM clientes
WHERE ciudad = 'CDMX'
AND id_cliente IN (
	SELECT id_cliente
FROM pedidos
)

SELECT *
FROM pedidos
where id_cliente IN (
	SELECT  id_cliente
FROM pedidos
where total > 800
)

SELECT * 
FROM clientes 
WHERE id_cliente IN (
	SELECT id_cliente 
	FROM pedidos
);
```

## Clasula ANY


>Compara un valor contra una lista 
>la condicion se cumple si se cumple con al menos 1

```sql
valor > ANY (Subconsulta)
```
>Es como decir mayor que al menosde uno de los valores 

- Selecionar a pedidos mayores que algun pdido de luis (id_clientes=2)


```sql
--Operador ANY
-- Selecionar a pedidos mayores que algun pdido de luis (id_clientes=2)

--primero la subconsulta

SELECT total
FROM pedidos
WHERE id_cliente = 2

--CONSULTA PRINCIPAL
SELECT *
FROM pedidos
where total  > ANY (
	SELECT total
FROM pedidos
WHERE id_cliente = 2
)


--seleccionar los pedidos mayores (total) de algun pedido de Ana
SELECT total 
FROM pedidos
WHERE id_cliente = 1

SELECT *
FROM pedidos 
WHERE total> ANY (SELECT total
FROM pedidos 
WHERE  id_cliente =1)



SELECT total
FROM clientes 
WHERE id_cliente =1


SELECT*
FROM pedidos 
WHERE total > ANY (
SELECT total
FROM pedidos 
WHERE id_cliente =1
);

--seleccionar los pedidos mayores algun pedido superior (total) a 500

SELECT total
FROM pedidos
WHERE total > 500

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
FROM pedidos
WHERE total > 500
)
```

## CLASULA ALL

se cumple contra todos los valores

```sql
--valor > ALL (subconsulta)
```

Significa:

- Mayor que todos los valores

```sql
--all

--Selecionar los pedidos deonde el total sea mayor a todos los totales de los pedidos de luis 

use bdsubconsultas

SELECT total
FROM pedidos
where id_cliente = 2

SELECT total
from pedidos

SELECT *
FROM pedidos
where total > ALL(
	SELECT total
FROM pedidos
where id_cliente = 2
)

--Selecionar Todos los clientes donde su ID sea menor que todos los clientes de la ciudad de Mexico

SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX'

SELECT id_cliente
FROM clientes
where id_cliente < all(
	SELECT id_cliente
	FROM clientes
	WHERE ciudad = 'CDMX'
)
```
## Subconsultas correlacionadas

>Un sunconsulta correlacionada depende de la fila actual de la consulta principal y se ejecuta una vez por cada fila 

---

1. Selecionar los clientes cuyo total de compras sea mayor a 1000