## Installation
1. Ubuntu APT => 2.10.8
2. Ubuntu PPA => 2.17.8
3. Rocky PIP => 2.15.13

## Authentification
Modifier le /etc/hosts en ajoutant ceci :
```
127.0.0.1      localhost.localdomain  localhost
192.168.56.10  control.sandbox.lan    control
192.168.56.20  target01.sandbox.lan   target01
192.168.56.30  target02.sandbox.lan   target02
192.168.56.40  target03.sandbox.lan   target03
```
Déployer les clés :
```bash
ssh-keygen
ssh-copy-id vagrant@target01
ssh-copy-id vagrant@target02
ssh-copy-id vagrant@target03
```
Tester la commande et obtenir le résultat suivant :
```bash
vagrant@control:~$ ansible all -i target01,target02,target03 -m ping
target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

## Configuration
Modifier le /etc/hosts en ajoutant ceci :
```
127.0.0.1      localhost.localdomain  localhost
192.168.56.10  control.sandbox.lan    control
192.168.56.20  target01.sandbox.lan   target01
192.168.56.30  target02.sandbox.lan   target02
192.168.56.40  target03.sandbox.lan   target03
```
Déployer les clés :
```bash
ssh-keygen
ssh-copy-id vagrant@target01
ssh-copy-id vagrant@target02
ssh-copy-id vagrant@target03
```
Installer Ansible :
```bash
sudo apt update
sudo apt-add-repository ppa:ansible/ansible
sudo apt install -y ansible
```
Tester le ping sans configuration :
```bash
vagrant@control:~$ ansible all -i target01,target02,target03 -m ping
[WARNING]: Platform linux on host target03 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Platform linux on host target01 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Platform linux on host target02 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
```
Créer un dossier et un fichier de configuration :
```bash
mkdir ~/monprojet
touch ~/monprojet/ansible.cfg
```
Vérifier que le fichier est bien pris en compte :
```bash
vagrant@control:~$ cd monprojet
vagrant@control:~/monprojet$ ansible --version | head -n 2
ansible [core 2.17.8]
  config file = /home/vagrant/monprojet/ansible.cfg
```
Ajouter cette configuration au ansible.cfg :
```
[defaults]
inventory = ./hosts
log_path = ~/journal/ansible.log
```
Créer le dossier ~/journal :
```bash
mkdir ~/journal
```
Tester la journalisation :
```bash
vagrant@control:~/monprojet$ ansible all -i target01,target02,target03 -m ping
***
vagrant@control:~/monprojet$ cat ~/journal/ansible.log 
2025-02-12 10:11:39,875 p=3915 u=vagrant n=ansible | [WARNING]: Platform linux on host target02 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.

2025-02-12 10:11:39,876 p=3915 u=vagrant n=ansible | target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
2025-02-12 10:11:39,886 p=3915 u=vagrant n=ansible | [WARNING]: Platform linux on host target01 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.

2025-02-12 10:11:39,887 p=3915 u=vagrant n=ansible | target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
2025-02-12 10:11:39,892 p=3915 u=vagrant n=ansible | [WARNING]: Platform linux on host target03 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.

2025-02-12 10:11:39,893 p=3915 u=vagrant n=ansible | target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
```
Créer un fichier ~/monprojet/hosts et lui ajouter cette configuration :
```
[testlab]
target01
target02
target03

[testlab:vars]
ansible_user=vagrant
```
Tester le ping vers All : 
```bash
vagrant@control:~/monprojet$ ansible all -m ping
[WARNING]: Platform linux on host target02 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Platform linux on host target03 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Platform linux on host target01 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
```
Définir l'élévation des droits pour l'utilisateur vagrant en ajoutant ceci dans ./hosts :
```
ansible_become=yes
```
Afficher la première ligne du fichier /etc/shadow sur tous les Target Hosts :
```bash
vagrant@control:~/monprojet$ ansible all -a "head -n 1 /etc/shadow"
[WARNING]: Platform linux on host target03 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target03 | CHANGED | rc=0 >>
root:*:19769:0:99999:7:::
[WARNING]: Platform linux on host target02 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target02 | CHANGED | rc=0 >>
root:*:19769:0:99999:7:::
[WARNING]: Platform linux on host target01 is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
target01 | CHANGED | rc=0 >>
root:*:19769:0:99999:7:::
```

## Idempotence
Installer des paquets via ansible :
```bash
ansible all -m package -a "name=tree"
ansible all -m package -a "name=git"
ansible all -m package -a "name=nmap"
```
Désinstaller les paquets :
```bash
ansible all -m package -a "name=tree state=absent"
ansible all -m package -a "name=git state=absent"
ansible all -m package -a "name=nmap state=absent"
```
Copie de fichier :
```bash
ansible all -m copy -a "src=/etc/fstab dest=/tmp/test3.txt mode=0644"
```
Suppression de fichier :
```bash
ansible all -m file -a "path=/tmp/test3.txt state=absent"
```
Afficher l'espace disque :
```bash
ansible all -m command -a "df -h /"
```
On remarque que si on lance consécutivement l'action x fois, le résultat ne change pas pour un target host donné. Cela confirme que la commande n’altère pas l’état du système (elle est purement informative)

## Playbooks
Playbook pour Debian :
```yaml
- name: Installer Apache sur Debian
  hosts: debian
  tasks:
    - name: Update cache information
      apt:
        update_cache: true

    - name: Installer Apache
      apt:
        name: apache2
        state: present

    - name: Démarrer et activer Apache
      service:
        name: apache2
        state: started
        enabled: true

    - name: Définir la page d'accueil
      copy:
        dest: /var/www/html/index.html
        mode: 0664
        content : |
          <!doctype html>
          <html>
            <head>
              <meta charset="utf-8">
              <title>Test</title>
            </head>
            <body>
              <h1>DEBIAN WEB SERVER CONFIGURED BY ANSIBLE</h1>
            </body>
          </html>
```
Playbook pour Rocky :
```yaml
- name: Installer Apache sur Rocky Linux
  hosts: rocky
  tasks:
    - name: Installer Apache
      dnf:
        name: httpd
        state: present

    - name: Démarrer et activer Apache
      service:
        name: httpd
        state: started
        enabled: true

    - name: Définir la page d'accueil
      copy:
        dest: /var/www/html/index.html
        mode: 0644
        content : |
         <!doctype html>
         <html>
           <head>
             <meta charset="utf-8">
             <title>Test</title>
           </head>
           <body>
               <h1>ROCKY WEB SERVER CONFIGURED BY ANSIBLE</h1>
           </body>
         </html>
```
Playbook pour Suse :
```yaml
- name: Installer Apache sur SUSE
  hosts: suse
  tasks:
    - name: Installer Apache
      zypper:
        name: apache2
        state: present

    - name: Démarrer et activer Apache
      service:
        name: apache2
        state: started
        enabled: true

    - name: Définir la page d'accueil
      copy:
        dest: /srv/www/htdocs/index.html
        mode: 0644
        content : |
          <!doctype html>
          <html>
            <head>
              <meta charset="utf-8">
              <title>Test</title>
            </head>
            <body>
                <h1>SUSE WEB SERVER CONFIGURED BY ANSIBLE</h1>
            </body>
          </html>
```
Exemple de vérification du bon fonctionnement du Playbook :
```bash
[vagrant@ansible playbooks]$ curl debian
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Test</title>
  </head>
  <body>
    <h1>DEBIAN WEB SERVER CONFIGURED BY ANSIBLE</h1>
  </body>
</html>
```