#!/bin/bash

secs=$(date +%s)
if [[ ! -d resources ]]; then
  mkdir resources
fi


if [[ -f resources/id_rsa_external ]]; then
  mv resources/id_rsa_external resources/id_rsa_external.${secs}
fi

if [[ -f resources/id_rsa_internal ]]; then
  mv resources/id_rsa_internal resources/id_rsa_internal.${secs}
fi

echo -en $(terraform state pull | jq '.outputs["tls_external_private_key"].value' | sed 's/^"//; s/\\n"$//') > resources/id_rsa_external
chmod 400 resources/id_rsa_external
echo -en $(terraform state pull | jq '.outputs["tls_internal_private_key"].value' | sed 's/^"//; s/\\n"$//') > resources/id_rsa_internal
chmod 400 resources/id_rsa_internal
