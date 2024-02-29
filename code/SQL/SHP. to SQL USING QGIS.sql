--- Impotar .shp to SQL using shell OSW4 GEO GIS del paquete QGIS   
ogr2ogr -overwrite -f MSSQLSpatila "MSSQL:server=DESKTOP-MVUBOR1;database=TFI_MESERI;trusted_connection=yes" "C:\Users\Fer\Dropbox\00.ITBA Esp.Cs.DATOS\12.Taller de trabajo FINAL\0.Datasets\GEogRAfIcos\departamentoSHP\departamento.shp"
