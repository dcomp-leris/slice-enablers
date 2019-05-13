# Arquivos necessários para acessar as VMs

## Como utilizar os scripts
```markdown
$ bash NOME_DO_SCRIPT
```

## Descrição dos arquivos

### apt.sh (script para instalação do IPerf)
```markdown
#!/bin/bash

sudo apt update
sudo apt install -y iperf
```

### cliente-iperf.sh (script para inicializar geração de tráfego de um cliente para o servidor)
```markdown
#!/bin/bash

iperf -c controller -t $1
```

### servidor-iperf.sh (script para inicializar o servidor que receberá o tráfego gerado)
```markdown
#!/bin/bash

sudo iperf -s -D > iperf.log
```
