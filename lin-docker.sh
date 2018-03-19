#!/bin/bash
#
# Use: lin-docker.sh [command] [Password] [Docker HUB release] 
# Put AuditTool in a Docker architecture
#
#./lin-docker.sh -u [Password Active Directory] [Docker HUB release] 
#./lin-dcoker.sh -p [Password Docker Hub]
#./lin-dcoker.sh -b [Docker HUB release] 
#
# Possible commands:
#
# -h, --help        Help
# -m, --meteor      Launch meteor, without Docker, for testing
# -b, --build       Build audittool docker image
# -p, --push        Push audittool image to Docker Hub [Password Docker Hub] [Docker HUB release] 
# -u, --dockerup    Docker-compose up [Password Active Directory] [Docker HUB release]  
# -d, --delete      Delete all (containers, images, volumes, networks)
# 
# Useful command for ubuntu 17: newgrp docker
#
# Useful command for bash to containet:  docker exec -ti <container> bash

while [[ $# -gt 0 ]]
do
key="$1"
passwd="$2"
release="$3"

case $key in
    -d|--delete)
        echo "Delete All"
        echo "Ferma tutti i containers"
        docker-compose down
        echo "Elimina tutti i containers"
        docker rm $(docker container ls -a -q) -f
        echo "Elimina tutti i volumi"
        docker volume prune -f
        echo "Elimina tutte le immagini"
        docker rmi $(docker images -a -q)
    shift # past argument
    shift # past argument
    ;;
    
    -b|--build)
        echo "build"
        cd ~/AuditTool
        if [ ! -f ~/AuditTool/.gitignore ]; then
            echo ".gitignore not found!"
        else
            rm .gitignore
        fi
        rm -rf .git
        sudo rm -fR AuditTool
        wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json
        meteor-kitchen AuditTool.json AuditTool
        cd  AuditTool
        echo "FROM abernix/meteord:node-8.9.3-onbuild" > Dockerfile
         export TAG=$release && docker-compose build --force-rm --no-cache docker-production-dev.yaml
    shift # past argument
    shift # past argument
    ;;

    -m|--meteor)
        echo "meteor"
        jsreport init &
        jsreport start &
        if [ ! -f ~/AuditTool/.gitignore ]; then
                echo ".gitignore not found!"
        else
            rm .gitignore
        fi
        rm -rf .git
        cp -R files/ /tmp
        cd /home/mtt/AuditTool
        rm -fR AuditTool
        wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json
        meteor-kitchen AuditTool.json AuditTool
        cd AuditTool
        meteor
    shift # past argument
    shift # past argument
    ;;
    
    -p|--push)
        echo "Push image to Docker Hub"
        docker login -password $passwd -username mttstt       
        docker push mttstt/audittool
    shift # past argument
    shift # past argument
    ;;  

    -u|--dockerup)
        echo "docker up" 
        export TAG=$TAG && export passwdAD=$passwd && docker-compose up -d docker-compose.yaml
    shift # past argument
    shift # past argument
    ;;   

    -b|--bye)
    echo "bye"
    echo "bye"
    shift # past argument
    shift # past argument
    ;;   
    
    *)    # unknown option
   
        echo "Use: lin-docker.sh [command] [Password] [Docker HUB release]" 
        echo "Put AuditTool in a Docker architecture"
        echo ""
        echo "./lin-docker.sh -u [Password Active Directory] [Docker HUB release]"
        echo "./lin-docker.sh -p [Password Docker Hub] [Docker HUB release]"               
        echo ""
        echo "Possible commands:"
        echo ""
        echo "-h, --help        Help"
        echo "-m, --meteor      Launch meteor, without Docker (for testing)"
        echo "-b, --build       Build audittool docker image"
        echo "-p, --push        Push audittool image to Docker Hub [password Docker HUB] [New versione release]"
        echo "-u, --dockerup    Docker-compose up"
        echo "-d, --delete      Delete all (containers, images, volumes, networks)"
        echo ""   
      
    shift # past argument# Options:
    ;;
        
esac
done
