#!/bin/bash

ssh -i private_key_vm$1 vagrant@`cat lista-vms | grep -w vm$1 | awk '{print $1, $2, $3}' | cut -d " " -f 2`
