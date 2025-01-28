# wg_external
1. Скачать wg.sh и docker-compose.yaml в папку /docker-compose
2. В файле docker-compose.yaml указать логин\пароль для консоли и для почты
3. Выполнить bash ./wg.sh
4. Зайти в личный кабинет (http://YOURE_IP:8123/admin/) и добавить в интерфейс wg0:
   a. Public Endpoint for Clients
   b. DNS Servers
   c. Post Up (iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE)
   d. Post Down (iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE)
   где ens3 - имя snat интерфейса
