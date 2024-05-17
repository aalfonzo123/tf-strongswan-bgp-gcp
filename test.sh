# gcloud compute ssh test-vm --zone=us-east4-a --tunnel-through-iap
# replace 10.2.0.2 with local ip of strongswan vm
# both pings should work
ping 10.2.0.2
ping www.google.com

# now add:
# route 0.0.0.0/0 via 169.254.0.2;
# to bird.conf static routes 
# systemctl restart bird
# check routes on gcp
# internet ping should not work
ping 10.2.0.2
ping www.google.com


# now add:
# bgp_med = 1500;
# to bird.conf local_filter
# systemctl restart bird
# check routes on gcp
# both pings should work
ping 10.2.0.2
ping www.google.com
