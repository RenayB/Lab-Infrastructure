region = "us-east-1"

vpc_name            = "renay-lab-eks-vpc"
availability_zones  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

cluster_name    = "renays-lab-eks-cluster"
node_group_name = "renays-lab-eks-node-group"

# Required, no default - set this before applying (see eks/variables.tf).
# Left blank here since tfvars files are committed to a public repo and this
# would otherwise expose a real IP address. Pass locally with:
#   terraform apply -var-file=tfvars/renays-lab.tfvars -var='endpoint_public_access_cidrs=["YOUR_IP/32"]'
endpoint_public_access_cidrs = []

tags = {
  project = "renays-lab-eks"
}
