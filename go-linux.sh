#!/bin/bash

jsreport init &

jsreport start &

sudo systemctl stop firewalld.service

cd /home/mtt/AuditTool

cp -R files/ /tmp

rm -fR AuditTool

wget http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben -O AuditTool.json

meteor-kitchen http://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben AuditTool

# cp /home/mtt/AuditTool/files/hacking/fileinput.js /home/mtt/AuditTool/AuditTool/client/styles/framework/bootstrap3-plugins/bootstrap-fileinput/fileinput.js

cd AuditTool

meteor
