#!/bin/bash

#---Install Latest Docker CE---#
install_docker() {
    curl -fsSL get.docker.com -o /tmp/get-docker.sh
    sed -i 's/edge/stable/' /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    usermod -aG docker ubuntu
    systemctl enable docker
}

#---Setup Docker for monitoring---#
setup_docker() {
cat << _EOF_ >> /etc/docker/daemon.json
{
    "metrics-addr" : "0.0.0.0:4999",
	"experimental": true
}
_EOF_
    #Enable IPVS
    modprobe xt_ipvs
    service docker restart
}

#---Install Node Exporter---#
install_node_exporter() {
    curl -L https://github.com/prometheus/node_exporter/releases/download/v0.15.1/node_exporter-0.15.1.linux-amd64.tar.gz -o /tmp/node_exporter.tar.gz
    cd /tmp && tar -xzf /tmp/node_exporter.tar.gz
    cp node_exporter-0.15.1.linux-amd64/node_exporter /usr/local/bin
    curl -L https://raw.githubusercontent.com/arush-sal/prom-stack/master/node_exporter.service.systemd \
            -o /etc/systemd/system/node_exporter.service
    chmod +x /etc/systemd/system/node_exporter.service
    systemctl daemon-reload
    systemctl enable node_exporter.service
    service node_exporter start
}


install_awscli() {
    apt-get update
    apt-get install python-pip -y
    pip install --upgrade pip
    pip install awscli
    mkdir -p /root/.aws/
    mkdir -p /home/ubuntu/.aws/

cat << _EOF_ >> /root/.aws/config
[default]
region = us-east-1
_EOF_

cat << _EOF_ >> /home/ubuntu/.aws/config
[default]
region = us-east-1
_EOF_
}

install_clamav() {
    apt-get install clamav-daemon -y
    sed -i '/^Example/d;s/#TCPSocket/TCPSocket/g' /etc/clamd.d/scan.conf
    sed -i '/^Example/d' /etc/freshclam.conf
    echo "0 9 6 * * freshclam" | crontab -
}



start() {
    install_node_exporter
    install_awscli
    install_docker
    setup_docker
    install_clamav
    
}

start
