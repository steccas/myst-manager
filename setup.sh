#!/bin/bash
chmod -R 640 ./envs
chmod 740 ./envs

# WG
apt update
apt install wireguard
wg genkey | sudo tee /etc/wireguard/private.key
chmod go= /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
nano /etc/sysctl.conf
sysctl -p

write_pid(){
    filename=$1
    thekey=$2
    newvalue=$3

    if ! grep -R "^[#]*\s*${thekey}=.*" $filename > /dev/null; then
    echo "APPENDING because '${thekey}' not found"
    echo "$thekey=$newvalue" >> $filename
    else
    echo "SETTING because '${thekey}' found already"
    sed -ir "s/^[#]*\s*${thekey}=.*/$thekey=$newvalue/" $filename
    fi
}

# node
mkdir -p /etc/mysterium-node
mkdir -p /var/lib/mysterium-node

# proxy
useradd --system --no-create-home --shell=/sbin/nologin proxy_m
uid_proxy=$(id -u proxy_m)
gid_proxy=$(id -g proxy_m)

envfile=./envs/.env_proxy

write_pid $envfile PUID $uid_proxy
write_pid $envfile PGID $gid_proxy

mkdir /etc/swag

# dashboard
useradd --system --no-create-home --shell=/sbin/nologin dash_m
uid_proxy=$(id -u dash_m)
gid_proxy=$(id -g dash_m)

envfile=./envs/.env_dashboard

write_pid $envfile PUID $uid_proxy
write_pid $envfile PGID $gid_proxy

mkdir /etc/heimdall

# proxy
# useradd --system --no-create-home --shell=/sbin/nologin proxy_n
# uid_proxy=$(id -u proxy_n)
# gid_proxy=$(id -g proxy_n)

# envfile=./envs/.env_proxy

# write_pid $envfile PUID $uid_proxy
# write_pid $envfile PGID $gid_proxy

# mkdir /etc/proxy

#docker-compose up -d

exit 0