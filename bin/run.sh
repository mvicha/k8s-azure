#!/bin/bash

type="${1}"

function fcnHelp {
  echo "Usage: ${0} <exec_type>"
  echo -en "\nExecution Types:"
  echo -en "\n\tcreate\t\tDespliega la infraestructura y despliega kubernetes"
  echo -en "\n\tdeploy\t\tDespliega kubernetes en la infraestructura"
  echo -en "\n\tundeploy\tElimina kubernetes de la infraestructura"
  echo -en "\n\tdestroy\t\tElimina la infraestructura"
  echo -en "\n\tinfo\t\tMuestra información del despliegue"
  echo -en "\n\tmy_ip\t\tMuestra mi dirección IP pública"

  echo "* Para comenzar con la ejecución primero deberá crear el archivo de variables correspondiente (Más información en README.md)"
  echo "* Luego deberá tomar la decisión si utilizar estados remotos o guardar su terraform state file localmente (Más información en README.md - Ejecutar utils/storage_account.sh para crear cuenta y configurar terraform/state.tf)"
  echo -en "\n\n"
  exit
}

function my_ip {
  echo "$(dig +short myip.opendns.com @resolver1.opendns.com)"
}

function validate_vars {
  if [[ ! -a "terraform/correccion-vars.tf" ]]; then
    echo -en "\n\nERROR: No existe el archivo de variables de terraform para continuar con el despliegue.\nDebe configurar las siguientes variable terraform/config/correccion-vars.tf como se lee a continuación:\n\n"
    echo "-----------------------------------------------------"
    echo "location         = \"Ubicación donde quiere desplegar la plataforma\""
    echo "ssh_user         = \"Nombre de usuario que se utilizará para conectarse a los servidores de Azure via SSH\""
    echo "storage_account  = \"Nombre de la cuenta de almacenamiento que se creará para guardar los recursos de Azure\""
    echo "prefix           = \"Nombre distintivo que se utilizará para nombrar los recursos\""
    echo "ghost_dns_alias  = \"Nombre que se utilizará para adjuntar al FQDN de la IP pública asignada por Azure. Esto, en conjunto con el FQDN de Azure nos permitirá"
    echo "                    ingresar al servicio Ghost por medio de un nombre de dominio\""
    echo "my_ip            = \"Dirección IP de la máquina desde que está ejecutando para poder acceder via SSH a los servidores de Azure\""
    echo "public_key_path  = \"Ruta hacia la clave pública asociada a la llave de SSH que se utilizará para conectar a los servidores de Azure. Si public_key_path o private_key_path contienen una cadena vacía Terraform creará las claves por nosotros\""
    echo "private_key_path = \"Ruta hacia la clave privada de SSH que se utilizará para conectar a los servidores de Azure. Si public_key_path o private_key_path contienen una cadena vacía Terraform creará las claves por nosotros\""
    echo -en "-----------------------------------------------------\n\n"

    echo "Ejemplo:"
    echo "-----------------------------------------------------"
    echo "location         = \"West Europe\""
    echo "ssh_user         = \"mysshuser\""
    echo "storage_account  = \"myuniquesa\""
    echo "prefix           = \"myuniqueprefix\""
    echo "ghost_dns_alias  = \"myownghost\""
    echo "my_ip            = \"`my_ip`\""
    echo "public_key_path  = \"~/.ssh/id_rsa.pub\""
    echo "private_key_path = \"~/.ssh/id_rsa\""
    echo -en "-----------------------------------------------------\n\n"
    return 1
  fi
  return 0
}

function validate {
  warning=0
  validate_vars
  error=${?}

  if [[ ! -a "terraform/state.tf" ]]; then
    echo -en "\n\nWARNING: No existe el archivo de estado de terraform.\nEste archivo nos permite guardar el estado de Terraform de manera remota.Puede configuar el estado remoto siguiendo los siguientes pasos:\n\n"
    echo "-----------------------------------------------------"
    echo "Ejecutar utils/storage_account.sh y seguir los pasos"
    echo -en "-----------------------------------------------------\n\n"
    warning=1
  fi

  if [[ ${error} -eq 1 ]]; then
    exit
  fi

  if [[ ${warning} -eq 1 ]]; then
    echo "Tienes 20 segundos para tomar la decisión si quieres continuar sin el estado remoto. Para detener la ejecución y configurar estado remoto presionar CTRL+C y ejecutar utils/storage_account.sh y proceder con los pasos para crear el archivo terraform/state.tf"
    sleep 20
  fi
}

case ${type} in
  create)
    validate

    cd terraform
    terraform init
    terraform apply -auto-approve
    ;;
  deploy)
    cd terraform
    ansible_command="$(terraform output | egrep ansible_exec_command | sed 's/.*"\(.*\)"$/\1/')"
    if [[ ${?} -eq 0 ]]; then
      exec ${ansible_command}
    fi
    ;;
  undeploy)
    cd terraform
    ansible_command="$(terraform output | egrep ansible_exec_command | sed 's/.*"\(.*\) \.\.\/ansible\/playbooks\/create\.yml"$/\1/')"
    if [[ ${?} -eq 0 ]]; then
      ansible_command="${ansible_command} ../ansible/playbooks/destroy.yml"
      exec ${ansible_command}
    fi
    ;;
  destroy)
    validate_vars

    if [[ ${?} -eq 0 ]]; then
      cd terraform
      terraform destroy -auto-approve
    fi
    ;;
  info)
    cd terraform
    terraform refresh
    terraform output
    ;;
  my_ip)
    my_ip
    ;;
  *)
    fcnHelp
    ;;
esac
