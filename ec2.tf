## Master Node

resource "aws_instance" "master" {
	ami = lookup(var.ami, var.region)
	instance_type = var.instance-type-master
	count = var.master-count
	tenancy       = "default"
	key_name      = var.key
    vpc_security_group_ids = [aws_security_group.allow.id]
	iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
	root_block_device {
		volume_size = "8"
		volume_type = "gp2"
		delete_on_termination = true
	}

	provisioner "file" {
   		source      = "master.sh"
    	destination = "/tmp/master.sh"
  	}

  	provisioner "remote-exec" {
    		inline = [
	                "sudo hostnamectl set-hostname demo-elk-master-0${count.index}",
      				"sudo sh /tmp/master.sh",
   	 		]
  	}
	connection {
		    host        = self.public_ip
    		user        = "centos"
			type        = "ssh"
			password    = ""
    		private_key = file(var.pubkey)
  	}
		tags = {
   	 		Name = "demo-elk-master-0${count.index}"
			es_cluster = "demo-elasticsearch"
  	}
}


## Master Node END


## Data Node Begin

resource "aws_instance" "node" {
	ami = lookup(var.ami, var.region)
	instance_type = var.instance-type-node
	count = var.node-count
	tenancy       = "default"
	key_name      = var.key
    vpc_security_group_ids = [aws_security_group.allow.id]
	iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
	root_block_device {
		volume_size = "8"
		volume_type = "gp2"
		delete_on_termination = true
	}

	provisioner "file" {
   		source      = "node.sh"
    		destination = "/tmp/node.sh"
  	}

  	provisioner "remote-exec" {
    		inline = [
	                "sudo hostnamectl set-hostname demo-elk-node-0${count.index}",
      			"sudo sh /tmp/node.sh",
   	 		]
  	}

	connection {
			host        = self.public_ip
            user        = "centos"
			type        = "ssh"
			password    = ""
    		private_key = file(var.pubkey)
  	}
	
	tags = {
   	 	Name = "demo-elk-node-0${count.index}"
		es_cluster = "demo-elasticsearch"
  	}
}



## Data Node End

## Kibana Begin

resource "aws_instance" "kibana" {
	ami = lookup(var.ami, var.region)
	instance_type = var.instance-type-kibana
	tenancy       = "default"
	key_name      = var.key
    vpc_security_group_ids = [aws_security_group.allow.id]
	root_block_device {
		volume_size = "8"
		volume_type = "gp2"
		delete_on_termination = true
	}
	depends_on = [aws_instance.master]
	#provisioner "file" {
    #            source      = "nginx.conf"
    #            destination = "/tmp/nginx.conf"
    #    }

	provisioner "file" {
   		source      = "kibana.sh"
    	destination = "/tmp/kibana.sh"
	
    connection {
			host        = self.public_ip
    		user        = "centos"
			type        = "ssh"
			password    = ""
    		private_key = file(var.pubkey)
  	    }
  	}
	


  	provisioner "remote-exec" {
    	inline = [
        "sudo echo ${aws_instance.master[0].private_ip} demo-elastic >> private_ip.txt",
	    "sudo hostnamectl set-hostname demo-elk-kibana",
      	"sudo sh /tmp/kibana.sh",
   		]

	connection {
			host        = self.public_ip
    		user        = "centos"
			type        = "ssh"
			password    = ""
    		private_key = file(var.pubkey)
  	}
  	}

	
	
	tags = {
   	 	Name = "demo-elk-kibana"
		es_cluster = "demo-elasticsearch"
  	}
}

## Kibana END