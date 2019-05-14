# Primeiros passos com Docker 

Esta página é dedicada a instalação e configuração do Docker no Ubuntu.

A maioria dos passos de instalação foi retirada do [site oficial](https://docs.docker.com/), que também contém maiores detalhes de configuração e uso do Docker.

Com relação aos exemplos de utilização do Docker, a maioria dos exemplos foi retirada do [free lab](https://training.play-with-docker.com).

## Instalação do Docker no Ubuntu

### Configurando o repositório

```markdown
$ sudo apt update
```

```markdown
$ sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```

```markdown
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

```markdown
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

### Instalação do Docker CE

```markdown
$ sudo apt update
```

```markdown
$ sudo apt -y install docker-ce docker-ce-cli containerd.io
```

## Utilizando o Docker

```markdown
$ sudo docker run hello-world
```

```markdown
$ sudo docker container ls
```

```markdown
$ sudo docker container ls -a
```

```markdown
$ sudo docker image ls
```

```markdown
$ sudo docker image pull alpine
```

```markdown
$ sudo docker run alpine ls -l
```

```markdown
$ sudo docker run alpine echo "aloh mundo de dentro do alpine"
```

```markdown
$ sudo docker run alpine /bin/sh
```

```markdown
$ sudo docker run -it alpine /bin/sh
```

### Exemplo de isolamento

```markdown
$ sudo docker run -it alpine /bin/ash
/ # echo "Aloh mundo!!!" > hello.txt
/ # ls
...
/ # exit
```
```markdow
$ sudo docker run alpine ls
```

```markdown
$ sudo docker container ls -a
```

```markdown
$ sudo docker start CONTAINER_ID
```

```markdown
$ sudo docker container ls
```

```markdown
$ sudo docker exec CONTAINER_ID ls
```

```markdown
$ sudo docker stop CONTAINER_ID
```

```markdown
$ sudo docker rm CONTAINER_ID
```

### Customizando imagens Docker

```markdown
$ sudo docker run -ti ubuntu bash
# apt update
...
# apt install -y figlet
...
# figlet "aloh mundo!"
...
# exit
```

```markdown
$ sudo docker container ls -a
```

```markdown
$ sudo docker diff CONTAINER_ID
```

```markdown
$ sudo docker commit CONTAINER_ID
```

```markdown
$ sudo docker image ls
```

```markdown
$ sudo docker image tag IMAGE_ID ourfiglet
```

```markdown
$ sudo docker image ls
```

```markdown
$ sudo docker run ourfiglet figlet "Aloh classe!"
```

### Criando imagens com um Dockerfile

```markdown
$ echo 'var os = require("os");' >> index.js
$ echo 'var hostname = os.hostname();' >> index.js
$ echo 'console.log("hello from " + hostname);' >> index.js
$ cat index.js
```
