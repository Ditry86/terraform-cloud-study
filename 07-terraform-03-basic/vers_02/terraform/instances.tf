resource "yandex_compute_instance" "netology_07_03_count" {
  name = "${terraform.workspace}-${count.index}"
  count = local.instance_count[terraform.workspace]
  platform_id = local.instance_platform[terraform.workspace]

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_22.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.terraform_07_03_subnet.id
    nat       = true
  }
}

resource "yandex_compute_instance" "netology_07_03_for_each" {
  for_each = local.workscpace_instances[terraform.workspace]
  name = "${terraform.workspace}-${each.key}"
  platform_id = each.value.platform

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_22.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.terraform_07_03_subnet.id
    nat       = true
  }
}

