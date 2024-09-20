variable "folder_id" {
  type = string
  description = "Folder id for resources"
  default = null
}

variable "vpc_id" {
  type = string
  description = "VPC id for resources. Default create new network."
  default = null
}

variable "yc_availability_zones" {
  type = list(string)
  description = "List of Yandex Cloud availability zones for deploying NAT instances"
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-d"
  ]
}

variable "subnet_prefix_list" {
  type        = list(string)
  description = "List of prefixes for NAT instances subnets. One prefix per availability zone in order from yc_availability_zones list"
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "nat_instances_count" {
  type = number
  description = "Number of NAT instances"
  default = 2
}

variable "registry_private_access" {
  type        = bool
  description = "Restrict access to Container Registry only from NAT-instances public IP-address"
  default     = true
}

variable "trusted_cloud_nets" {
  type = list(string)
  description = "List of trusted cloud internal networks for connection to Container Registry through NAT-instances"
  default = []
}

variable "vm_username" {
   type = string
   description = "Username for VMs"
   default = "admin"
}

variable "cr_ip" {
  type        = string
  description = "Yandex Container Register Endpoint IP address"
  default     = "51.250.44.40"
}

variable "cr_fqdn" {
  type        = string
  description = "Yandex Container Register Endpoint FQDN"
  default     = "cr.yandex"
}

variable "s3_ip" {
  type        = string
  description = "Yandex Object Storage Endpoint IP address"
  default     = "213.180.193.243"
}

variable "s3_fqdn" {
  type        = string
  description = "Yandex Object Storage Endpoint FQDN"
  default     = "storage.yandexcloud.net"
}

