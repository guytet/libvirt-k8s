helm upgrade  --install consul hashicorp/consul --create-namespace -n consul --set server.storageClass=local-storage --set client.enabled=false --set server.replicas=2
