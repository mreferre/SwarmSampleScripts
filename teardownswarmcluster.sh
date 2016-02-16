docker-machine rm swarm-node1-master -y
docker-machine rm mh-keystore -y
i=2
NUMBEROFNODES=$1
while [[ ${i} -le ${NUMBEROFNODES} ]]
    do
    	docker-machine rm swarm-node${i} -y
		((i=i+1))
	done