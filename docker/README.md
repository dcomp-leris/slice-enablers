# Primeiros passos com Docker 

Esta página é dedicada a instalação e configuração do Docker no Ubuntu.

A maioria dos passos de configuração foi retirada do [site oficial](https://docs.docker.com/), que também contém maiores detalhes de configuração e uso do Docker.

## Instalação do Docker no Ubuntu

### Configurando o repositório

```markdown
$ sudo apt-get update
```

```markdown
$ sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```

```markdown
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

```markdown
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

### Instalação do Docker CE

```markdown
$ sudo apt-get update
```

```markdown
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```
