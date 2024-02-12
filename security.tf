// Create service account for Container Register and assign required roles for it
resource "yandex_iam_service_account" "cr_sa" {
  folder_id = var.folder_id
  name = "cr-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "cr_sa_roles" {
  folder_id = var.folder_id
  role   = "container-registry.images.puller"
  member = "serviceAccount:${yandex_iam_service_account.cr_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cr_sa_roles_pusher" {
  folder_id = var.folder_id
  role   = "container-registry.images.pusher"
  member = "serviceAccount:${yandex_iam_service_account.cr_sa.id}"
}

// Create security group for NAT instances
resource "yandex_vpc_security_group" "nat_sg" {
  name        = "cr-nat-sg"
  description = "Security group for NAT instances"
  folder_id   = var.folder_id
  network_id  = var.vpc_id == null ? yandex_vpc_network.vpc[0].id : var.vpc_id

  ingress {
    protocol            = "TCP"
    description         = "CR NLB healthcheck"
    port                = 4434
    predefined_target   = "loadbalancer_healthchecks"
  }

  ingress {
    protocol            = "TCP"
    description         = "S3 NLB healthcheck"
    port                = 4435
    predefined_target   = "loadbalancer_healthchecks"
  }

  ingress {
    protocol            = "TCP"
    description         = "requests to Container Registry from trusted cloud internal networks"
    port                = 4434
    v4_cidr_blocks      = var.trusted_cloud_nets
  }

  ingress {
    protocol            = "TCP"
    description         = "requests to Object Storage from trusted cloud internal networks"
    port                = 4435
    v4_cidr_blocks      = var.trusted_cloud_nets
  }

  egress {
    protocol       = "ANY"
    description    = "outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
