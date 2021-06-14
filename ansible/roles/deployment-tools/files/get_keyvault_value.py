import sys
from azure.keyvault.secrets import SecretClient
from azure.identity import DefaultAzureCredential

# keyvaultk8
keyVaultName = sys.argv[1]
# mysql-admin-password
secretName = sys.argv[2]

if keyVaultName and secretName:
  KVUri = f"https://{keyVaultName}.vault.azure.net"

  credential = DefaultAzureCredential()
  client = SecretClient(vault_url=KVUri, credential=credential)
  retrieved_secret = client.get_secret(secretName)

  print(retrieved_secret.value)
