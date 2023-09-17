#!/bin/bash
sudo -i
sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo useradd otusadm && sudo useradd otus
echo "Otus2023" | sudo passwd --stdin otusadm && echo "Otus2023" | sudo passwd --stdin otus
groupadd -f admin
usermod otusadm -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin
cat <<'EOF' >> /usr/local/bin/login.sh
!/bin/bash
if [ $(date +%a) = "Sat" ] || [ $(date +%a) = "Sun" ]; then
 if getent group admin | grep -qw "$PAM_USER"; then
        
        exit 0
      else
        
        exit 1
    fi
  else
    exit 0
fi
EOF
chmod +x /usr/local/bin/login.sh
sed -i "2i auth  required  pam_script.so  /usr/local/bin/login.sh"  /etc/pam.d/sshd
systemctl restart sshd
date 082712302022.00
