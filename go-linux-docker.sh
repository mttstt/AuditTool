#!/bin/bash
jsreport init &
jsreport start &
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

meteor create AuditTool

cd  AuditTool

############# for docker ##########################################################
docker system prune -f
docker network create --subnet=192.168.1.0/16 mttlan
docker run --name mongo-meteor -d mongo
echo "FROM jshimko/meteor-launchpad:latest" > ~/AuditTool/AuditTool/Dockerfile
cp ~/AuditTool/files/.dockerignore  ~/AuditTool/AuditTool/.dockerignore
cp ~/AuditTool/files/docker-compose.yml ~/AuditTool/AuditTool/docker-compose.yml
sudo docker build -t audittool .
echo "docker images ls"
docker image ls
docker run -d -e MONGO_URL=mongodb://172.17.0.2 -P audittool
###################################################################################

# docker run -d --name audittool -P audittool
docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
# docker ps -q | xargs docker inspect --format '{{ .NetworkSettings.IPAddress }}'

#awk 'NR==8{print "password: " "\x27" "Gennaio:2018" "\x27"}7' /home/mtt/AuditTool/AuditTool/server/methods/my-methods.js >  /home/mtt/AuditTool/AuditTool/server/methods/my-methods.js
