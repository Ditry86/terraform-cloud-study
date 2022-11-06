resource "yandex_vpc_network" "netology_net" {
}

resource "yandex_vpc_subnet" "terraform_07_03_subnet" {
  name           = "${terraform.workspace}-lan"
  network_id     = yandex_vpc_network.netology_net.id
  v4_cidr_blocks = "${local.workspace_lans[terraform.workspace]}"
}