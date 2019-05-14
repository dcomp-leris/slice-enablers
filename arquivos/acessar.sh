#!/bin/bash

ssh -i cloud_ufscar_rsa.dms ubuntu@`cat lista-vms.txt | grep -w vm-$1 | awk '{print $1, $2, $3}' | cut -d " " -f 3`
