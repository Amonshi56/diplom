# output "internal_ip_address_web-1" {
#   value = yandex_compute_instance.web-1.network_interface.0.ip_address
# }

# output "internal_ip_address_web-2" {
#   value = yandex_compute_instance.web-2.network_interface.0.ip_address
# }

# output "external_ip_address_web-1" {
#   value = yandex_compute_instance.web-1.network_interface.0.nat_ip_address
# }

# output "external_ip_address_web-2" {
#   value = yandex_compute_instance.web-2.network_interface.0.nat_ip_address
# }

output "subnet-1" {
  value = yandex_vpc_subnet.subnet-1.id
}

output "output-ip-host" {
  value = <<OUTPUT

App load balancer
external = ${yandex_alb_load_balancer.load-balancer.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}

VM bastion
internal = ${yandex_compute_instance.bastion.fqdn}
external = ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}

VM web1
internal = ${yandex_compute_instance.web-1.fqdn}

VM web2
internal = ${yandex_compute_instance.web-2.fqdn}

VM Elastic
internal = ${yandex_compute_instance.elastic.fqdn}

VM Kibana
internal = ${yandex_compute_instance.kibana.fqdn}
external = ${yandex_compute_instance.kibana.network_interface.0.nat_ip_address}

VM Zabbix
internal = ${yandex_compute_instance.zabbix.fqdn}
external = ${yandex_compute_instance.zabbix.network_interface.0.nat_ip_address}

OUTPUT
}

output "output-ansible-hosts" {
  value = <<OUTPUT

[bastion]
bastion-host ansible_host=${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} ansible_ssh_user=debian

[webservers]
web1 ansible_host=${yandex_compute_instance.web-1.fqdn}
web2 ansible_host=${yandex_compute_instance.web-2.fqdn}

[elastic]
elastic-host ansible_host=${yandex_compute_instance.elastic.fqdn}

[kibana]
kibana-host ansible_host=${yandex_compute_instance.kibana.fqdn}

[zabbix]
zabbix-host ansible_host=${yandex_compute_instance.zabbix.fqdn}

[webservers:vars]
ansible_ssh_user=debian
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p debian@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

[elastic:vars]
ansible_ssh_user=debian
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p debian@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

[kibana:vars]
ansible_ssh_user=debian
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p debian@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

[zabbix:vars]
ansible_ssh_user=debian
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p debian@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

OUTPUT
}

# выходные данные для ансибла прописаы с подключением через bastion с помощью ProxyCommand 