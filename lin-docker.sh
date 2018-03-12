#!/bin/bash
#
# Use: lin-docker.sh [OPTION]
# Put AuditTool in a Docker architecture
#
# Mandatory options:
#
# -h, --help        Help
# -l, --launch      Launch container AuditTool
# -t, --tar         Create tar meteor
# -n, --new         Create tar meteor and Run container
# -d, --delete      Delete all (containers, images, volumes, networks)
# -r, --reload      Delete all (containers, images, volues, networks) and create all again
#
# Useful comand for ubuntu 17: newgrp docker

while [[ $# -gt 0 ]]
do
key="$1"

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
        docker run -d --name meteor-mongo -v mongovolume:/data/db mongo
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
         -e "jsreportServerIp=$JRSI" \
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
         -e "jsreportServerIp=$JRSI" \
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
         -e "jsreportServerIp=$JRSI" \
         -v audittoolvolume:/tmp/files/lib \
         -v /home/mtt/AuditTool/AuditTool:/bundle \
         -p 8080:80 \
         abernix/meteord:node-8.9.3-base \
         /bin/bash

    shift # past argument
    shift # past argument
    ;;
    
    -b|--bye)
    echo "bye"
    echo "bye"
    shift # past argument
    shift # past argument
    ;;
    
    -h|--help)
        echo use "./lin-docker.sh [OPTION]"
        echo "Docker for AuditTool"
        echo ""
        echo "Mandatory options:"
        echo "Options:"
        echo "-l, --launch      Launch container AuditTool"
        echo "-t, --tar         Create tar meteor"
        echo "-n, --new         Create tar meteor and Run container"
        echo "-d, --delete      Delete all (containers, images, volumes, networks)"
        echo "-r, --reload      Delete all (containers, images, volumes, networks) and create all again"
        echo "-h, --help        Help"
        echo ""
    shift # past argument
    shift # past argument
    ;;
    
    *)    # unknown option
        echo use "./lin-docker.sh [OPTION]"
        echo "Docker for AuditTool"
        echo ""
        echo "Mandatory options:"
        echo ""
        echo "-h, --help        Help"
        echo "-l, --launch      Launch container AuditTool"
        echo "-t, --tar         Create tar meteor"
        echo "-n, --new         Create tar meteor and Run container"
        echo "-d, --delete      Delete all (containers, images, volumes, networks)"
        echo "-r, --reload      Delete all (containers, images, volumes, networks) and create all again"
        echo ""
    shift # past argument# Options:
    ;;
        
esac
done
