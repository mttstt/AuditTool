#!/bin/bash
#
# Use: lin-docker.sh [command] [Password] [Docker HUB release(only -p)] 
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
# -l, --launch      Launch container AuditTool (old without Docker Hub)
# -t, --tar         Create tar meteor (old without Docker Hub)
# -o, --onbuild     Build audittool docker image
# -p, --push        Push audittool image to Docker Hub [password Docker HUB] [New versione release]
# -u, --dockerup    Docker-compose up
# -n, --new         Create tar meteor and Run container (old without Docker Hub)
# -d, --delete      Delete all (containers, images, volumes, networks) (old without Docker Hub)
# -r, --reload      Delete all (containers, images, volues, networks) and create all again (old without Docker Hub)
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
    -r|--reload)
        echo "Recreate all"
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
                    
        # Avvia container
        docker run -d --name jsreport -p 5488:5488 --restart always -v jsreportvolume:/jsreport jsreport/jsreport
        docker run -d --name meteor-mongo -p 27017:27017 -v mongovolume:/data/db mongo
        ############################################################## create tar meteor ###################################################
        cd ~/AuditTool        
        if [ ! -f ~/AuditTool/.gitignore ]; then
            echo ".gitignore not found!"
        else
            rm .gitignore
        fi        
        rm -rf .git
        cp -R files/ /tmp
        sudo rm -fR AuditTool
        wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json
        meteor-kitchen AuditTool.json AuditTool
        cd  AuditTool
        meteor build --architecture=os.linux.x86_64 ./
        ############################################################## for docker ##########################################################
        # Se attivo ferma ed elimina il container audittool  
        docker stop audittool || true && docker rm audittool || true
        JRSI=$(docker inspect jsreport --format '{{ .NetworkSettings.IPAddress }}')
        docker run \
         -it \
         --name audittool \
         --link "meteor-mongo:db" \
         -e "MONGO_URL=mongodb://db" \
         -e ROOT_URL=http://127.0.0.1 \
         -e "jsReportServerIp=$JRSI" \
         -e "passwdAD=$passwd" \
         -v audittoolvolume:/tmp/files/lib \
         -v /home/mtt/AuditTool/AuditTool:/bundle \
         -p 8080:80 \
         abernix/meteord:node-8.9.3-base \
         /bin/bash
        echo "Docker images ls:"
        docker image ls
        docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
        ################################################################################################################################

    shift # past argument
    shift # past value
    ;;
    
    -t|--tar)
        echo "Build Meteor tar"
        cd ~/AuditTool
        if [ ! -f ~/AuditTool/.gitignore ]; then
            echo ".gitignore not found!"
        else
            rm .gitignore
        fi
        rm -rf .git
        cp -R files/ /tmp
        sudo rm -fR AuditTool
        wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json
        meteor-kitchen AuditTool.json AuditTool
        cd  AuditTool
        meteor build --architecture=os.linux.x86_64 ./    
    shift # past argument
    shift # past argument
    ;;
 
    -d|--delete)
        echo "Delete All"
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

    shift # past argument
    shift # past argument
    ;;
    
    -n|--new)
        echo "Create tar meteor e run docker"
        cd ~/AuditTool
        if [ ! -f ~/AuditTool/.gitignore ]; then
            echo ".gitignore not found!"
        else
            rm .gitignore
        fi
        rm -rf .git
        cp -R files/ /tmp
        sudo rm -fR AuditTool
        wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json
        meteor-kitchen AuditTool.json AuditTool
        cd  AuditTool
        meteor build --architecture=os.linux.x86_64 ./
        ############################################################## for docker ##########################################################
        # Se attivo ferma ed elimina il container audittool  
        docker stop audittool || true && docker rm audittool || true
        JRSI=$(docker inspect jsreport --format '{{ .NetworkSettings.IPAddress }}')
        docker run \
         -it \
         --name audittool \
         --link "meteor-mongo:db" \
         -e "MONGO_URL=mongodb://db" \
         -e ROOT_URL=http://127.0.0.1 \
         -e "jsReportServerIp=$JRSI" \
         -e "passwdAD=$passwd" \
         -v audittoolvolume:/tmp/files/lib \
         -v /home/mtt/AuditTool/AuditTool:/bundle \
         -p 8080:80 \
         abernix/meteord:node-8.9.3-base \
         /bin/bash
        echo "Docker images ls:"
        docker image ls
        docker ps -q | xargs docker inspect --format '{{ .Id }} - {{ .Name }} - {{ .NetworkSettings.IPAddress }}'
        ################################################################################################################################

    shift # past argument
    shift # past argument
    ;;
    
    -l|--launch)
        echo "Run AuditTool"
        docker stop audittool || true && docker rm audittool || true
        JRSI=$(docker inspect jsreport --format '{{ .NetworkSettings.IPAddress }}')
        docker run \
         -it \
         --name audittool \
         --link "meteor-mongo:db" \
         -e "MONGO_URL=mongodb://db" \
         -e ROOT_URL=http://127.0.0.1 \
         -e "jsReportServerIp=$JRSI" \
         -e "passwdAD=$passwd" \
         -v audittoolvolume:/tmp/files/lib \
         -v /home/mtt/AuditTool/AuditTool:/bundle \
         -p 8080:80 \
         abernix/meteord:node-8.9.3-base \
         /bin/bash

    shift # past argument
    shift # past argument
    ;;
    
    -o|--onbuild)
        echo "Onbuild"
        cd ~/AuditTool
        if [ ! -f ~/AuditTool/.gitignore ]; then
            echo ".gitignore not found!"
        else
            rm .gitignore
        fi
        rm -rf .git
        cp -R files/ /tmp
        sudo rm -fR AuditTool
        wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json
        meteor-kitchen AuditTool.json AuditTool
        cd  AuditTool
        echo "FROM abernix/meteord:node-8.9.3-devbuild" > Dockerfile
        docker build -t mttstt/audittool .
       
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
        cd /home/mtt/AuditTool
        cp -R files/ /tmp
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
        HOST_IP=`ip -4 addr show scope global dev ens33 | grep inet | awk '{print $2}' | cut -d / -f 1`
        #HOST_IP=`ip -4 addr show scope global dev docker0 | grep inet | awk '{print $2}' | cut -d / -f 1`
        export JRSI=$HOST_IP && export passwdAD=$passwd && docker-compose up
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
        echo "Use: lin-docker.sh [command] ActiveDirectoryPassword(optional)"
        echo "Docker for AuditTool"
        echo ""
        echo "Possible commands:"
        echo ""
        echo "-h, --help        Help"
        echo "-l, --launch      Launch container AuditTool"
        echo "-t, --tar         Create tar meteor"
        echo "-m, --meteor      Launch meteor, no Docker"
        echo "-o, --onbuild     Build Docker image"
        echo "-n, --new         Create tar meteor and Run container"
        echo "-d, --delete      Delete all (containers, images, volumes, networks)"
        echo "-r, --reload      Delete all (containers, images, volumes, networks) and create all again"
        echo ""
    shift # past argument# Options:
    ;;
        
esac
done
