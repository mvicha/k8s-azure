#!/bin/bash

nodeServer="${1}"

function fcnHelp {
  echo "Usage: ${0} <node_name>"
  echo -en "\n\n"
  exit
}

case ${nodeServer} in
  master|node01|node02)
    cd terraform
    ansible_command=("$(terraform output | egrep ssh_${nodeServer}_connection | sed 's/.*"\(.*\)"$/\1/')")

    if [[ ${?} -eq 0 ]]; then
      eval "${ansible_command[@]}"
    fi
    ;;
  *)
    fcnHelp
    ;;
esac

