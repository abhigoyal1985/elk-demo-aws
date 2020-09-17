output "ip_address_public_kibana" {
	value = aws_instance.kibana.*.public_ip
}

output "ip_address_private_master" {
	value = aws_instance.master.*.private_ip
}

output "ip_address_private_data" {
        value = aws_instance.node.*.private_ip
}

output "ip_address_public_master" {
        value = aws_instance.master.*.public_ip
}

output "ip_address_public_data" {
        value = aws_instance.node.*.public_ip
}

