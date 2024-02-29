----- DATA QUERIES-------------------------
WITH amba AS (
Select geod.gid,ROUND((ST_Area(geod.geom)*(111.32 * 111.32))::numeric,2) AS sup,geod.nam,geod.in1 as cod_depto, d."IsAMBA"
FROM geo.departamento geod, public.dimdepto as d
WHERE CAST (geod.in1 AS INTEGER) = CAST(d."CodigoDpto" AS INTEGER) AND d."IsAMBA"=true ) 

Select am.nam,am.cod_depto , p."AñoCenso" as anio,p."Poblacion" as pob,p."Varones" as var,
p."Mujeres" as muj,p."VivPartTot" vivpart,p."VivColectTot"as vivtotal,p."Superficie",am.sup, 
ROUND((100.0 * p."Varones" / p."Mujeres")::numeric, 1) AS ind_masc,
ROUND((p."Poblacion" / am.sup)::numeric, 2) AS dens_pob
From  amba am , poblacion p
Where CAST(am.cod_depto AS INTEGER) = CAST(p."CodigoDpto" AS INTEGER);



-----GEO QUERIES--------------------------
	WITH ambaGeom AS (
	Select geod.gid,geod.geom,ROUND((ST_Area(geod.geom)*(111.32 * 111.32))::numeric,2) AS sup,geod.nam,geod.in1 as cod_depto
	FROM geo.departamento geod, public.dimdepto as d
	WHERE geod.in1 :: INTEGER = CAST(d."CodigoDpto" AS INTEGER) AND d."IsAMBA"=true)

	
	-- Enrich with censos
	UPDATE geo."vAMBOgeom" AS am
	SET censo1991 = c.pob
    FROM public.v_censos_amba AS c
	WHERE am.cod_depto = c.cod_depto and anio='1991';

	
	----- Select geo.amba_pob
	select gid,sup,nam,cod_depto,pob1991,pob2001,pob2010,pob2022,
	dens1991,dens2001,dens2010,dens2022
	FROM  geo.amba_pob
	
	------ From View----
	Select * FROM geo."vAMBOgeom"
	
------------------------

/* FORMAT etiquetas QGIS
 concat( "nam" ,'\n' ,' Pob:', format_number( "pob2022",0,en), '\n' ,'Dens:',format_number("dens2022",1,en))
 */
