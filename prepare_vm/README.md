```
apt update
apt upgrade
apt install -y git pkg-config libssl-dev curl mc argon2 ca-certificates net-tools build-essential

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
apt update

apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

echo "{" > /etc/docker/daemon.json
echo '   "dns": ["8.8.8.8", "8.8.4.4"]' >> /etc/docker/daemon.json 
echo "}" >> /etc/docker/daemon.json 

systemctl restart docker
systemctl enable docker

sed -i -e 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
ufw reload
iptables -t nat -A POSTROUTING ! -o docker0 -s 172.18.0.0/16 -j MASQUERADE

ufw allow in on docker0
ufw route allow in on docker0
ufw route allow out on docker0

ufw allow 443
ufw allow 80
ufw allow 22
ufw enable

curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
bash -c "export NVM_DIR=\"\$HOME/.nvm\" && [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\" && nvm install 20 && nvm use 20"

curl -fsSL https://go.dev/dl/go1.25.5.linux-amd64.tar.gz -o /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz

mkdir -p $HOME/go
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> ~/.bashrc

mkdir /docker/nginx

# Put the certs where they need to be
#/docker/nginx/key.pem
#/docker/nginx/crt.pem

mkdir -p /docker/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
chown -R 2000:2000 /docker/mattermost
```
