## Aula Prática 2 - Docker Swarm e Kubernetes!

Passo a Passo do Hands-On de Docker Swarm e Kubernetes para a disciplina de Tópicos Avançados em Redes de Computadores e Sistemas Distribuídos 2019. 


## Hands-On 2: Kubernetes (Minikube)
Neste primeiro Hands-On iremos instalar e testar VIM Kubernetes usando a sua implementação de testes Minikube. 

##### Este tutorial foi adaptado de: https://www.profissionaisti.com.br/2017/07/portainer-orquestrando-containers-em-um-cluster-docker-swarm/

### Passo 1: 
Clonar deste repositório o VagrantFile que será utilizado. 

```markdown
$ git clone https://github.com/dcomp-leris/slice-enablers.git
$ cd slice-enablers/aula2
$ vagrant status 
```

### Passo 2:
Vamos olhar o conteúdo do Vagrantfile que iremos utilizar e então iniciar as VMs.

```markdown
$ vi Vagrantfile
$ vagrant up 
```

### Passo 3:
Abram três terminais, loguem na VM referente ao grupo de vocês. 
Acessem cada uma das VMs criadas via Vagrantfile. 

```markdown
$ vagrant ssh containerhost01
$ vagrant ssh containerhost02
$ vagrant ssh containerhost03
```

### Passo 4:
Instalação do Docker em cada uma das três VMs.

```markdown
$ sudo apt update
$ sudo apt upgrade
$ sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo apt-key fingerprint 0EBFCD88
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt update
$ sudo apt -y install docker-ce docker-ce-cli containerd.io
$ sudo systemctl start docker
$ sudo systemctl enable docker
$ sudo gpasswd -a "${USER}" docker
```

### Passo 5: 
Reiniciar as VMs do vagrant. No terminal do containerhost01, digite: 

```markdown
$ exit
$ vagrant halt
$ vagrant up
```

### Passo 6:
Após as VMs terem sido reiniciadas, logue novamente nas três (containerhost01, containerhost02 e containerhost03)
Checando a instalação do Docker e vendo o IP que as VMs iniciaram. **Anotem estes IPs**!

```markdown
$ docker ps  -a
$ docker info
$ ip a
```

### Passo 7:
Iniciando o Docker Swarm Master no **containerhost01** 

```markdown
$ docker swarm init --advertise-addr <IP DO containerhost01>:2377
```
Este comando irá gerar uma saída muito parecida com o comando abaixo. 
**Cada grupo terá uma saída diferente. Guardem este comando.**

```markdown
$ docker swarm join –token SWMTKN-1-41eozb4h6ucm58pwv6zxvllhggniv6kbo92hyyhja9z07whmtb-62q0t8pc373ff576xlbxp8bjj <IP DO Master:Porta>
```

### Passo 8:
Adicionar os Workers no Cluster. Execute o comando gerado acima nas máquinas containerhost02 e containerhost03
A seguinte mensagem deve aparecer: 


```markdown
$ docker swarm join –token SWMTKN-1-41eozb4h6ucm58pwv6zxvllhggniv6kbo92hyyhja9z07whmtb-62q0t8pc373ff576xlbxp8bjj <IP DO Master:Porta>

This node joined a swarm as a worker.
```

### Passo 9:
Checando a criação dos Nodes. Digite no terminal do **containerhost01**.

```markdown
$ docker node ls	
$ docker node inspect
```

### Passo 10:
Criando uma Rede para este nosso Cluster no **containerhost01**.

```markdown
$ docker network create -d overlay --subnet 10.0.10.0/24 ClusterNet
$ docker network ls 
```

Execute o comando $ docker network ls nos nós workers e note que a rede não foi adicionada nos Workers ainda.

### Passo 11:
Criação do Serviço com Apache que será instanciado no cluster docker swarm que criamos.
Liste em cada um dos nós os containers que estão executando.
Teste através do curl os servidores WEB que estão rodando.

```markdown
$ docker service create --name webservice1 --network ClusterNet --replicas 3 -p 5001:80 francois/apache-hostname
$ docker service ls 
$ docker ps
$ curl --connect-timeout 3 http://<IP DO containerhostx>:5001
```

### Passo 12:
Testando o Balanceamento de Carga do docker Swarm através de um Script.

```markdown
$ vi testLB.sh
#!/bin/sh
hosts="200.136.191.76 200.136.191.102 200.136.191.22"
nHosts=`echo $hosts |wc -w`
i=1
clear
while [ 1 ]; do
if [ $i -eq 4 ]; then
i=1
fi
h=`echo $hosts |cut -f$i -d" "`
echo "Web Server: $h"
curl --connect-timeout 3 http://$h:5001
sleep 3
clear
((i=i+1))
done
```

Colar dentro do arquivo. Lembre de alterar os ips em hosts, para os IPs das VMs de vocês ( containerhost01, containerhost02, containerhost03 )

### Passo 13:
Abra um novo Shell e acesse a VM containerhost01.
Então, dê permissão de execução ao Script e execute-o com os seguintes comandos.

```markdown
$ chmod +x testLB.sh
$ ./testLB.sh
```

Verificar a saída do comando. 

### Passo 14:
Imaginando que nossos serviços estão recebendo muitas requisições e estão sobrecarregados.
Iremos agora fazer um upgrade na quantidade de replicas deste serviço.

```markdown
$ docker service scale webservice1=10
$ docker service ps
$ docker ps 
```














