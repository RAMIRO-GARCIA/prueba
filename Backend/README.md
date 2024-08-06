# Backend de la App de Ventas y Depósitos de Parquímetros Virtuales

Este es el proyecto backend para una aplicación de Flutter que gestiona ventas y depósitos de parquímetros virtuales. El servidor está desarrollado en Go y está diseñado para interactuar con una base de datos MySQL y AWS S3.

## Configuración del Proyecto

### Requisitos

- Go 1.18 o superior
- MySQL
- AWS S3

### Instalación

1. **Clona el repositorio:**

   git clone <url-del-repositorio>
   
2. **Crea el archivo .env:

Crea un archivo llamado .env en la raíz del proyecto con el siguiente contenido:

DATABASE_URL=root:usuario@tcp(localhost:3306)/dbname
AWS_REGION=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_BUCKET=
UPLOAD_DIR=

3. **Carga las dependencias del proyecto:

Antes de ejecutar el servidor, asegúrate de cargar todas las dependencias necesarias con el siguiente comando:
go mod tidy


4. **Configura la base de datos:

Ejecuta el script SQL llamado "create"que se encuentra en la carpeta para crear las tablas necesarias en tu base de datos.

Nota: En la tabla promotions, asegúrate de crear un valor por defecto para el id 1 que indique que no hay promoción.

5. **Compila el proyecto (opcional):

Puedes compilar el proyecto para obtener un ejecutable:

go build -o nombre_del_programa.exe main.go

Esto generará un archivo ejecutable que puedes ejecutar directamente.

## Ejecución del Servidor
Para ejecutar el servidor, utiliza uno de los siguientes comandos según tu preferencia:

Para ejecutar directamente:
go run main.go  

Si has compilado el proyecto:
./nombre_del_programa.exe

## Consultas a la Base de Datos
Este proyecto realiza consultas a la base de datos kigo_nap para obtener la siguiente información de la tabla naps. Esta base de datos está destinada a sustituir a la base de datos kigo para la tabla naps_name durante el desarrollo:
organizationName
firstName
lastName
nap_id
Asegúrate de ajustar las consultas según el modelo y la base de datos específica utilizada.



