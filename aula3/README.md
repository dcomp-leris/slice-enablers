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
Testando o Balanceamento de Carga do docker Swarm através de um Script.

```markdown
$ vi testLB.sh
#!/bin/sh
hosts="192.168.50.2 192.168.50.3 192.168.50.4"
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
$ docker service ls
$ docker ps 
```

### Passo 15:
Deletando os serviços.

```markdown
$ docker service rm
$ docker ps 
$ docker service ls
```  












