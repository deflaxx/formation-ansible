#!/bin/bash
# 
# setup-ansible.sh

cp -vf /vagrant/hosts /etc/

apt-get update
apt-get install -y ansible sshpass direnv yamllint

runuser -l vagrant -c "echo -e '\n\n\n' | ssh-keygen -t rsa -b 4096"

for HOST in target01 target02 target03
do
  runuser -l vagrant -c "ssh-keyscan -t rsa ${HOST} >> ~/.ssh/known_hosts"
  runuser -l vagrant -c "ssh-keyscan -t rsa ${HOST}.sandbox.lan >> ~/.ssh/known_hosts"
  runuser -l vagrant -c "sshpass -p vagrant ssh-copy-id vagrant@${HOST}"
done

echo 'eval "$(direnv hook bash)"' >> /home/vagrant/.bashrc

mkdir -pv /home/vagrant/ansible/projets/ema/playbooks
mkdir -v /home/vagrant/logs
cp -vf /vagrant/{ansible.cfg,inventory} /home/vagrant/ansible/projets/ema/
echo 'export ANSIBLE_CONFIG=$(expand_path ansible.cfg)' > \
  /home/vagrant/ansible/projets/ema/.envrc
chown -R vagrant:vagrant /home/vagrant/{ansible,logs}
runuser -l vagrant -c "direnv allow /home/vagrant/ansible/projets/ema"

exit 0
