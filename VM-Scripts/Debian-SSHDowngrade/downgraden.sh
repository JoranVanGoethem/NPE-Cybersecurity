#!/bin/bash

# Zorg dat je root bent
if [ "$EUID" -ne 0 ]; then
  echo "Voer dit script uit als root"
  exit
fi

# Vereiste pakketten installeren
apt install -y build-essential zlib1g-dev libssl-dev libpam0g-dev wget

# Oude OpenSSH versie downloaden en compileren
cd /usr/local/src
wget https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.5p1.tar.gz
tar xzf openssh-8.5p1.tar.gz
cd openssh-8.5p1
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam
make && make install

# Configuratie aanpassen om kwetsbaarheid mogelijk te maken
sed -i 's/#LoginGraceTime 2m/LoginGraceTime 10/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh

echo "OpenSSH 8.5p1 geïnstalleerd en geconfigureerd"
