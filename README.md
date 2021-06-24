# UNIR Caso Pr&aacute;ctico
Este c&aacute;so pr&aacute;ctico est&aacute; dise&ntilde;ado para funcionar con Terraform-Ansible-Azure. Desplegar&aacute; un ambiente Kubernetes conformado por:
  * 1 Master
  * 2 Workers

Entre los nodos se cuenta con un servidor de NFS para poder compartir archivos. Como no fue posible desplegar un servidor independiente para proveer la soluci&oacute;n de NFS, se opt&oacute; por incluirlo en el Nodo01.

## La soluci&oacute;n contiene los siguientes pasos:
  -) Preparaci&oacute;n del entorno de ejecuci&oacute;n
  -) Toma de decisiones / Configuraci&oacute;n
  -) Ejecuci&oacute;n

### Preparaci&oacute;n del entorno de ejecuci&oacute;n
  *) Clonamos repositorio
  ```bash
  git clone git@github.com:mvicha/k8s-azure
  ```

  *) Creamos los directorios donde persistiremos los datos
  ```bash
  mkdir -p k8s-azure/.azure k8s-azure/.kube k8s-azure/.ssh
  ```

  *) Ejecuci&oacute;n de docker_env
  ```bash
  docker container run --name casopractico2 -it --rm -v ${PWD}/k8s-azure/.azure:/root/.azure -v ${PWD}/k8s-azure/.kube:/root/.kube -v ${PWD}/k8s-azure/.ssh:/root/.ssh -v ${PWD}/k8s-azure:/SAFE_VOLUME mvilla/casopractico2:latest /bin/bash
  ```

  *) Iniciamos sesi&oacute;n en Azure utilizando az-cli ya dentro de nuestro contenedor
  ```bash
  az login
  ```

  *) Definimos el subscription id que utilizaremos. Reemplzar por el valor correspondiente a la subscripci&oacute;n que se quiere utilizar dentro de nuestro contenedor
  ```bash
  az account set --subscription="fa4d5daf-6219-4ac5-8718-a1ff86d3fca7"
  ```

  *) Creaci&oacute;n de un Service Principal que utilizaremos en Terraform
  ```bash
  az ad sp create-for-rbac --role="Contributor"
  ```

  Habiendo creado nuestro Service Principal crearemos el archivo /SAFE_VOLUME/terraform/credentials.tf, el que contendrá los siguientes campos
  ```
  provider "azurerm" {
    subscription_id = "Valor del id de subscripci&oacute;n que utilizaremos"
    client_id       = "Valor de appId obtenido en el paso anterior"
    client_secret   = "Valor de password obtenido en el paso anterior"
    tenant_id       = "Valor de tenant obtenido en el paso anterior"

    features {}
  }
  ```
### Toma de decisiones / Configuraci&oacute;n
Antes de ejecutar la soluci&oacute;n debemos tomar algunas decisiones con respecto a nuestra soluci&oacute;n:
  *) Guardaremos el estado de Terraform de forma local o remota
  *) Ubicaci&oacute;n geogr&aacute;fica de la soluci&oacute;n
  *) Nombre de la cuenta de almacenamiento
  *) Utilizaremos claves de SSH propias o auto-generadas?
  *) Nombre de usuario para la conexi&oacute;n SSH

#### Estado local/remoto de Terraform
Es posible guardar nuestro estado de Terraform de forma remota. De esta manera, si tenemos cualquier problema con nuestro directorio de trabajo, o si trabajamos con otras personas en la misma soluci&oacute;n el estado queda almacenado en la nube y podemos recuperar los &uacute;ltimos cambios de forma autom&aacute;tica.

  *) Para utilizar el estado de forma local no haremos nada y continuaremos con el siguiente paso de "Configuraci&oacute;n"
  *) Para utilizar el estado de forma remote procederemos de la siguiente manera:
  ```bash
  /SAFE_VOLUME/terraform/utils/storage_account.sh
  ```
  El script nos dará una salida que debemos guardar en /SAFE_VOLUME/terraform/state.tf
  ```
  terraform {
    backend "azurerm" {
      resource_group_name   = "tstate"
      storage_account_name  = "tstateXXXX"
      container_name        = "tstate"
      key                   = "terraform.tfstate"
      access_key            = "XXXXXXXXXXXXXXXXXXXYYYYYYYYYYYYZZZZZZZZZZZZZ"
    }
  }
  ```

#### Ubicaci&oacute;n geogr&aacute;fica de la soluci&oacute;n
Actualmente la soluci&oacute;n est&aacute; pensada para ejecutarse en "West Europe", si quisieras ejecutarla en otra ubicaci&oacute;n s&oacute;lo deber&iacute;s cambiar el valor de "location" dentro de /SAFE_VOLUME/terraform/correccion-vars.tf

#### Nombre de la cuenta de almacenamiento
Deber&aacute;s ingresar un valor para storage_account dentro de /SAFE_VOLUME/terraform/correccion-vars.tf

#### Claves de SSH propias o auto-generadas
  *) En el caso que quisieras utilizar cuentas de SSH existentes deber&aacute;s ingresar valores para public_key_path y private_key_path dentro de /SAFE_VOLUME/terraform/correccion-vars.tf (NOTA: Si s&oacute;lo una de las variables contiene datos se considera que est&aacute; incompleto y se proceder&aacute; a auto-generar las claves)
  *) En el caso que quisieras utilizar cuentas auto-generadas deber&aacute;s dejar en blanco los valores de public_key_path y private_key_path dentro de /SAFE_VOLUME/terraform/correccion-vars.tf (NOTA: Si s&oacute;lo una de las variables contiene datos se considera que est&aacute; incompleto y se proceder&aacute; a auto-generar las claves)

#### Nombre de usuario para la conexi&oacute;n SSH
Si quisieras podr&iacute;s elegir el nombre de usuario para conectarte a los servidores via SSH. Para poder seleccionar el nombre s&oacute;lo debes cambiar el valor de "ssh_user" dentro de /SAFE_VOLUME/terraform/correccion-vars.tf

### Ejecuci&oacute;n
La ejecuci&oacute;n es muy sencilla. Habiendo llegado hasta aqu&iacute;, y siguiendo los pasos anteriores s&oacute;lo debemos cambiar de directorio y ejecutar terraform:
```bash
cd /SAFE_VOLUME/terraform
terraform plan -out plan.out
terraform apply plan.out
```

#### Qu&eacute; sucede al ejecutar:
#### Terraform despliega:
  - 1 Grupo de Recursos
  - 3 HD para guardar el SO de las VMs
  - 1 Nodo master de 2 vCPUs y 4Gb de RAM
  - 2 Nodos worker de 1 vCPU y 2Gb de RAM
  - 1 Red virtual
  - 1 Subred
  - 3 Interfaces de red
  - 1 Direcci&oacute;n IP p&uacute;blica
  - 1 alias de DNS asociado a la direcci&oacute;n IP p&uacute;blica
  - 1 HD SSD de 10 Gb para utilizar como NFS y para guardar los datos de la DB MySQL
  - Azure Key Vault para guardar informaci&oacute;n sensible como contrase&ntilde;as. (Las contrase&ntilde;as de MySQL y de Ghost son generadas aleatoriamente y guardadas en Azure Key Vault. Este valor es luego obtenido cuando Ansible se ejecuta, por lo que no hace falta definir ning&uacute;n valor en el c&oacute;digo para que los servicios funcionen)
  - Azure Identity para permitir que el nodo master pueda acceder a los Azure Key Vault Secrets
  - 1 Zona de DNS privada
  - 3 Entradas de DNS para los Nodos

#### Ansible realiza:
  - Instalaci&oacute;n de paquetes b&aacute;sicos de funcionamiento (En todas las m&aacute;quinas virtuales)
  - Formatea HD SSD en xfs y crea sistema de archivos LVM para NFS
  - Instalaci&oacute;n y configuraci&oacute;n de NFS en Nodo01
  - Herramientas para realizar el deployment (Helm, Python modules, etc.) en Master
  - Instalaci&oacute;n de Docker en todos los Nodos
  - Instalaci&oacute;n de Kubelet, Kubeadm y Kubectl en todos los nodos
  - Configuraci&oacute;n de bash completion para Kubectl en todos los nodos
  - Setup de permisos para utilizar Kubectl desde todos los nodos
  - Inicializaci&oacute;n del nodo Master de Kubernetes (s&oacute;lo en Master)
  - Setup de CNI (s&oacute;lo en Master)
  - Uni&oacute;n de los nodos al servidor master de Kubernetes (s&oacute;lo en los Nodos)
  - Despliegue de Ingress Controller
  - Despliegue de Cert-Manager (Para la creaci&oacute;n/renovaci&oacute;n/administraci&oacute;n de certificados TLS)
  - Setup de MySQL
  - Setup de Ghost

### Resultados de la ejecuci&oacute;n
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

WARNING = ""
ansible_exec_command = "ansible-playbook -i ../ansible/hosts -e jump_host='20.86.240.188' -e admin_user='azureuser' -e subnet_cidr_private='192.168.1.0/24' -e private_lan_master='192.168.1.100' -e private_lan_node01='192.168.1.101' -e private_lan_node02='192.168.1.102' -e internal_private_key_file='~/.ssh/test.pem' -e external_private_key_file='~/.ssh/test.pem' -e ghost_url='ghostmvilla.westeurope.cloudapp.azure.com' ../ansible/playbook.yml"
ghost_http_service_url = "http://ghostmvilla.westeurope.cloudapp.azure.com"
ghost_https_service_url = "https://ghostmvilla.westeurope.cloudapp.azure.com"
master_private_address = "192.168.1.100"
master_public_address = "20.86.240.188"
node01_private_address = "192.168.1.101"
node02_private_address = "192.168.1.102"
ssh_admin_user = "azureuser"
ssh_master_connection = "ssh -i ~/.ssh/test.pem azureuser@20.86.240.188"
ssh_node01_connection = "ssh -i ~/.ssh/test.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i ~/.ssh/test.pem -W %h:%p -q azureuser@20.86.240.188' azureuser@192.168.1.101"
ssh_node02_connection = "ssh -i ~/.ssh/test.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i ~/.ssh/test.pem -W %h:%p -q azureuser@20.86.240.188' azureuser@192.168.1.102"
subnet_cidr_private = tolist([
  "192.168.1.0/24",
])
virtual_network_cidr = tolist([
  "192.168.0.0/16",
])
```

* Si por alg&uacute;n motivo quisi&eacute;ramos ejecutar Ansible de forma manual, s&oacute;lo debemos realizar los siguientes pasos:
  - Desde el mismo directorio de trabajo local /SAFE_VOLUME/terraform ejecutamos la l&iacute;nea que obtuvimos en el output de ansible_exec_command:
  ```bash
  ansible-playbook -i ../ansible/hosts -e jump_host='20.86.240.188' -e admin_user='azureuser' -e subnet_cidr_private='192.168.1.0/24' -e private_lan_master='192.168.1.100' -e private_lan_node01='192.168.1.101' -e private_lan_node02='192.168.1.102' -e internal_private_key_file='~/.ssh/test.pem' -e external_private_key_file='~/.ssh/test.pem' -e ghost_url='ghostmvilla.westeurope.cloudapp.azure.com' ../ansible/playbook.yml
  ```

  - Una alternativa a la ejecuci&oacute;n manual es obligar a Terraform a que vuelva a ejecutar ansible. Para ello debemos seguir los siguientes pasos desde el mismo directorio de trabajo local /SAFE_VOLUME/terraform ejecutamos:
  ```bash
  terraform taint null_resource.ansible
  terraform apply -target null_resource.ansible
  ```

### Validaci&oacute;n de funcionamiento:
  *) Servicio HTTP:
    - Abrir un navegador de internet a la direcci&oacute;n http://<ghost_http_service_url>

  *) Servicio HTTPS:
    - Abrir un navegador de internet a la direcci&oacute;n http://<ghost_https_service_url>

### Otras variables a tener en cuenta:
  - Primero se despliega el entorno utilizando Terraform. Hay algunas variables que se pueden modificar para desplegar un entorno personalizable, aunque algunas de ellas se recomienda no modificarlas. Estas variables se encuentran dentro de /SAFE_VOLUME/terraform/variables.tf:
    * virtual_network_cidr:

      Esta variable define el CIDR de nuestra red virtual. Se recomienda no cambiarla

    * subnet_cidr_private:

      Esta variable define el CIDR de nuestra red privada. Se recomienda no cambiarla

    * private_lan_master:

      Esta variable define la IP que utilizar&aacute; el nodo master en la red privada

    * mysql_ghost_database:

      Esta variable define el nombre de la DB que se utilizar&aacute; con la aplicaci&oacute;n de blog
  
    * workers:

      Esta variable contiene la estructura de los workers, con su nombre y direcci&oacute;n IP privada

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
    * Servicio
    * Secrets obtenidos de Azure Key Vault
    * Configmap
    * Deployment con 3 replicas
    * TLS Issuer
    * Definici&oacute;n de ingress con TLS
