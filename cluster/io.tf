variable "cluster" {
  type = "map"

  default = {
    name    = ""
    version = ""
  }
}

variable "depends-id" {}

variable "cluster-root-tld" {
  default = "internal.t8s"
}

variable "timezone" {
  default = "Etc/GMT0"
}

variable "cluster-domain" {
  default = "cluster.local"
}

variable "master-count" {
  default = "3"
}

variable "master-cidr-offset" {
  default = "10"
}

variable "dns-service-ip" {
  default = "10.3.0.10"
}

variable "k8s-service-ip" {
  default = "10.3.0.1"
}

variable "additional-cidr-blocks-master" {
  default = ""
}

variable "additional-cidr-blocks-node" {
  default = ""
}

variable "vpc-id" {}
variable "subnet-ids-public" {}
variable "subnet-ids-private" {}

variable "load-balancers" {
  default = ""
}

variable "k8s" {
  type = "map"

  default = {
    hyperkube-image = "quay.io/coreos/hyperkube"
    hyperkube-tag   = "v1.9.1_coreos.0"
  }
}

variable "cidr" {
  type = "map"

  default = {
    vpc             = "10.0.0.0/16"
    allow-ssh       = "0.0.0.0/0"
    pods            = "10.2.0.0/16"
    service-cluster = "10.3.0.0/24"
  }
}

variable "instance-type" {
  type = "map"

  default = {
    bastion = "t2.nano"
    master  = "m3.large"
    node    = "m3.large"
  }
}

variable "capacity" {
  type = "map"

  default = {
    desired = 1
    max     = 5
    min     = 1
  }
}

variable "volume-size" {
  type = "map"

  default = {
    ebs  = 250
    root = 52
  }
}

variable "aws" {
  type = "map"

  default = {
    account-id = ""
    azs        = ""
    key-name   = ""
    region     = ""
  }
}

variable "etcd-storage-backend" {
  default = "etcd3"
}

variable "version" {
  type = "map"

  default = {
    etcd = "3.0.17"
  }
}

variable "enable-api-batch-v2alpha1" {
  default = false
}

# outputs
output "cluster-domain" {
  value = "${ var.cluster-domain }"
}

output "dns-service-ip" {
  value = "${ var.dns-service-ip }"
}

output "master1-ip" {
  value = "${ element( split(",", module.iv.master-ips), 0 ) }"
}

output "bastion-ip" {
  value = "${ module.bastion.ip }"
}

output "external-elb" {
  value = "${ module.master.external-elb }"
}

output "cluster-internal-tld" {
  value = "${ module.iv.extended-cluster["cluster-tld"] }"
}

output "node-autoscaling-group-name" {
  value = "${ module.node.autoscaling-group-name }"
}

output "node-autoscaling-group-id" {
  value = "${ module.node.autoscaling-group-id }"
}

output "route-53-zone-id" {
  value = "${ module.route53.cluster-internal-zone-id }"
}

output "cluster" {
  value = "${
    map(
      "cluster-domain", "${ var.cluster-domain }",
      "cluster-tld", "${ module.iv.extended-cluster["cluster-tld"] }",
      "node-autoscaling-group-name", "${ module.node.autoscaling-group-name }",
      "node-autoscaling-group-id", "${ module.node.autoscaling-group-id }",
      "bastion", "${ module.bastion.ip }",
      "dns-service", "${ var.dns-service-ip }",
      "master1-ip", "${ module.iv.master-ips }",
      "zone-id", "${ module.route53.cluster-internal-zone-id }",
      "node-iam-id", "${ module.iam.aws-iam-role-node-id }",
      "master-iam-id", "${ module.iam.aws-iam-role-etcd-id }"
    )
  }"
}
