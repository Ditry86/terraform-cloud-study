provider "yandex" {
  zone = "ru-central1-a"
}
data "yandex_compute_image" "ubuntu_22" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "netology-1" {
  name = "terraform-07-home-task"

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
    subnet_id = yandex_vpc_subnet.terraform_07_subnet.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./inst_meta.conf")}"
  }
}

resource "yandex_vpc_network" "netology_net" {
}

resource "yandex_vpc_subnet" "terraform_07_subnet" {
  name           = "terraform_07"
  network_id     = yandex_vpc_network.netology_net.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

