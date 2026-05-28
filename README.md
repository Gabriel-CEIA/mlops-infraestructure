# Proyecto de infraestructura en la nube (Iac) MLOPS para la Universidad del Valle de Guatemala
Este repositorio define una IaC en AWS con enfoques MLOps destinada a la investigación y desarrollo de modelos de Inteligencia Artificial y Machine Learning. Destinada a los investigadores del Centro de Estudios en Informática Aplicada (CEIA).

## Estructura y componentes
A continuación se describe la estructura del proyecto y como estan organizados los archivos. Para una descripción detetallada del diseño de la infraestructura, vea la [documentación de la arquitectura](./docs/ARQUITECTURA.md).

### Archivos de terraform:
+ **backend.tf**: Define el backend donde se guardará el estado de la infraestructura y otras configuraciones esenciales.
+ **cloudwatch.tf**: Define el monitoreo de los recursos de AWS.
+ **ec2.tf**: Define los servidores de despliegue y MLFlow como instancias de EC2.
+ **ecr.tf**: Define los repositorios para imagenes de Docker.
+ **iam_docs.tf**: Define las documentos usados por las politicas y roles.
+ **iam.tf**: Define los perfiles, politicas y roles necesarios para la infraestructura.
+ **lambda.tf**: Define las funciones lambda que crearan nuevas instancias de entrenamiento.
+ **network.tf**: Define los componentes y caracteristicas para la red de la infraestrucutra.
+ **outputs.tf**: Despliega las direcciones IP de los servidores de despliegue y MLFlow, funciones lambda necesarias para la creacion de intancias de entrenamiento y el nombre de los roles de Github Actions que seran usados por los investigadores. Vease la documentación de [integración de proyectos](./docs/INTEGRATION.md).
+ **rds.tf**: Define la base de datos usada por MLFlow.
+ **security.tf**: Define los Security Groups establecen la comunicación interna y externa de los recursos de AWS.
+ **sqs.tf**: Define el servicio SQS usado para sincronizar el servidor de desplique con la Bucket S3 de almacenamiento de modelos.
+ **storage.tf**: Define las Buckets S3 usadas por la infraestructura.
+ **terraform.tf**: Define el proveedor de terraform a usar (AWS).
+ **variables.tf**: Define variables usadas en el resto de archivos de terraform.

### Directorios:

+ **.github/workflows/**: Aquí se encuentran los workflows de Github Actions que desplegarán la infraestructura. Vea la documentación del [flujo de trabajo](./docs/WORKFLOW.md).
+ **docs/**: Aquí se encuentra documentación adicional de la infraestructura.
+ **lambda/**: Contiene el código de las funciones lambda de la infraestructura.
+ **scripts/**: Aquí se encuentran scripts de ayuda y scripts usados por la infraestructura.
+ **server/**: Contiene el código del servidor de despliegue.

## Documentación:

+ **[ARQUITECTURE.md](./docs/ARQUITECTURE.md):** Explica la architectura de la plataforma y como los servicios se conectan entre sí de forma general.
+ **[INTEGRATION.md](./docs/INTEGRATION.md):** Explica como integrar nuevos proyectos a la infraestructura.
+ **[SETUP.md](./docs/SETUP.md):** Explica como levantar la infraestructura y el uso de los workflows.
 



