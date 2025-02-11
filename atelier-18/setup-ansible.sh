#!/bin/bash
# 
# setup-ansible.sh

cp -vf /vagrant/hosts /etc/

dnf install -y epel-release
dnf install -y ansible vim-enhanced nano sshpass yamllint

runuser -l vagrant -c "echo -e '\n\n\n' | ssh-keygen -t rsa -b 4096"

for HOST in rocky debian suse ubuntu
do
  runuser -l vagrant -c "ssh-keyscan -t rsa ${HOST} >> ~/.ssh/known_hosts"
  runuser -l vagrant -c "ssh-keyscan -t rsa ${HOST}.sandbox.lan >> ~/.ssh/known_hosts"
  runuser -l vagrant -c "sshpass -p vagrant ssh-copy-id vagrant@${HOST}"
done

wget https://github.com/direnv/direnv/releases/download/v2.35.0/direnv.linux-amd64 \
  -O /usr/local/bin/direnv
chmod 0755 /usr/local/bin/direnv
echo 'eval "$(direnv hook bash)"' >> /home/vagrant/.bashrc

mkdir -pv /home/vagrant/ansible/projets/ema/
mkdir -v /home/vagrant/logs
cp -vf /vagrant/{ansible.cfg,inventory} /home/vagrant/ansible/projets/ema/
cp -Rv /vagrant/playbooks /home/vagrant/ansible/projets/ema/
echo 'export ANSIBLE_CONFIG=$(expand_path ansible.cfg)' > \
  /home/vagrant/ansible/projets/ema/.envrc
chown -R vagrant:vagrant /home/vagrant/{ansible,logs}
runuser -l vagrant -c "direnv allow /home/vagrant/ansible/projets/ema"

exit 0
