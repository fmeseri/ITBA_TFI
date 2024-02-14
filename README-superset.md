# Instrucciones Superset [🇪🇸]
* Antes de acceder por primera vez a Superset inicializar la base de datos y crear las credenciales del usuario admin corriendo el siguiente comando: 
`./control-env.sh superset-init`
* Acceder a http://localhost:8088/ (utilizar las credenciales creadas en el primer paso).
* Agregar el database (Sources > Databases):
  - Database: `Workshop`
  - SQLAlchemy URI: `postgresql://workshop:w0rkzh0p@postgres/workshop`
  - OK
* Agregar tabla (Sources > Tables) :
  - Database: `workshop`
  - Table Name: `DolarHistorico`

En caso de No contar con el dashboard puede importar el mismo desde el zip -->  ./superset/conf/dashboard_for_Import.zip