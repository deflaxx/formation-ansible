## Installation
1. Version 2.10.8
2. Version 2.17.8
3. Version 2.15.13

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
```
ssh-keygen
ssh-copy-id vagrant@target01
ssh-copy-id vagrant@target02
ssh-copy-id vagrant@target03
ansible all -i target01,target02,target03 -m ping
```