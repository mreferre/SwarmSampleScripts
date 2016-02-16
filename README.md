# Massimo Re Ferre' [www.it20.info](http://www.it20.info)

## Sample Swarm clusters scripts 

These are a set of sample scripts that are intended to illustrate how to properly use docker-machine in conjunction with a vSphere end-point

In particular, docker-machine officially supports a number of VMware drivers:

- Fusion
- vSphere
- vCloud Air

The samples in this repo are specific to vSphere (albeit they will work with both Fusion and Virtualbox, because of the way they have been written)

## When can these samples be useful? 

I found the Docker documentation a bit lacking in terms of how to properly parametrize docker-machine when talking to vSphere. Particularly the differences between talking to vCenter and/or ESX standalone as well as the differences between deploying the docker hosts (swarm nodes) on the root of the cluster/host or in a Resource Pool. 

The more sophisticated script (swarmcluster_consul.sh) includes examples of how you would need to set the variables / parameters to, depending on the deployment scenarios, using the `vmwarevsphere` driver. 

Most likely these scripts won't be used as-is. Their primary intent is to better document the `vmwarevsphere` driver. 

## Prerequisites

The scripts have been tested on a MacBook with Docker Toolbox 1.10 installed 

## Instructions and usage examples 

Please edit each individual script and read the comments at the beginning for guidance

