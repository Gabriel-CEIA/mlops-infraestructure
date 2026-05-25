# Levantamiento de la infraestructura

### Backend S3 de Terraform
Para que Terraform pueda actualizar y mantener un historial de los cambios realizados en la infraestructura de nube, es necesario crear un bucket S3. Esta bucket además será usada para guardar el archivo terraform.tfvars que contiene el registro de los proyectos integrados a la infraestructura, además de otras configuraciones de la infraestructura.

1. En la barra de búsqueda del portal web de AWS buscar S3 e ingresar a la opción.
2. ​Presionar el botón de Create bucket.
3. En el Bucket Type seleccionar General Purpose.
4. En el campo de Bucket Name ingrese un nombre a su elección. Este nombre será usado posteriormente en este manual.
5. En la opción Bucket Versioning seleccionar Enable.
6. Presionar el botón de Create Bucket.

### Variables de Terraform
Puede usar un archivo terraform.tfvars para definir las siguietes variables:

+ **vpc_cidr:** Bloque CIDR a usar para la VPC. El valor por defecto es "10.10.0.0/16"
+ **allowed_cidr_source:** Bloque CIRD usado para determinar las direcciones IP que pueden acceder a los servidores de MLOps y de despliegue. El valor por defecto es "0.0.0.0/0"
+ **mlflow_db_user:** Nombre del usuario de la base de datos de MLFlow. El valor por defecto es "mlflow".
+ **mlflow_db_passwd:** Nombre del usuario de la base de datos de MLFlow. El valor por defecto es "password".

Para guardar el archivo users.tfvars. Ejecute el commando `./scripts/backup_config.sh` desde el direcotrio raíz del repositorio o suba de forma manual el archivo `terraform.tfvars` a la Bucket S3 definida para el backend de terraform.
Finalmente, ejecute el workflow **Deploy and Update Infraestructure** para hacer efectivos sus cambios.

### Secretos de Github
Para poder ejecutar los workflows se necesita definir los siguientes secretos en el repositorio de Github.

+ **AWS_REGION**: Region de AWS donde se desplegarán los recursos.
+ **AWS_SECRET_ACCESS_KEY**: Llave de acceso a la cuenta de AWS.
+ **AWS_ACCESS_KEY_ID**: Identificación de la llave de acceso.
+ **S3_TERRAFORM_BACKEND_BUCKET**: Nombre del Bucket S3 creado previamente.

### Workflows
En la pestaña de Actions verá los workflows definidos para manejar la infraestructura.

+ **Deploy Bare Infraestrucutre:** Este workflow genera la infraestructura inicial en AWS sin usuarios/proyectos integrados y sin el servidor de despliegue. Ejecute este workflow para levantar por primera vez la infraestructura.

+ **Build and Deploy Server Image:** Este workflow crea la imagen Docker del servidor de despliegue definido en la carpeta server. Ejecute este workflow después de levantar la infraestructura por primera vez y cuando actualice el código del servidor.

+ **Deploy and Update Infrestructure:** Este workflow actualiza la infraestructura e integra a los usuarios de la misma. Ejecute este workflow siempre que quiera realizar cambios a los archivo de terraform y al actualizar el archivo terraform.tfvars. <br>
Vea el documento de [integración de usuarios](INTEGRATION.md) para más detalles.

+ **Destroy Infraestrucutre:** Este workflow destruye las infraestructura levantada en AWS. 

