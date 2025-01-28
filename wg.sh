#########create folders
mkdir /docker-compose
mkdir /docker-compose/wg

###############install soft
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt install docker-compose-plugin -y
apt install -y wireguard

#############configuring wireguard
cd /etc/wireguard/
rm wg0.conf
wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey

#################create interface config
private=$(cat /etc/wireguard/privatekey)
echo $private
echo "[Interface]" >> /etc/wireguard/wg0.conf
echo "PrivateKey = "$private >> /etc/wireguard/wg0.conf
echo "Address = 10.1.0.1/24" >> /etc/wireguard/wg0.conf
echo "ListenPort = 51830" >> /etc/wireguard/wg0.conf
#echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE" >> /etc/wireguard/wg0.conf
#echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE" >> /etc/wireguard/wg0.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sudo sysctl -p

#####start wireguard
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
systemctl status wg-quick@wg0.service

cp /docker-compose/docker-compose.yaml /docker-compose/wg/docker-compose.yaml
cd /docker-compose/wg
docker compose up -d
