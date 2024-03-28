-- Step 1: Insert data from CSV file without the primary key column
--- POBLACION START---
COPY public.poblacion ("AñoCenso", "CodigoDpto", "Departamento", "Poblacion", "Varones", "Mujeres", "VivPartTot", "VivColectTot", "IndMasc","Superficie","DensPob") 
FROM 'C:/Temp/1991_A~1.CSV' 	
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');


COPY public.poblacion ("AñoCenso", "CodigoDpto", "Departamento", "Poblacion", "Varones", "Mujeres", "VivPartTot", "VivColectTot", "IndMasc","Superficie","DensPob") 
FROM 'C:/Temp/1991_Resto.CSV' 	
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');



COPY public.poblacion ("AñoCenso", "CodigoDpto", "Departamento", "Poblacion", "Varones", "Mujeres", "VivPartTot", "VivColectTot", "IndMasc","Superficie","DensPob") 
FROM 'C:/Temp/2001.CSV' 	
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');


COPY public.poblacion ("AñoCenso", "CodigoDpto", "Departamento", "Poblacion", "Varones", "Mujeres", "VivPartTot", "VivColectTot", "IndMasc","Superficie","DensPob") 
FROM 'C:/Temp/2010.CSV'
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');


COPY public.poblacion ("AñoCenso", "CodigoDpto", "Departamento", "Poblacion", "Varones", "Mujeres", "VivPartTot", "VivColectTot", "IndMasc","Superficie","DensPob") 
FROM 'C:/Temp/2022.CSV'
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');

-- POBLACION END------
---- DICCIONARIO----
COPY public.diccionario ("CodigoDpto", "Departamento") 
FROM 'C:/Temp/DiccionarioPartidosCodigo.CSV'
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');


---	DIMDepto----
COPY public.dimdepto (
"CodigoDpto",
"Departamento",
"PartidoFrom",
"CodigoFrom",
"Sup1991",
"Sup2001",
"IsAMBA",
"Comentarios") 
FROM 'C:/Temp/DIM Departamento.CSV'
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');


---	Proyeccion 2025----
COPY public.proyecciones (
"CodigoDpto",
"ano",
"Departamento",
"Poblacion",
"Varones",
"Mujeres") 
FROM 'C:/Temp/proy_1025.CSV'
WITH (FORMAT csv, HEADER true, DELIMITER ';', QUOTE '"', ESCAPE '''', ENCODING 'UTF8');


