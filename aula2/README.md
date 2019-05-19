Scenario Docker - Docker Swarm
Lab Disponível em: https://www.profissionaisti.com.br/2017/07/portainer-orquestrando-containers-em-um-cluster-docker-swarm/


Três VMs 




Passo 1: Clonar deste repositório o VagrantFile que será utilizado
$ git clone http://github.com/andrebeltrami/slice-enablersAula2


containerhost01 - 
containerhost02 - 
containerhost03 -


Passo 2: Checar o arquivo VagrantFile baixado 
$ vagrant status 
$ vagrant up 
PS: Lembrar de selecionar a Interface de rede correta




Passo 2.1: Abrir um terminal para cada máquina criada
Checar o IP que cada uma das máquinas pegou e anotar 
$ vagrant ssh containerhost01
$ vagrant ssh containerhost02
$ vagrant ssh containerhost03
$ ip a 




Passo 3: Instalação do DOCKER em cada uma das vms


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








Passo 4: Sai de uma das vms 
Na pasta do VagrantFile
$ vagrant halt
$ vagrant up 


Passo 5: SSH novamente nas três VMs para checar a Instalação do Docker


$ docker ps  -a
$ docker info


Passo 6: Iniciando o Docker Swarm no containerhost01


$ docker swarm init --advertise-addr <IP DO containerhost01>:2377


Ele vai gerar uma saída parecida com esta. Cada grupo terá uma saída diferente.


$ docker swarm join –token SWMTKN-1-41eozb4h6ucm58pwv6zxvllhggniv6kbo92hyyhja9z07whmtb-62q0t8pc373ff576xlbxp8bjj 192.168.1.10:2377


PS: Guardem este comando gerado a partir do docker swarm init 


Passo 7: Adicionar os Workers no Cluster. Execute o comando gerado acima nas máquinas containerhost02 e containerhost03


$ docker swarm join –token SWMTKN-1-41eozb4h6ucm58pwv6zxvllhggniv6kbo92hyyhja9z07whmtb-62q0t8pc373ff576xlbxp8bjj 192.168.1.10:2377


A seguinte mensagem deve aparecer:  This node joined a swarm as a worker.


Passo 8: Criando uma Rede para este nosso Cluster no containerhost01


$ docker network create -d overlay --subnet 10.0.10.0/24 ClusterNet
$ docker network ls 


Execute o comando $ docker network ls nos nós workers e note que a rede não foi adicionada nos Workers ainda.


Passo 9: Criação do Serviço com Apache que atuará no cluster docker swarm que criamos


$ docker service create --name webservice1 --network ClusterNet --replicas 3 -p 5001:80 francois/apache-hostname


$ docker service ls 


$ docker ps


$ curl --connect-timeout 3 http://<IP DO containerhostx>:5001


Liste em cada um dos nós os containers executando
Teste através do curl o servidor WEB 


Passo 10: Testando o Balanceamento de Carga do docker Swarm
Criar um script 


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


Colar dentro do arquivo. Lembre de alterar os ips em hosts, para os IPs das VMs de vocês ( containerhost01, containerhost02, containerhost03 )


Passo 11: Dar permissão de execução ao Script e rodá-lo no containerhost01


$ chmod +x testLB.sh
$ ./testLB.sh


Verificar a saída do comando


Passo 12: Imaginando que nossos serviços estão recebendo muitas requisições e estão sobrecarregados, iremos agora fazer um upgrade na quantidade de replicas deste serviço


$ docker service scale webservice1=10
$ docker service ps
$ docker ps 
(Em cada um dos nós)




Part 2: 
Kubernetes (Minikube) Exemplos simples
Adaptado de : https://medium.com/@claudiopro/getting-started-with-kubernetes-via-minikube-ada8c7a29620


Passo 1: Vamos utilizar a mesma VM que criamos anteriormente, a VM containerhost01.
As outras podemos desligar 


$ vagrant halt containerhost02
$ vagrant halt containerhost03


Passo 2: Instalação do Minikube


$ wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64


$ chmod +x minikube-linux-amd64


$ sudo mv minikube-linux-amd64 /usr/local/bin/minikube


Passo 3: Instalação do Kubectl


$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -


$ echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


$ sudo apt update


$ sudo apt -y install kubectl


Para checar a instalação execute:


$ minikube version
$ kubectl version


Passo 4: Iniciando o Minikube


$ sudo minikube start --memory=4096 --vm-driver=none --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf


Ao terminar execute


$ sudo kubectl get pod --all-namespaces




Passo 5: Fazendo o deployment de uma pod 




$ kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
deployment "hello-minikube" created


Para testar:
$ kubectl get pods
$ kubectl get deployments


Passo 6: Expondo o Serviço


$ kubectl expose deployment hello-minikube --type=NodePort
service "hello-minikube" exposed


Para testar:
$ kubectl get services


Passo 7: Testando o serviço criado


$ minikube service hello-minikube --url http://<IP DO containerhost01>:31226
$ curl $(sudo minikube service hello-minikube --url)


Passo 8: Encerrando o service e o deployment


$ kubectl delete service,deployment hello-minikube


Para checar:
$ kubectl get pods
$ kubectl get services
























Passo 9: Criando uma aplicação JS para rodar no nosso cluster kubernetes (minikube)


$ mkdir hello-node && cd hello-node && touch Dockerfile server.js
$ vi server.js


var http = require('http');
var handleRequest = function(request, response) {
  response.writeHead(200);
  response.end('Alou Mundo da Turma de Topicos em Redes!');
};
var helloServer = http.createServer(handleRequest);
helloServer.listen(8080);


Passo 10: Criar a imagem a partir de um Docker File


$ vi Dockerfile


FROM node:4.4
EXPOSE 8080
COPY server.js .
CMD node server.js


Passo 11: Validando as variáveis de ambiente


$ eval $(sudo minikube docker-env)


Passo 12: Docker build na nossa aplicação JS 


$ docker build -t hello-node:v1 .


Para checar:
$ docker images


Passo 13: Fazendo o deployment da Aplicação 


$ kubectl run hello-node --image=hello-node:v1 --port=8080
deployment "hello-node" created


Para checar a criação da Pod
$ kubectl get pods
$ kubectl get deployments


Passo 14: Expondo a aplicação e Testando 


$ kubectl expose deployment hello-node --type=NodePort
service "hello-node" exposed
$ kubectl get services
$ curl $(sudo minikube service hello-node --url)