-- Crea una Base de Datos
CREATE DATABASE tienda;
GO

use tienda;

-- Crear tabla cliente
CREATE TABLE cliente (
    id int not null,
    nombre nvarchar(30) not null,
    apaterno nvarchar(10) not null,
    amaterno nvarchar(10) null,
    sexo nchar(1) not null,
    edad int not null,
    direccion nvarchar(80) not null,
    rfc nvarchar(20) not null,
    limitecredito money not null default 500.0
);
GO

-- Restricciones

CREATE TABLE clientes(
   cliente_id INT NOT NULL PRIMARY KEY,
   nombre nvarchar(30) NOT NULL,
   apellido_paterno nvarchar(20) NOT NULL,
   apellido_materno nvarchar (20),
   edad INT NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   limite_credito MONEY NOT NULL
);
GO

INSERT INTO clientes
VALUES (1, 'GOKU', 'LINTERNA', 'SUPERMAN', 450, '1578-01-17', 100);

INSERT INTO clientes
VALUES (2, 'PANCRACIO', 'RIVERO', 'PATROCLO', 20, '2005-01-17', 10000)

INSERT INTO clientes
VALUES (2, 'PANCRACIO', 'RIVERO', 'PATROCLO', 20, '2005-01-17', 10000)

INSERT INTO clientes
(nombre, cliente_id, limite_credito, fecha_nacimiento, apellido_paterno, edad)
VALUES ('Arcadia', 3, 45800, '2000-01-22', 'Ramirez', 26)

INSERT INTO clientes
VALUES (4, 'Vanesa', 'Buena Vista', NULL, 26, '2000-04-25', 3000);
GO

INSERT INTO clientes
VALUES
(5, 'Soyla', 'Vaca', 'Del Corral', 42, '1983-04-06', 78955),
(6, 'Bad Bunny', 'Perez', 'Sinsentido', 22,'1999-05-06', 85858),
(7, 'Jos  Luis', 'Herrera', 'Gallardo', 42,'1983-04-06', 14000);



SELECT *
FROM clientes;

SELECT cliente_id, nombre, edad, limite_credito
FROM clientes;


SELECT GETDATE(); -- obtine la fecha del sistema

CREATE TABLE clientes_2(
  cliente_id int not null identity(1,1),
  nombre nvarchar(50) not null,
  edad int not null,
  fecha_registro date default GETDATE(),
  limite_credito money not null,
  CONSTRAINT pk_clientes_2
  PRIMARY KEY (cliente_id)
);

SELECT *
FROM clientes_2;

INSERT INTO clientes_2
VALUES ('Chesperito', 89,DEFAULT, 45500)


INSERT INTO clientes_2 (nombre, edad, limite_credito)
VALUES ('Batman', 45, 89000)

INSERT INTO clientes_2 
VALUES ('Robin', 35,'2026-01-19', 89.32);


INSERT INTO clientes_2 (limite_credito, edad, nombre, fecha_registro)
VALUES (12.33, 24,'Flash Reverso', '2026-01-21');

CREATE TABLE suppliers (
  supplier_id int not null identity(1,1),
  [name] nvarchar(30) not null,
  date_register date not null DEFAULT GETDATE(),
  tipo char(1) not null,
  credit_limit MONEY not null,
  CONSTRAINT pk_supplers
  PRIMARY KEY ( supplier_id ),
  CONSTRAINT unique_name
  UNIQUE ([name]),
  CONSTRAINT chk_credit_limit
  CHECK (credit_limit > 0.0 and credit_limit <= 50000),
  CONSTRAINT chk_tipo
  CHECK (tipo IN ('A', 'B', 'C'))
);

SELECT *
FROM suppliers;

INSERT INTO suppliers
VALUES (UPPER('bimbo'), DEFAULT, UPPER('c'), 45000);

INSERT INTO suppliers
VALUES (UPPER('tia rosa'), '2026-01-21', UPPER('a'), 49999.99);


INSERT INTO suppliers (name, tipo, credit_limit)
VALUES (UPPER('tia mensa'), UPPER('a'), 49999.99);




-- Crear base de datos dbordes

CREATE DATABASE dborders;
GO

USE dborders;
GO

--CREAR tabla

CREATE TABLE customers (
  customers_id INT NOT NULL IDENTITY (1, 1),
  first_name NVARCHAR (20) not null,
  last_name NVARCHAR (30),
  [address] NVARCHAR (80) NOT NULL,
  number int,
  CONSTRAINT pk_customers
  PRIMARY KEY (customers_id)
);


CREATE TABLE suppliers (
  supplier_id int not null,
  [name] nvarchar(30) not null,
  date_register date not null DEFAULT GETDATE(),
  tipo char(1) not null,
  credit_limit MONEY not null,
  CONSTRAINT pk_supplers
  PRIMARY KEY ( supplier_id ),
  CONSTRAINT unique_name
  UNIQUE ([name]),
  CONSTRAINT chk_credit_limit
  CHECK (credit_limit > 0.0 and credit_limit <= 50000),
  CONSTRAINT chk_tipo
  CHECK (tipo IN ('A', 'B', 'C'))
);
GO


drop table products
drop table suppliers

-------------------------------------------------------------------------------------SET NULL-------------------------------------------------------------------
DROP TABLE products

CREATE TABLE products (
   product_id INT NOT NULL IDENTITY (1,1),
   [name] NVARCHAR (40) NOT NULL,
   quantity int NOT NULL,
   unit_price MONEY NOT NULL,
   supplier_id INT ,
   CONSTRAINT pk_products
   PRIMARY KEY (product_id),
   CONSTRAINT unique_name_products
   UNIQUE ([name]),
   CONSTRAINT chk_quantity
   CHECK (quantity between 1 and 100),
   CONSTRAINT chk_unitprice
   CHECK ( unit_price > 0 and unit_price <= 10000),
   CONSTRAINT fk_products_suppliers
   FOREIGN KEY (supplier_id)
   REFERENCES suppliers (supplier_id)
   ON DELETE SET NULL
   ON UPDATE SET NULL
);
GO

ALTER TABLE products
DROP CONSTRAINT fk_products_suppliers;

DROP TABLE suppliers;

--PERMITE EJECUTAR UNA COLUMNA EN LA TABLA
ALTER TABLE products
ALTER COLUMN supplier_id INT NULL;


UPDATE products
SET supplier_id = NULL;



---DROP TABLE products;

INSERT INTO suppliers
VALUES (1,UPPER('Cchino s.a.'), DEFAULT, UPPER('c'), 45000);

INSERT INTO suppliers
VALUES (2,UPPER('chanclosas'), '2026-01-21', UPPER('a'), 49999.99);


INSERT INTO suppliers (supplier_id, [name], tipo, credit_limit)
VALUES (3,UPPER('rama-ma'), UPPER('a'), 49999.99);

SELECT *
FROM suppliers


INSERT INTO products
VALUES ('Papas', 10,5.3, 1);

INSERT INTO products
VALUES ('Rollos Primaveras', 20, 100, 1);

INSERT INTO products
VALUES ('Chanclas patas de gallo', 50, 20, 2);

INSERT INTO products
VALUES ('Chanclas buenas', 30, 56.7, 2),
       ('Ramita chiquitas', 56, 78.23, 3);


INSERT INTO products
VALUES ('Azulito', 100, 15.30, NULL);


--comprobacion de on delate on action
UPDATE suppliers
SET supplier_id = 10
WHERE supplier_id =2;



-- Eliminar la tabla padre
DELETE FROM suppliers
WHERE supplier_id = 1;

--Primero eliminar los hijos
DELETE FROM products
WHERE supplier_id = 1;


--Comprobar el update no actions




SELECT *
FROM products;

SELECT *
FROM suppliers;



DELETE FROM products
WHERE supplier_id = 1;


--esto ayuda a cambiar el codigo para poder 
update products
set supplier_id = 2
where product_id IN (5,6);

update products
set supplier_id = 2
where product_id = 5 
or product_id = 6;


update products
set supplier_id = 3
where product_id IN (7);

UPDATE suppliers
set supplier_id = 10
where supplier_id =2;


UPDATE products
set supplier_id = 20
where supplier_id is null;

UPDATE products
set supplier_id = null
where supplier_id = 2;

UPDATE products
set supplier_id = 10
where product_id IN (3,4);




-------------------------------------------------------------------------------------SET NULL-------------------------------------------------------------------
DROP TABLE products

CREATE TABLE products (
   product_id INT NOT NULL IDENTITY (1,1),
   [name] NVARCHAR (40) NOT NULL,
   quantity int NOT NULL,
   unit_price MONEY NOT NULL,
   supplier_id INT ,
   CONSTRAINT pk_products
   PRIMARY KEY (product_id),
   CONSTRAINT unique_name_products
   UNIQUE ([name]),
   CONSTRAINT chk_quantity
   CHECK (quantity between 1 and 100),
   CONSTRAINT chk_unitprice
   CHECK ( unit_price > 0 and unit_price <= 10000),
   CONSTRAINT fk_products_suppliers
   FOREIGN KEY (supplier_id)
   REFERENCES suppliers (supplier_id)
   ON DELETE SET NULL
   ON UPDATE SET NULL
);
GO


INSERT INTO products
VALUES ('Papas', 10,5.3, 1);

INSERT INTO products
VALUES ('Rollos Primaveras', 20, 100, 1);

INSERT INTO products
VALUES ('Chanclas patas de gallo', 50, 20, 10);

INSERT INTO products
VALUES ('Chanclas buenas', 30, 56.7, 10),
       ('Ramita chiquitas', 56, 78.23, 3);


INSERT INTO products
VALUES ('Azulito', 100, 15.30, NULL);


--------Comprobar on delete det null

Delete suppliers
where supplier_id = 10

SELECT *
FROM products;

SELECT *
FROM suppliers;

--comprobar on update set null
UPDATE suppliers
set supplier_id = 20
where supplier_id = 1;