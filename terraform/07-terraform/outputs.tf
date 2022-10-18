output "instance_name" {
  value = yandex_compute_instance.netology-1.name
}

output "internal_ip" {
  value = yandex_compute_instance.netology-1.network_interface.0.ip_address
}

output "external_ip" {
  value = yandex_compute_instance.netology-1.network_interface.0.nat_ip_address
}

output "instance_user" {
  value = "user "+substr(yandex_compute_instance.netology-1.metadata.user-data, 25, 13)
}