# Integración de proyectos
La integración de nuevos proyectos se define en el archivo users.tfvars. En el cual se define el contenido de la variable `mlops-users` de la siguiete manera:

* Identificación de usuario: Puede tomar cualquier valor, pero es recomendable usar la identificación de AWS.
* Repositorio: ruta del repositorio de github siguiendo la estructura `<Usuario/Organización>/<Nombre del Repositorio>`.
* Identificación deñ proyecto: Nombre que identifica al proyecto de manera única.
Los caracteres en minúscula, números y el simbolo '-' son válidos para el nombre, pero cualquier otro caracter hará que terraform falle al integrar el proyecto a la infraestructura.
El nombre puede ser cualquiera, pero se recomienda seguir la siguiente estructura: `<Usuario>-<Libreria ML>-<Nombre del repositorio>`.

Ejemplo del archivo users.tfvars:

```
# users.tfvars
mlops-users = {
    "User1" = {
        "repo" = "example/repository"
        "project_id" = "example-project-repository"
    },
    "User2" = {
    ...
}
```

Para guardar el archivo users.tfvars. Ejecute el commando `./scripts/backup_users.sh` desde el direcotrio raíz del repositorio o suba de forma manual el archivo `users.tfvars` a la Bucket S3 definida para el backend de terraform.
Finalmente, ejecute el workflow **Deploy and Update Infraestructure** para hacer efectivos sus cambios.