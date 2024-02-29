---############## CREATE TABLE SCRIPTS########################
---## ETL PARA creacion de las tablas y truncado de las mismas si ya existen

--##POBLACION
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[censo].[Poblacion]'))
BEGIN
    CREATE TABLE censo. Poblacion (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        AñoCenso VARCHAR(50),
        CodigoDpto VARCHAR(50),
        Departamento NVARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
        Poblacion INT,
        Varones INT,
        Mujeres INT,
        VivPartTot INT,
        VivColectTot INT,
        IndMasc FLOAT
    );
END;

Truncate Table [censo].[Poblacion]


--## DIM Departamento
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[censo].[Departamento]'))
BEGIN
    CREATE TABLE censo.Departamento (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CodigoDpto VARCHAR(50),
        Departamento NVARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
        PartidoFrom	NVARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
		CodigoFrom VARCHAR(50),
		Sup1991 INT,
		Sup2001 INT,
		Comentarios NVARCHAR(550) COLLATE SQL_Latin1_General_CP1_CI_AS


    );
END;
Truncate Table [censo].[Departamento]


--##DICCIONARIO DATOS PARTIDO CODIGO
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[censo].[Diccionario]'))
BEGIN
    CREATE TABLE censo.Diccionario (
      
		CodigoDpto VARCHAR(50),
        Departamento NVARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
         );
END;

Truncate Table [censo].[Diccionario]

--##PROYECCIONES
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[censo].[Proyecciones]'))
BEGIN
    CREATE TABLE censo.Proyecciones (
      
		 Id INT IDENTITY(1,1) PRIMARY KEY,
        CodigoDpto VARCHAR(50),
		ano INT,
        Departamento NVARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
        Poblacion INT,
        Varones INT,
        Mujeres INT
		);
END;

Truncate Table [censo].[Proyecciones]


--##DEPARMENTO GEOGRAFICO
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[geo].[Departamento]'))
BEGIN
    CREATE TABLE geo.Departamento (
      --gid,objeto,geom,fna,gna,nam,in1,fdc,sag
		 Id INT IDENTITY(1,1) PRIMARY KEY,
		 gid  INT,
        geom GEOMETRY,
		objeto NVARCHAR(150),
		fna NVARCHAR(150),
        gna NVARCHAR(150),
        nam NVARCHAR(150),
		in1 NVARCHAR(150),
		fdc NVARCHAR(150),
		sag NVARCHAR(150),
		);
END;

Truncate Table [geo].[Departamento]


---- INSERT STATEMENT FOR GEOMETRY
/*INSERT INTO Polygons (PolygonID, PolygonName, GeoPolygon)
VALUES (
    1,
    'Example Polygon',
    geometry::STGeomFromText('POLYGON((-20037508.34 -20037508.34, 20037508.34 -20037508.34, 20037508.34 20037508.34, -20037508.34 20037508.34, -20037508.34 -20037508.34))', 3857)
);
*/