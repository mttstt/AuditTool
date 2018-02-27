#!/bin/bash

jsreport init &

jsreport start &

# sudo systemctl stop firewalld.service

cd /home/mtt/AuditTool

cp -R files/ /tmp

rm -fR AuditTool

wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json

meteor-kitchen AuditTool.json AuditTool

cd AuditTool


#awk 'NR==8{print "password: " "\x27" "Gennaio:2018" "\x27"}7' /home/mtt/AuditTool/AuditTool/server/methods/my-methods.js >  /home/mtt/AuditTool/AuditTool/server/methods/my-methods.js


meteor
