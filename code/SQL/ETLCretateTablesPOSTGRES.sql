--##POBLACION
CREATE TABLE IF NOT EXISTS public.poblacion (
    Id SERIAL PRIMARY KEY,
    "AñoCenso" VARCHAR(50),
    "CodigoDpto" VARCHAR(50),
    "Departamento" VARCHAR(150),
    "Poblacion" INT,
    "Varones" INT,
    "Mujeres" INT,
    "VivPartTot" INT,
    "VivColectTot" INT,
    "IndMasc" FLOAT,
	"Superficie" INT,
	"DensPob" FLOAT 
);

TRUNCATE TABLE public.poblacion;

--## DIM Departamento
CREATE TABLE IF NOT EXISTS public.DimDepto (
    Id SERIAL PRIMARY KEY,
    "CodigoDpto" VARCHAR(50),
    "Departamento" VARCHAR(150),
    "PartidoFrom" VARCHAR(150),
    "CodigoFrom" VARCHAR(50),
    "Sup1991" INT,
    "Sup2001" INT,
	"IsAMBA" BOOLEAN,
    "Comentarios" VARCHAR(550)

);

TRUNCATE TABLE public.DimDepto;

--##DICCIONARIO DATOS PARTIDO CODIGO
CREATE TABLE IF NOT EXISTS public.diccionario (
    "CodigoDpto" VARCHAR(50),
    "Departamento" VARCHAR(150)
);

TRUNCATE TABLE public.diccionario;

--##PROYECCIONES
CREATE TABLE IF NOT EXISTS public.proyecciones (
    Id SERIAL PRIMARY KEY,
    "CodigoDpto" VARCHAR(50),
    "ano" INT,
    "Departamento" VARCHAR(150),
    "Poblacion" INT,
    "Varones" INT,
    "Mujeres" INT
);

TRUNCATE TABLE public.proyecciones;


----- GEOMETRY TABLES---
--1) departamento created from POSTGIS
--2)amba+censos


---Now weed need to alter to add  COlumns  para data de los censos

CREATE TABLE  IF NOT EXISTS geo.amba_pob AS
SELECT *
FROM geo."vAMBOgeom"
ALTER TABLE geo.amba_pob 
ADD COLUMN pob1991 INT,
ADD COLUMN pob2001 INT,
ADD COLUMN pob2010 INT,
ADD COLUMN pob2022 INT;
/* hay que hacerlo en un SProcedure-- no crear la columna si existe 
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'your_table' 
        AND column_name = 'new_column'
    ) THEN
        ALTER TABLE your_table
        ADD COLUMN new_column datatype;
    END IF;
END $$;
*/
ALTER TABLE geo.amba_pob 
ADD COLUMN dens1991 INT,
ADD COLUMN dens2001 INT,
ADD COLUMN dens2010 INT,
ADD COLUMN dens2022 INT;

UPDATE geo.amba_pob AS am
SET pob1991 = c.pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='1991';
--- Update Poblacion de los censos
UPDATE geo.amba_pob AS am
SET pob2001 = c.pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='2001';

UPDATE geo.amba_pob AS am
SET pob2010 = c.pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='2010';
UPDATE geo.amba_pob AS am
SET pob2022 = c.pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='2022';

--- Update DENSIDAD de los censos
UPDATE geo.amba_pob AS am
SET dens1991 = c.dens_pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='1991';
UPDATE geo.amba_pob AS am
SET dens2001 = c.dens_pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='2001';

UPDATE geo.amba_pob AS am
SET dens2010 = c.dens_pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='2010';
UPDATE geo.amba_pob AS am
SET dens2022 = c.dens_pob
FROM  public.v_censos_amba c
WHERE am.cod_depto = c.cod_depto AND anio='2022';


---
