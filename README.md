# tf-strongswan-bpg-gcp

Using terraform, this repository creates:
* A VM with a public IP, that will host strongswan (VPN) and bird (BGP)
* A Cloud VPN tunnel and bgp session to connect to strongwan+bird
* A test VM on a separate, isolated VPC that's connected to the VPN

This is just a sample to show that it does work. It also can be used for priority/bgp_med experiments.