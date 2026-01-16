docker network create mattermost-network
snetz=`docker network inspect survey-network | grep "Subnet"  | sed s/" "/""/g | sed s/"\,"/""/g | sed s/":"/"\n"/g  | grep -v "Subnet" | sed s/'"'/''/g`
nid=`docker network ls | grep survey-network | awk '{print $1}'`

ufw allow in on br-$nid
ufw route allow in on br-$nid
ufw route allow out on br-$nid
iptables -t nat -A POSTROUTING ! -o br-$nid -s $snetz -j MASQUERADE
echo Custom NAT rules for /etc/ufw/before.rules
echo -A POSTROUTING ! -o br-$nid -s $snetz -j MASQUERADE

