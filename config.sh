# gcloud compute ssh strongswan-vm --zone=us-east4-a --tunnel-through-iap
sudo bash

# install strongswan
apt update
apt install strongswan charon-systemd strongswan-swanctl -y
apt install bird2 -y

# create xfrm link, "if_id 42" will be referenced in strongswan conf
ip link add ipsec0 type xfrm dev ens4 if_id 42
# WIP route bird to xfrm link
ip link set ipsec0 up
ip route add 169.254.0.1/32 dev ipsec0
# replace 10.2.0.2 with local ip of strongswan vm
ip addr add 10.2.0.2/32 remote 169.254.0.1/30 dev ipsec0
ip addr add 169.254.0.2/30 remote 169.254.0.1/30 dev ipsec0

# customize and copy swan_gcp.conf to /etc/swanctl/conf.d/swan_gcp.conf
# customize and copy bird.conf to /etc/bird/bird.conf

# strongswan commands

systemctl restart strongswan

systemctl status strongswan

swanctl --list-sas

swanctl --log

# bird commands

systemctl restart bird

systemctl status bird

birdc show route

journalctl -u bird -f