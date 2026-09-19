region = "us-east-1"

vpc_name            = "renays-lab-dev-eks-vpc"
availability_zones  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

cluster_name    = "renays-lab-dev-eks-cluster"
node_group_name = "renays-lab-dev-eks-node-group"

# t3.small's allocatable memory is too tight once cert-manager, an ingress
# controller, and app pods all have to coexist on a single node (min/max are
# 0/1 - no second node to spread onto). t3.medium roughly doubles headroom
# for about +$15/mo while scaled up.
node_instance_types = ["t3.medium"]

# API server is private-only (see below), so this is moot - AWS ignores
# public_access_cidrs whenever endpoint_public_access is false. Left empty
# rather than removed since the variable is still required.
endpoint_public_access_cidrs = []

# Private-only API server: reached via the bastion stack over SSM port
# forwarding, not directly from the internet, so there's no IP to keep
# updating.
endpoint_public_access  = false
endpoint_private_access = true

tags = {
  project     = "renays-lab-dev-eks"
  environment = "dev"
}
