#!/bin/bash
# sudo systemctl stop firewalld.service
echo "In order to list images: docker images -a"
echo "In order to delete container: docker rm <ID container>"
echo "In order to delete: docker rmi <ID Images>"
echo "In order to delete all: docker system prune"
echo "In order to install Mongodb: docker run --name mongo-meteor -d mongo"
echo "In order to create network: docker network create --subnet=192.168.1.0/16 mttlan"

cd /home/mtt/AuditTool

cp -R files/ /tmp

rm -fR AuditTool

wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json

meteor-kitchen AuditTool.json AuditTool

cd  AuditTool

############# for docker ##########################################################
docker system prune -f
# docker network create --subnet=192.168.2.0/16 mttlan
docker run -d -p 80:5488 --restart always -v /jsreport-home:/jsreport jsreport/jsreport
docker run --name meteor-mongo -v /my/own/datadir:/data/db -d mongo
echo "FROM jshimko/meteor-launchpad:latest" > Dockerfile
#cp ../files/.dockerignore  ~/AuditTool/AuditTool
cp ../files/launchpad.conf ~/AuditTool/AuditTool
docker build -t audittool .
echo "Docker images ls:"
docker image ls
docker run -d -e MONGO_URL=mongodb://172.17.0.3 -e STARTUP_DELAY=10 -P audittool
#docker run -d --name audittool -P audittool
docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
# docker ps -q | xargs docker inspect --format '{{ .NetworkSettings.IPAddress }}'
##################################################################################
