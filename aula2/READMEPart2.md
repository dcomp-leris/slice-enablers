## Aula Prática 2 - Docker Swarm e Kubernetes!

Passo a Passo do Hands-On de Docker Swarm e Kubernetes para a disciplina de Tópicos Avançados em Redes de Computadores e Sistemas Distribuídos 2019. 


## Hands-On 2: Kubernetes (Minikube)
Neste primeiro Hands-On iremos instalar e testar VIM Kubernetes usando a sua implementação de testes Minikube. 

##### Este tutorial foi adaptado de: https://medium.com/@claudiopro/getting-started-with-kubernetes-via-minikube-ada8c7a29620

### Passo 1: 
Vamos utilizar a mesma VM que criamos anteriormente, a VM containerhost01.
As outras podemos desligar.

```markdown
$ vagrant halt containerhost02
$ vagrant halt containerhost03
```

### Passo 2:
Instalação do Minikube.

```markdown
$ wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
$ chmod +x minikube-linux-amd64
$ sudo mv minikube-linux-amd64 /usr/local/bin/minikube
```

### Passo 3:
Instalação do kubectl.

```markdown
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$ echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
$ sudo apt update
$ sudo apt -y install kubectl
```

Para checar a instalação execute:

```markdown
$ minikube version
$ kubectl version
```

### Passo 4:
Iniciando o Minikube.

```markdown
$ sudo minikube start --memory=4096 --vm-driver=none --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf
$ sudo kubectl get pod --all-namespaces

```

### Passo 5: 
Fazendo o deployment de uma pod.

```markdown
$ sudo kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
deployment "hello-minikube" created
$ sudo kubectl get pods
$ sudo kubectl get deployments
```

### Passo 6:
Expondo o Serviço.

```markdown
$ sudo kubectl expose deployment hello-minikube --type=NodePort
$ sudo kubectl get services
```

### Passo 7:
Testando o serviço criado


```markdown
$ sudo minikube service hello-minikube --url
$ curl $(sudo minikube service hello-minikube --url)
```

### Passo 8:
Encerrando o serviço e o deployment.

```markdown
$ sudo kubectl delete service,deployment hello-minikube
$ sudo kubectl get pods
$ sudo kubectl get services
```

### Passo 9:
Criando uma aplicação JS para rodar no nosso cluster kubernetes (minikube)

```markdown
$ mkdir hello-node && cd hello-node && touch Dockerfile server.js
$ vi server.js

var http = require('http');
var handleRequest = function(request, response) {
  response.writeHead(200);
  response.end('Alou Mundo da Turma de Topicos em Redes!');
};
var helloServer = http.createServer(handleRequest);
helloServer.listen(8080);
```

### Passo 10:
Criando a imagem a partir de um DockerFile

```markdown
$ vi Dockerfile

FROM node:4.4
EXPOSE 8080
COPY server.js .
CMD node server.js
```

### Passo 11:
Docker build na nossa aplicação JS

```markdown
$ docker build -t hello-node:v1 .
$ docker images
```

### Passo 12:
Fazendo o deployment da Aplicação

```markdown
$ kubectl run hello-node --image=hello-node:v1 --port=8080
deployment "hello-node" created
$ kubectl get pods
$ kubectl get deployments

```
### Passo 13:
Expondo a aplicação e Testando 

```markdown
$ sudo kubectl expose deployment hello-node --type=NodePort
$ sudo kubectl get services
$ curl $(sudo minikube service hello-node --url) 
```














