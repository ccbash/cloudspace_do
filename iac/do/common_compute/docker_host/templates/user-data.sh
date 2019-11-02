#!/bin/bash

echo "Get host Public IP"
export EC2_LOCAL_IP="$(curl -w "\n" http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)"

sudo yum -y install docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Run consul docker"
docker run -d \
  --name consul-agent --net=host \
  -e CONSUL_LOCAL_CONFIG='{
    "datacenter"  : "${datacenter}",
    "server"      : false,
    "ui"          : false,
    "enable_central_service_config" : true,
    "bind_addr"   : "0.0.0.0",
    "client_addr" : "0.0.0.0",
    "retry_join"  : ["${servicediscovery_ip}"],
    "connect"     : {"enabled" : true}
  }' \
  consul agent -advertise $EC2_LOCAL_IP  

echo "Run Registrator in docker"
docker run -d --net=host \
    --name=registrator \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator -retry-attempts=30 \
      consul://$EC2_LOCAL_IP:8500
      
##### DOCKER SWARM JOIN #####################################

docker swarm join --token $(curl http://${servicediscovery_ip}:8500/v1/kv/docker-swarmworker-token?raw) ${servicediscovery_ip}:2377

      
echo "Done"