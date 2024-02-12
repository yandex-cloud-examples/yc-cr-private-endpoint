// Folder id for resources
folder_id = "b1gentmqf1ve9uc54nfh"

// List of Yandex Cloud availability zones for deploying NAT instances
yc_availability_zones = [
    "ru-central1-a",
    "ru-central1-b"
]

// Number of NAT instances 
nat_instances_count = 2

// Restrict access to Container Registry only from NAT-instances public IP-address
registry_private_access = true

// List of trusted cloud internal networks for connection to Container Registry through NAT-instances"
trusted_cloud_nets = ["10.0.0.0/8"]

// Username for VMs
vm_username = "admin"