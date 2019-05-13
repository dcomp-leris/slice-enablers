# Explicando virtualização com o auxílio do Vagrant

## Descrição dos arquivos

Vários arquivos com cenários distintos que serão explicados ao longo desta página.

A maioria destes exemplos de configuração foi retirada do próprio site do [Vagrant](https://vagrantup.com).

## Nota sobre o Protocolo SSH

Esta página contém os arquivos necessários para acessar as VMs na Cloud UFSCar, utilizando para isto o [Protocolo SSH](https://tools.ietf.org/html/rfc4254).

SSH é um importante protocolo para acesso remoto a outras máquinas, possibilitando a administração remota de servidores em outras localidades.

O SSH não é foco desta disciplina e um detalhamento melhor da sua utilização pode ser encontrado [aqui](https://www.openssh.com).

Além de ser até [famoso](https://i.redd.it/qhs5v36qvnr11.jpg)!!! :)

## Script para acessar a VM

### acessar.sh
```markdown
#!/bin/bash

ssh -i cloud_ufscar_rsa.dms ubuntu@`cat lista-vms.txt | grep -w vm-$1 | cut -d " " -f 3`
```

### Exemplo de como usar o script
```markdown
$ bash acessar.sh NUMERO_DO_GRUPO
```
