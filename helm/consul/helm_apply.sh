helm upgrade  --install \
consul hashicorp/consul \
--create-namespace \
 --namespace consul \
--set server.storageClass=local-storage
