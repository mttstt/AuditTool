#!/bin/bash
#
# Use: lin-docker.sh [command] [Password Docker HUB] [Docker HUB release(only -p)] 
# Put AuditTool in a Docker architecture
# Password is:
#               - password of Active Directory for query ldap
#                    or
#               - password of Docker Hub for pull images (only with -p command)
#
# Release: version to upload image on Docker Hub
#
# Possible commands:
#
# -h, --help        Help
# -m, --meteor      Launch meteor, no Docker (without Docker)
# -b, --build       Build audittool docker image
# -p, --push        Push audittool image to Docker Hub [password Docker HUB] [New versione release]
# -u, --dockerup    Docker-compose up
# -d, --delete      Delete all (containers, images, volumes, networks) (old without Docker Hub)
# 
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
        docker-compose build --force-rm --no-cache               
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
        docker tag mttstt/audittool mttstt/audittool:$release
        docker push mttstt/audittool:$release
    shift # past argument
    shift # past argument
    ;;  

    -u|--dockerup)
        echo "docker up"        
        export passwdAD=$passwd && docker-compose up
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
   
        echo "Use: lin-docker.sh [command] [Password] [Docker HUB release(only -p)]" 
        echo "Put AuditTool in a Docker architecture"
        echo ""
        echo "Password is:"
        echo  "    - password of Active Directory for query ldap"
        echo  "         or"
        echo  "    - password of Docker Hub for pull images (only with -p command)"
        echo ""
        echo "Release: version to upload image on Docker Hub"
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
