#!/bin/bash
# 
# setup-ansible.sh

cp -vf /vagrant/hosts /etc/

dnf install -y epel-release
dnf install -y ansible vim-enhanced nano sshpass

runuser -l vagrant -c "echo -e '\n\n\n' | ssh-keygen -t rsa -b 4096"

for HOST in rocky debian suse
do
  runuser -l vagrant -c "ssh-keyscan -t rsa ${HOST} >> ~/.ssh/known_hosts"
  runuser -l vagrant -c "ssh-keyscan -t rsa ${HOST}.sandbox.lan >> ~/.ssh/known_hosts"
  runuser -l vagrant -c "sshpass -p vagrant ssh-copy-id vagrant@${HOST}"
done

mkdir -pv /home/vagrant/ansible/projets/ema
mkdir -v /home/vagrant/logs
cp -vf /vagrant/{ansible.cfg,inventory} /home/vagrant/ansible/projets/ema/
chown -R vagrant:vagrant /home/vagrant/{ansible,logs}

exit 0
