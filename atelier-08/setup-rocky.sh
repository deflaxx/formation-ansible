#!/bin/bash
# 
# setup-rocky.sh

sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' \
  /etc/ssh/sshd_config
sed -i -e 's/PasswordAuthentication no/#PasswordAuthentication no/g' \
  /etc/ssh/sshd_config
systemctl reload sshd

exit 0
