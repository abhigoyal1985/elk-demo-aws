##1. Basic Variables
variable "access" { }
variable "secret" {  }
variable "region" { default = "us-east-1" }
variable "ami" { 
	type = map
	default = {
		us-east-1 = "ami-0083662ba17882949" 
		ap-south-1 = "ami-016ec067d44808c4f"
	} 
}
variable "instance-type-master" {
	default = "t3.medium"
}
variable "instance-type-node" {
        default = "t3.medium"
}
variable "instance-type-kibana" {
	default = "t2.micro"
}
variable "master-count" {
	default = "1"
}
variable "node-count" {
	default = "1"
}
variable "pubkey" {
	default = "~/.ssh/demo.pem"
}
variable "key" {
        default = "demo"
}