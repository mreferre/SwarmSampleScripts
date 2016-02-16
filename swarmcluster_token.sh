#!/bin/bash

#############################################################
## 	              Massimo Re Ferrè - IT20.INFO             ##
#############################################################

# This small sample script creates a 3 hosts swarm cluster against a local Fusion or Virtualbox environment  

# It requires Docker Toolbox (tested with version 1.10)

docker-machine create -d $1 temphost
eval "$(docker-machine env temphost)"
SWARMTOKEN="$(docker run swarm create)"
echo $SWARMTOKEN
docker-machine create -d $1 --swarm --swarm-master --swarm-discovery token://$SWARMTOKEN swarm-master
docker-machine create -d $1 --swarm --swarm-discovery token://$SWARMTOKEN swarm-node00
docker-machine create -d $1 --swarm --swarm-discovery token://$SWARMTOKEN swarm-node01

docker-machine rm temphost -y

echo "Ensure you set the proper environmental variables..."
docker-machine env --swarm swarm-master
