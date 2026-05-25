# Posibles mejoras y sugerencias

- [ ] Usar una VPN de uso para la universidad. De este modo la infraestructura se encontrará menos expuesta. Se puede contratar un servicio o también posible implementar una en una instancia de EC2.
- [ ] Considerar el uso de ECS en lugar de instancias EC2. Ya que se usan imagenes docker tanto para el servidor de despliegue como para los entrenamientos y que MLFlow provee una imagen Docker e intrucciones de despliegue en el servicio de ECS, puede ser una opción interesante a considerar al eliminar la necesidad de manejar instancias EC2 manualmente. 
Pero como desventaja puede resultar en una configuración de terraform más compleja y en mayores costos a requerir del servicio de Amazon Elastic Load Balancer (ELB) para exponer los contenedores a la red.
- [ ] Agregar autenticación e implementar workspaces en MLFlow.