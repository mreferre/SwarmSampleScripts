#!/bin/bash

#############################################################
## 	              Massimo Re Ferrè - IT20.INFO             ##
#############################################################

# This small sample script creates a swarm cluster w/ Consul against the following end-points: 
# - VMware Fusion
# - Virtualbox
# - vSphere (vCenter) 
# - ESX standalone 

# It requires Docker Toolbox (tested with version 1.10)

# usage: ./swarmcluster_consul.sh <# of Docker hosts> <driver> <vcenter | esx>
# example: ./swarmcluster_consul.sh 5 vmwarevsphere vcenter    <- will deploy a 5 nodes swarm cluster on vSphere (vCenter)
# example: ./swarmcluster_consul.sh 3 vmwarevsphere esx        <- will deploy a 3 nodes swarm cluster on vSphere (ESX standalone)
# example: ./swarmcluster_consul.sh 2 vmwarefusion             <- will deploy a 2 nodes swarm cluster on the local VMware Fusion
# example: ./swarmcluster_consul.sh 1 virtualbox               <- will deploy a 1 node swarm cluster on the local Virtualbox

# if using the vmwarevsphere flag remember to set the proper variables in the setVars function below


NUMBEROFNODES=$1
DRIVER=$2
ENDPOINT=$3

check() {
  if [ ${NUMBEROFNODES} -le 0 ]; then
  	echo "You need at least one node" 
  	exit 1
  fi 
}

unsetVars() {
	unset VSPHERE_VCENTER
	unset VSPHERE_USERNAME
	unset VSPHERE_PASSWORD
	unset VSPHERE_NETWORK
	unset VSPHERE_DATASTORE
	unset VSPHERE_DATACENTER
	unset VSPHERE_HOSTSYSTEM
	unset VSPHERE_POOL
}

welcome() {
	echo 'if using the vmwarevsphere flag remember to set the proper variables in the script' 
}

setVars() {
if [ "${DRIVER}" == 'vmwarevsphere' ]; then

  if [ "${ENDPOINT}" == 'vcenter' ]; then
    export VSPHERE_VCENTER=192.168.1.12                                 # vCenter IP/FQDN
    export VSPHERE_USERNAME='administrator@vsphere.local'               # vCenter user 
    export VSPHERE_PASSWORD='Vmware123!'                                # vCenter user password 
    export VSPHERE_NETWORK='VM Network'                                 # PortGroup
    export VSPHERE_DATASTORE='datastore1'                               # Datastore
    export VSPHERE_DATACENTER='Home'                                    # Datacenter name 
    export VSPHERE_HOSTSYSTEM='Cluster1/*'                              # cluster name (inside the datacenter)   
    #export VSPHERE_POOL='/Home/host/Cluster1/Resources/SwarmTeam13' 	# *optional* Resource Pool name (in the vSphere cluster)
  fi # if [ $3 = 'vcenter' ]; then
  
  if [ "${ENDPOINT}" == 'esx' ]; then
    export VSPHERE_VCENTER=192.168.209.11                                # ESXi IP/FQDN
    export VSPHERE_USERNAME='root'                                       # ESXi user 
    export VSPHERE_PASSWORD='Vmware123!'                                 # ESXi user password 
    export VSPHERE_NETWORK='VM Network'                                  # PortGroup
    export VSPHERE_DATASTORE='datastore1'                                # Datastore
    #export VSPHERE_POOL='/*/host/*/Resources/SwarmTeam9'                # *optional* Resource Pool name (on the ESX host)
  fi # if [ $3 = 'esx' ]; then
    							
fi # if [ $2 = 'vmwarevsphere' ]; then
}

deployKeystore() {
    echo docker-machine create -d ${DRIVER} mh-keystore
	docker-machine create -d ${DRIVER} mh-keystore
	docker $(docker-machine config mh-keystore) run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap
}

deployMaster() {
	docker-machine create -d ${DRIVER} --swarm --swarm-master \
			--swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
			--engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
			--engine-opt="cluster-advertise=eth0:2376" \
			swarm-node1-master
}

deploySlaves() {
    i=2
    while [[ ${i} -le ${NUMBEROFNODES} ]]
	do
    	docker-machine create -d ${DRIVER} --swarm \
				--swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
				--engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
				--engine-opt="cluster-advertise=eth0:2376" \
				swarm-node${i}
		((i=i+1))
	done
}

greetings() {		
	echo "Ensure you set the proper environmental variables..."
	docker-machine env --swarm swarm-node1-master
}

main() {
  check
  unsetVars
  welcome
  setVars
  deployKeystore	 
  deployMaster
  deploySlaves
  greetings
}

main





