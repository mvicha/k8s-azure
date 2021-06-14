# UNIR Caso Pr&aacute;ctico
Este c&aacute;so pr&aacute;ctico est&aacute; dise&ntilde;ado para funcionar con Terraform-Ansible-Azure. Desplegar&aacute; un ambiente Kubernetes conformado por:
  * 1 Master
  * 2 Workers

Entre los nodos se cuenta con un servidor de NFS para poder compartir archivos. Como no fue posible desplegar un servidor independiente para proveer la soluci&oacute;n de NFS, se opt&oacute; por incluirlo en el Nodo01.

## La soluci&oacute;n funciona de la siguiente manera:
  - Primero se despliega el entorno utilizando Terraform. Hay algunas variables que se pueden modificar para desplegar un entorno personalizable, aunque algunas de ellas se recomienda no modificarlas:
    * admin_user:

      Esta variable permite seleccionar el nombre de usuario que utilizaremos para iniciar sesi&oacute;n ssh en los servidores

    * virtual_network_cidr:

      Esta variable define el CIDR de nuestra red virtual. Se recomienda no cambiarla

    * subnet_cidr_private:

      Esta variable define el CIDR de nuestra red privada. Se recomienda no cambiarla

    * private_lan_master:

      Esta variable define la IP que utilizar&aacute; el nodo master en la red privada

    * private_lan_node01:

      Esta variable define la IP que utilizar&aacute; el nodo node01 en la red privada

    * private_lan_node02:

      Esta variable define la IP que utilizar&aacute; el nodo node02 en la red privada

    * mysql_ghost_database:

      Esta variable define el nombre de la DB que se utilizar&aacute; con la aplicaci&oacute;n de blog

    * mysql_ghost_username:

      Esta variable define el nombre de usuario que se utilizar&aacute; para conectar la la DB del blog

  - Todo el resto de las configuraciones de Ansible se manejan autom&aacute;ticamente en base a los par&aacute;metros que Terraform env&iacute;a luego de desplegar la infraestructura.

### Terraform despliega:
  - 1 Nodo master de 2 vCPUs y 4Gb de RAM
  - 2 Nodos worker de 1 vCPU y 2Gb de RAM
  - 1 Red virtual
  - 1 Subred
  - 3 Interfaces de red
  - 1 Direcci&oacute;n IP p&uacute;blica
  - 1 HD SSD de 10 Gb para utilizar como NFS y para guardar los datos de la DB MySQL
  - Azure Key Vault para guardar informaci&oacute;n sensible como contrase&ntilde;as. (Las contrase&ntilde;as de MySQL y de Ghost son generadas aleatoriamente y guardadas en Azure Key Vault. Este valor es luego obtenido cuando Ansible se ejecuta, por lo que no hace falta definir ning&uacute;n valor en el c&oacute;digo para que los servicios funcionen)
  - Azure Identity para permitir que el nodo master pueda acceder a los Azure Key Vault Secrets
  - 1 Zona de DNS privada
  - 3 Entradas de DNS para los Nodos

### Ansible realiza:
  - Instalaci&oacute;n de paquetes b&aacute;sicos de funcionamiento
  - Formatea HD SSD en xfs y crea sistema de archivos LVM para NFS
  - Instalaci&oacute;n y configuraci&oacute;n de NFS en Nodo01
  - Herramientas para realizar el deployment (Helm, Python modules, etc.)
  - Instalaci&oacute;n de Docker en todos los Nodos
  - Instalaci&oacute;n de Kubelet, Kubeadm y Kubectl en todos los nodos
  - Configuraci&oacute;n de bash completion para Kubectl en todos los nodos
  - Setup de permisos para utilizar Kubectl desde todos los nodos
  - Inicializaci&oacute;n de kubernetes
  - Setup de CNI
  - Uni&oacute;n de los nodos al servidor master de Kubernetes
  - Despliegue de Ingress Controller
  - Setup de MySQL
  - Setup de Ghost

## Modo de empleo
  - Clonamos repositorio
  ```bash
  git clone git@github.com:mvicha/k8s-azure
  ```

  - Create local directory where to hold variables
  ```bash
  mkdir -p k8s-azure/.azure k8s-azure/.kube k8s-azure/.ssh
  ```

  - Ejecuci&oacute;n de docker_env
  ```bash
  docker container run --name casopractico2 -it -v ${PWD}/k8s-azure/.azure:/root/.azure -v ${PWD}/k8s-azure/.kube:/root/.kube -v ${PWD}/k8s-azure/.ssh:/root/.ssh -v ${PWD}/k8s-azure:/SAFE_VOLUME mvilla/casopractico2:latest /bin/bash
  ```

  - Cambiar de directorio dentro del entorno de docker a nuestro espacio de trabajo
  ```bash
  cd /SAFE_VOLUME/terraform
  ```

  - Iniciar sesi&oacute;n en Azure
  ```
  az login
  ```

  - Inicializar Terraform y aplicar los cambios
  ```bash
  terraform init
  terraform plan -out plan.out
  terraform apply plan.out
  ```

  - Abrir un navegador de internet a la direcci&oacute;n http://<master_public_address>

### Resultados de la ejecuci&oacute;n
```
master_private_address = "192.168.1.100"
master_public_address = "52.146.71.212"
node01_private_address = "192.168.1.101"
node02_private_address = "192.168.1.102"
ssh_admin_user = "azureuser"
ssh_master_connection = "ssh -i resources/external.pem azureuser@52.146.71.212"
ssh_node01_connection = "ssh -i resources/internal.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i resources/external.pem -W %h:%p -q azureuser@52.146.71.212' azureuser@192.168.1.101"
ssh_node02_connection = "ssh -i resources/internal.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i resources/external.pem -W %h:%p -q azureuser@52.146.71.212' azureuser@192.168.1.102"
subnet_cidr_private = tolist([
  "192.168.1.0/24",
])
virtual_network_cidr = tolist([
  "192.168.0.0/16",
])
```

* Si por alg&uacute;n motivo quisi&eacute;ramos ejecutar Ansible de forma manual, s&oacute;lo debemos realizar los siguientes pasos:
  - Desde el mismo directorio de trabajo local ejecutamos la l&iacute;nea siguiente reemplazando <master_public_ip_address> por el valor obtenido en la salida de terraform output:
  ```bash
  ansible-playbook -i ../ansible/hosts -e jump_host=<master_public_address> -e admin_user=azureuser -e subnet_cidr_private=192.168.1.0/24 -e private_lan_master=192.168.1.100 -e private_lan_node01=192.168.1.101 -e private_lan_node02=192.168.1.102 ../ansible/playbook.yml
  ```

