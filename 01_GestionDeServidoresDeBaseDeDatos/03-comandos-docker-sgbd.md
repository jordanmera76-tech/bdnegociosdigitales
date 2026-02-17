#Documentacion de Comandos Docker para SGBD

## cOMANDO PARA CONTENEDOR DE SQL SERVER SIN VOLUMEN

``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```


## Comando para contenedor  de Sql server con volumen

``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -v volume-mssqlevnd:/var/opt/mssql \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```









/var/opt/mssql/data

CREATE DATABASE bdevnd;
GO


USE bdevnd;
GO

CREATE TABLE tbl1(
  id int not null identity(1,1),
  nombre NVARCHAR(20) not null,
  CONSTRAINT pk_tbl1
  PRIMARY KEY (id)
);
GO

INSERT INTO tbl1
VALUES ('DOCKER'),
       ('Git'),
       ('GitHub')
       ('Postgres');
       GO

       SELECT *
       FROM tbl1;