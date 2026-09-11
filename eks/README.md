# EKS

## vpc.tf
- A vpc is needed for the cluster to operate in. Needs to be able to create pod-to-pod 
  and pod-to-service networking, enforce security groups and network isolation

###

## eks.tf

### EKS Cluster
- Spins up the just the control plane

### Managed Node Group
- Spins up the worker nodes that will be managed by the control plane
- Assigned the ncessary role and policies to the node group so they can utilize the cluster