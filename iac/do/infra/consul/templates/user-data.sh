#!/bin/bash

echo "Get host Public IP"
export EC2_LOCAL_IP="$(curl -w "\n" http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)"

sudo yum -y install docker
sudo systemctl enable docker
sudo systemctl start docker


##### CONSUL #####################################

echo "Run consul docker"
docker run \
    -d --net=host --name=consul \
    -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' \
    -e CONSUL_LOCAL_CONFIG='{
          "node_name"   : "${datacenter}-master", 
          "datacenter"  : "${datacenter}",
          "domain"      : "${zone}",
          "server"      : true,
          "ui"          : true,
          "verify_incoming_rpc" : false,
          "enable_central_service_config" : true,
          "bind_addr"   : "0.0.0.0",
          "client_addr" : "0.0.0.0",
          "bootstrap_expect" : 1,
          "connect"     : {"enabled" : true},
          "ports"       : {"dns"     : 53,
                           "grpc"    : 8502 },
          "recursors"   : ["8.8.8.8", "8.8.4.4"]
    }' \
    consul agent -advertise $EC2_LOCAL_IP
    
echo "Consul Proxy default"
curl \
    --request PUT \
    --data '{
      "kind" : "proxy-defaults",
      "name" : "global",
      "config" : {
        "protocol" : "http"
      }
    }' \
    http://127.0.0.1:8500/v1/config
    
##### VAULT #####################################

echo "Run Vault docker"

cat << EOF > vault.hcl
storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
  service = "vault"
  service_tags = "traefik.enable=true"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr          = "http://$EC2_LOCAL_IP:8200"
max_lease_ttl     = "10h"
default_lease_ttl = "10h"
cluster_name      = "${datacenter}_vault"
ui                = true
disable_sealwrap  = true

EOF

sudo docker run \
  -d --net=host --name=vault --cap-add=IPC_LOCK \
  -v $PWD/vault.hcl:/etc/vault/vault.hcl \
  vault server -config=/etc/vault/vault.hcl

##### TRAEFIK #####################################

cat << EOF > traefik.toml
[entryPoints]
  [entryPoints.http]
    address = ":80"
    compress = true
  [entryPoints.api]
    address = ":8080"
    compress = true
    
[api]
  entryPoint = "api"
  dashboard = true
  # debug = true

[consulCatalog]
  endpoint = "127.0.0.1:8500"
  domain = "${zone}"
  exposedByDefault = false
  prefix = "traefik"
EOF

docker run \
  -d --net=host --name=traefik \
  -v $PWD/traefik.toml:/etc/traefik/traefik.toml \
  traefik:v1.7
    
curl \
    --request PUT \
    --data '
       { "name": "traefik",
         "port": 80
       }' \
    http://127.0.0.1:8500/v1/agent/service/register

##### DOCKER SWARM #####################################

docker swarm init --advertise-addr $EC2_LOCAL_IP

curl \
    --request PUT \
    --data $(docker swarm join-token -q worker) \
    http://127.0.0.1:8500/v1/kv/docker-swarmworker-token
    

echo "Done"