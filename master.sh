#####################################################################
#!/bin/bash

#Install base Packages
sudo setenforce 0
sudo yum install wget vim telnet nmap zip unzip -y
sudo yum install java-1.8.0-openjdk -y

#Install elastic Search
sudo mkdir -p /opt/elasticsearch-6.5.4
cd /opt/elasticsearch-6.5.4
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.rpm
sudo rpm -ivh elasticsearch-6.5.4.rpm

sudo /bin/systemctl daemon-reload

#Install ec2 discovery plugin
echo "y" | sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2

sudo systemctl enable elasticsearch.service

#####################################################################

#elasticsearch.yml configuration

sudo cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch-bak.yml

echo "
cluster.name: usr-search-es64
node.name: ${HOSTNAME}

node.master: true
node.data: false
node.ingest: false

discovery.zen.minimum_master_nodes: 1

network.host: "0.0.0.0"
http.bind_host: "0.0.0.0"
network.bind_host: "0.0.0.0"

path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

discovery.zen.hosts_provider: "ec2"

cloud.node.auto_attributes: true
cluster.routing.allocation.awareness.attributes: "aws_availability_zone"
discovery.ec2.tag.es_cluster: "demo-elasticsearch"
discovery.ec2.endpoint: "ec2.us-east-1.amazonaws.com"

"  | sudo tee /etc/elasticsearch/elasticsearch.yml

sudo systemctl start elasticsearch.service

