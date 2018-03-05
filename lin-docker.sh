#!/bin/bash
#
# -n: cancella tutto (container, images,..) e ricrea la struttura 
#
# newgrp docker
#

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -n|--new)
    echo "Clean ALL"

        echo "Ferma tutti i containers"
        docker container stop $(docker ps -a -q)

        echo "Elimina tutti i container"
        docker container rm $(docker ps -a -q)

        echo "Elimina tutti i volumi"
        docker volume rm $(docker volume ls -q)

        echo "Crea volumi"
        docker volume create audittoolvolume
        docker volume create jsreportvolume
        docker volume create mongovolume

        # Per copiare i dati devo prima creare un container dummy temporaneo
        echo "Copio file lib"
        docker container create --name dummy -v audittoolvolume:/tmp/files/lib hello-world
        docker cp ~/AuditTool/files/lib dummy:/tmp/files
        docker rm dummy

        echo "Elimina tutte le immagini"
        docker rmi $(docker images -a -q)

        echo "Elimina tutte le reti tranne quella di default 172.17.0.0/16"
        docker network rm mttlan

        echo "Crea nuova sottorete mttlan"
        docker network create --subnet=192.168.2.0/16 mttlan
       
        # Avvia container
        docker run -d --net mttlan --ip 192.168.2.1 --name jsreport -p 80:5488 --restart always -v jsreportvolume:/jsreport jsreport/jsreport
        docker run -d --net mttlan --ip 192.168.2.2 --name meteor-mongo -v mongovolume:/data/db mongo

    shift # past argument
    shift # past value
    ;;
    -b|--bye)
    echo "bye"

    echo "bye"
    shift # past argument
    shift # past argument
    ;;
    *)    # unknown option
    shift # past argument
    ;;
esac
done

echo "Inizio"

# sudo systemctl stop firewalld.service
# echo "In order to list images: docker images -a"
# echo "In order to delete container: docker rm <ID container>"
# echo "In order to delete: docker rmi <ID Images>"
# echo "In order to delete all: docker system prune"
# echo "In order to install Mongodb: docker run --name mongo-meteor -d mongo"
# echo "In order to create network: docker network create --subnet=192.168.1.0/16 mttlan"

cd ~/AuditTool

cp -R files/ /tmp

sudo rm -fR AuditTool

wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json

meteor-kitchen AuditTool.json AuditTool

cd  AuditTool

meteor build --architecture=os.linux.x86_64 ./

############################################################## for docker ##########################################################
# Se attivo ferma ed elimina il container audittool  
docker stop audittool || true && docker rm audittool || true

docker run \
 -it \
 --net mttlan \
 --ip 192.168.2.3 \
 --name audittool \
 -e MONGO_URL=mongodb://192.168.2.2 \
 -e ROOT_URL=http://192.168.2.3 \
 -v audittoolvolume:/tmp/files/lib \
 -v /home/mtt/AuditTool/AuditTool:/bundle \
 -p 8080:80 \
 abernix/meteord:node-8.9.3-base \
 /bin/bash

echo "Docker images ls:"
docker image ls

docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
################################################################################################################################
