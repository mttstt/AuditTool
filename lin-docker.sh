#!/bin/bash
# sudo systemctl stop firewalld.service
echo "In order to list images: docker images -a"
echo "In order to delete container: docker rm <ID container>"
echo "In order to delete: docker rmi <ID Images>"
echo "In order to delete all: docker system prune"
echo "In order to install Mongodb: docker run --name mongo-meteor -d mongo"
echo "In order to create network: docker network create --subnet=192.168.1.0/16 mttlan"

rm .gitignore

cd /home/mtt/AuditTool

cp -R files/ /tmp

rm -fR AuditTool

wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json

meteor-kitchen AuditTool.json AuditTool

cd  AuditTool

############# for docker ##########################################################
# Ferma tutti i containers
docker stop $(docker ps -a -q)
# Elimina tutti i container
docker rm $(docker ps -a -q)
# Elimina l'immagine audittol 
docker rmi $(docker images audittool -q) -f
# Elimina tutte le immagini
# docker rmi $(docker images -a -q)
# Elimina tutte le reti
docker rm $(docker network ls -q) -f
# crea la nuova sottorete mttlan
docker network create --subnet=192.168.2.0/16 mttlan
# Avvia container
docker run -d --net mttlan --ip 192.168.2.1 -p 80:5488 --restart always -v /jsreport-home:/jsreport jsreport/jsreport
docker run -d --net mttlan --ip 192.168.2.2 --name meteor-mongo -v /my/own/datadir:/data/db mongo

echo "FROM jshimko/meteor-launchpad:latest" > Dockerfile
# cp ../files/.dockerignore  ~/AuditTool/AuditTool
cp ../files/launchpad.conf ~/AuditTool/AuditTool
docker build -t audittool .
echo "Docker images ls:"
docker image ls

docker run -d --net mttlan --ip 192.168.2.3 -e MONGO_URL=mongodb://192.168.2.2 -e STARTUP_DELAY=10 -P audittool

docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
##################################################################################

