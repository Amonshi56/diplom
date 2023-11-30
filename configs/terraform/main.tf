terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.102.0"
    }
  }
}


provider "yandex" {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
  service_account_key_file = "/home/test/Downloads/authorized_key.json"
}

locals {
  folder_id = "b1gq6eu6f07mpjagftd8"
  cloud_id = "b1gdhcbb6rh0t37j6o5o"
}