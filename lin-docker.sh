#!/bin/bash
# -n: ricrea la struttura

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -n|--new)
    echo "Clean ALL"

        echo "Ferma tutti i containers"
        docker stop $(docker ps -a -q)

        echo "Elimina tutti i container"
        docker rm $(docker ps -a -q)

        echo "Elimina tutti i volumi"
        docker rm $(docker volume ls -q)

        echo "Crea volumi"
        docker volume audittoolvolume
        docker volume jsreportvolume
        docker volume mongovolume

        # Per copiare i dati devo prima creare un container dummy temporaneo
        echo "Copio file lib"
        docker container create --name dummy -v audittoolvolume:/tmp/files/lib hello-world
        docker cp ~/AuditTool/files/lib dummy:/tmp/files
        docker rm dummy

        echo "Elimina tutte le immagini"
        docker rmi $(docker images -a -q)

        echo "Elimina tutte le reti tranne quella di default 172.17.0.0/16"
        docker network rm $(docker network ls -q)

        echo "Crea nuova sottorete mttlan"
        docker network create --subnet=192.168.2.0/16 mttlan

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
echo "In order to list images: docker images -a"
echo "In order to delete container: docker rm <ID container>"
echo "In order to delete: docker rmi <ID Images>"
echo "In order to delete all: docker system prune"
echo "In order to install Mongodb: docker run --name mongo-meteor -d mongo"
echo "In order to create network: docker network create --subnet=192.168.1.0/16 mttlan"

rm -rf .gitcp -R files/ /tmp

rm -fR AuditTool

wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json

meteor-kitchen AuditTool.json AuditTool

cd  AuditTool

############################################################## for docker ##########################################################
# Ferma tutti i containers
docker container stop $(docker ps -a -q)

# Elimina tutti i container
docker rm $(docker ps -a -q)

# Elimina l'immagine audittol
docker rmi $(docker images mttstt/audittool -q) -f

# Avvia container
docker run -d --net mttlan --ip 192.168.2.1 --name jsreport -p 80:5488 --restart always -v jsreportvolume:/jsreport jsreport/jsreport
docker run -d --net mttlan --ip 192.168.2.2 --name meteor-mongo -v mongovolume:/data/db mongo

#echo "METEOR in versione development"
#echo "FROM jshimko/meteor-launchpad:devbuild" > Dockerfile
echo "Configurazione da utilizzare in produzione"
echo "FROM jshimko/meteor-launchpad:latest" > Dockerfile

cp ../files/.dockerignore  ~/AuditTool/AuditTool
docker build \
 --build-arg NODE_VERSION=8.9.4 \
 --build-arg INSTALL_MONGO=false \
 --build-arg INSTALL_PHANTOMJS=false \
 --build-arg INSTALL_GRAPHICSMAGIC=false \
 -t mttstt/audittool .

docker run -d --net mttlan --ip 192.168.2.3 --name audittool -e MONGO_URL=mongodb://192.168.2.2 -e STARTUP_DELAY=10 -v audittoolvolume:/tmp/files/lib -P mttstt/audittool

echo "Docker images ls:"
docker image ls

docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
################################################################################################################################
