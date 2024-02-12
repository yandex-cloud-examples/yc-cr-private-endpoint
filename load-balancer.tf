// Internal NLB for CR
resource "yandex_lb_network_load_balancer" "cr_nlb" {
  folder_id   = var.folder_id
  name = "cr-nlb"
  type = "internal"

  listener {
    name = "https-listener"
    port = 443
    target_port = 4434
    internal_address_spec {
      subnet_id  = yandex_vpc_subnet.nat_vm_subnets[0].id
      address = cidrhost(yandex_vpc_subnet.nat_vm_subnets[0].v4_cidr_blocks[0], 100)
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.cr_nat_group.id

    healthcheck {
      name = "healthcheck"
      timeout = 2
      interval = 3
      unhealthy_threshold = 3
      healthy_threshold = 3
      tcp_options {
        port = 4434 
      }
    }
  }
}

// target group with NAT instances
resource "yandex_lb_target_group" "cr_nat_group" {
  folder_id = var.folder_id
  name      = "cr-nat-group"

  dynamic "target" {
    for_each = yandex_compute_instance.nat_vm
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}


// Internal NLB for S3
resource "yandex_lb_network_load_balancer" "s3_nlb" {
  folder_id   = var.folder_id
  name = "s3-nlb"
  type = "internal"

  depends_on = [yandex_lb_network_load_balancer.cr_nlb]

  listener {
    name = "https-listener"
    port = 443
    target_port = 4435
    internal_address_spec {
      subnet_id  = yandex_vpc_subnet.nat_vm_subnets[0].id
      address = cidrhost(yandex_vpc_subnet.nat_vm_subnets[0].v4_cidr_blocks[0], 200)
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.cr_nat_group.id

    healthcheck {
      name = "healthcheck"
      timeout = 2
      interval = 3
      unhealthy_threshold = 3
      healthy_threshold = 3
      tcp_options {
        port = 4435 
      }
    }
  }
}
