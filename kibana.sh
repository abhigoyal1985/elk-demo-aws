#Install Kibana
################################
cluster_ip=`cat /home/centos/private_ip.txt`
echo $cluster_ip

sudo setenforce 0
sudo yum install wget vim telnet nmap zip unzip -y
sudo yum install epel-release -y

cd /opt
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.5.4-linux-x86_64.tar.gz
tar -xzf kibana-6.5.4-linux-x86_64.tar.gz
mv kibana-6.5.4-linux-x86_64 kibana-6.5.4
rm -f kibana-6.5.4-linux-x86_64.tar.gz

#kibana.yml config
sudo cp /opt/kibana-6.5.4/config/kibana.yml /opt/kibana-6.5.4/config/kibana.yml.bak
echo "
server.host: \"0.0.0.0\"
elasticsearch.url: \"http://$cluster_ip:9200\"
" | sudo tee /opt/kibana-6.5.4/config/kibana.yml

echo "
[Unit]
Description=Kibana
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/opt/kibana-6.5.4/bin/kibana

[Install]
WantedBy=default.target
" | sudo tee /etc/systemd/system/kibana.service


sudo systemctl daemon-reload
sudo systemctl start kibana
sudo systemctl enable kibana
################################
