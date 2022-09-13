USE Cotizador
GO

/*----------------CREACION DE TABLAS-------------*/

/*Pasos: 
1.- Creacion de las tablas
2.- Antes de ejecutar los querys de los join, se debe poblar la tabla de Repositorio
en el back end hay un servicio que se llama /Catalogos/api/AgregarMarcas esto lo que hace es ir por los registros del servicio de
https://api-test.aarco.com.mx/examen-insumos/ListaDeAutos.txt y los llena en tabla de Repositorio.
3.- Una vez ya ejecutado el servicio de AgregarMarcas se pueden ejecutar los querys de los join
4.- Se pueden probar desde los servicios desde el api
*/


CREATE TABLE Repositorio
(
	IdRepositorio INT IDENTITY(1, 1),
	Marca VARCHAR(500) NOT NULL,
	Submarca VARCHAR(500) NOT NULL,
	Modelo VARCHAR(500) NOT NULL,
	Descripcion VARCHAR(1500) NOT NULL,
	DescripcionId VARCHAR(500) NOT NULL,
	PRIMARY KEY(IdRepositorio)
)

CREATE TABLE Marcas
(
	IdMarca INT IDENTITY(1, 1),
	Marca VARCHAR(500) NOT NULL,
	PRIMARY KEY(IdMarca)
)


CREATE TABLE SubMarcas
(
	IdSubMarca INT IDENTITY(1, 1),
	SubMarca VARCHAR(700) not null,
	IdMarca INT NOT NULL,
	PRIMARY KEY(IdSubMarca)
)

CREATE TABLE Modelos
(
	IdModelo INT IDENTITY(1,1),
	IdSubMarca INT NOT NULL,
	IdMarca INT NOT NULL,
	Modelo INT NOT NULL,
	PRIMARY KEY(IdModelo)
)

CREATE TABLE Descripciones
(
	Descripcion VARCHAR(2500) NOT NULL,
	IdSubMarca INT NOT NULL,
	IdModelo INT NOT NULL,
	DescripcionId VARCHAR(1500) NOT NULL
)

/*---------------------------LLENADO DE TABLAS---------------------------*/

/*Inserccion de datos en tabla Marcas*/
INSERT INTO dbo.Marcas
SELECT DISTINCT(m.Marca) AS Marca FROM dbo.Repositorio  m
ORDER BY m.Marca ASC

/*Inserciuon de datos en SubMarcas*/
INSERT INTO SubMarcas
SELECT DISTINCT(r.Submarca) AS SubMarca, m.IdMarca 
FROM Repositorio r
INNER JOIN 
dbo.Marcas m
ON m.Marca = r.Marca
ORDER BY m.IdMarca ASC

/*Inserciuon de datos en Modelos*/
INSERT INTO Modelos
SELECT DISTINCT(s.IdSubMarca) AS IdSubMarca, S.IdMarca ,r.Modelo
FROM dbo.Repositorio r
INNER JOIN 
dbo.SubMarcas s
ON s.SubMarca = r.Submarca


/*Pruebas de obtencion de modelos*/
SELECT * FROM Modelos WHERE IdMarca = 8 AND IdSubMarca = 105
SELECT * FROM SubMarcas WHERE IdMarca = 8
SELECT * FROM Marcas 

/*---------------Insercion de Descripciones-----------------*/
INSERT INTO Descripciones
SELECT DISTINCT(r.Descripcion), s.IdSubMarca, c.IdModelo, r.DescripcionId 
FROM dbo.Repositorio r
INNER JOIN 
dbo.SubMarcas s
ON
s.SubMarca = r.Submarca
INNER JOIN
dbo.Modelos c
ON
c.Modelo = r.Modelo
WHERE s.IdSubMarca = 144 AND c.IdModelo = 69

--Pruebas de obtencion de descripciones
SELECT * FROM Descripciones d
WHERE d.IdSubMarca = 105 AND d.IdModelo = 2757
