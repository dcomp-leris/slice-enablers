## Aula Prática 3 - Prometheus, Grafana, NetData e Geradores de Tráfego!

Passo a Passo do Hands-On de Prometheus, Grafana, NetData e Geradores de Tráfego para a disciplina de Tópicos Avançados em Redes de Computadores e Sistemas Distribuídos 2019. 

### Passo 1: 
Subir a vm que será utilizada nesta Aula.  

```markdown
$ cd slice-enablers/aula3
$ vagrant status 
$ vagrant up
```

### Passo 2:
Verificar o conteúdo do arquivo prometheus.yml e Dockerfile.

```markdown
$ vi prometheus.yml
$ cat Dockerfile
```

### Passo 3:
Criar a nova imagem prometheus usando o Dockerfile e iniciar o container Prometheus. 

```markdown
$ sudo docker build -t my-prometheus .
$ sudo docker run -p 9090:9090 --restart=always --detach=true --name=prometheus my-prometheus
```

### Passo 4:
Verificar se o Prometheus está funcionando corretamente.

```markdown
No browser:
$ localhost:<PORTA>
ou
$ <IP>:<PORTA>
```

### Passo 5: 
Agora vamos iniciar os containers contendo os exporters: node-exporter e cadvisor.  

```markdown
$ sudo docker run -d --restart=always --net="host" --pid="host" --publish=9100:9100 --detach=true --name=node-exporter -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter --path.rootfs /host
$ sudo docker run --restart=always --volume=/:/rootfs:ro --volume=/var/run:/var/run:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=8080:8080 --detach=true --name=cadvisor google/cadvisor:latest
```

### Passo 6:
Verifiquem na interface web do Prometheus se os exporters estão funcionando corretamente.

### Passo 7:
Iniciando o container da ferramenta de visualização Grafana.

```markdown
$ sudo docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

### Passo 8:
Acessem o dashboard do Grafana. 

```markdown
No browser:
$ localhost:<3000>
ou
$ <IP>:<3000>

user: admin
senha: admin
```

### Passo 9:
Configurando o Dashboard do Grafana para acessar as métricas do Prometheus.

```markdown
No Dashboard do Grafana vão na aba Data Sources e procurem pelo Prometheus.
- Adicionem a URL com a porta do Prometheus de vocês
- No campo Access coloquem Browser
- Cliquem em "Save & Test"
```

### Passo 10:
Adicionando Dashboards prontos no Grafana.

```markdown
Procurem por Import Dashboard no Grafana. 
- Adicionem os Dashboards com os seguintes IDs: 193, 1860 e 3662.
- Não esqueçam de selecionar como Data Source o Prometheus.
```

### Passo 11:
Iniciando o container de monitoramento do NetData. Para checar a instalação acessem no Browser: <IP>:<19999>

```markdown
$ sudo docker run -d --name=netdata \
  -p 19999:19999 \
  --restart=always \ 
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata
```

### Passo 12:
Criando a Imagem dos containeres com as ferramentas de geração de tráfego já pré-instaladas.

```markdown
$ cd slice-enablers/aula3/containers
$ sudo docker build -t my-image .
$ sudo docker run -it my-image bash
```

### Passo 13:
Subam dois containeres a partir da imagem my-image criada anteriormente.

```markdown
No container 1:
$ iperf3 -s

No container 2:
$ iperf3 -c <IP do servidor>

Testem os diversos parametros do iperf3
-b -t -n etc.

$ iperf3 man
```

### Passo 14:
Testando o programa stress-ng para aumentar o uso de cpu, memória e disco. 

```markdown
CPU
$ stress-ng -c 1 -l 40% -t 5m
Memória
$ stress-ng -c 1 -l 15% --io 1 --hdd-bytes 10m --vm 1 --vm-bytes 10% -t 10m

Manual stress-ng
$ stress-ng --help
```












