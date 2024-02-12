resource "yandex_container_registry" "test_registry" {
  name      = "test-registry"
  folder_id = var.folder_id
}

resource "yandex_container_registry_ip_permission" "my_ip_permission" {
  count = var.registry_private_access ? 1 : 0
  registry_id = yandex_container_registry.test_registry.id
  push        = formatlist("%s/32", yandex_vpc_address.public_ip_list.*.external_ipv4_address.0.address)
  pull        = formatlist("%s/32", yandex_vpc_address.public_ip_list.*.external_ipv4_address.0.address)
}