# AuditTool
Web Application for audits, the main function are:
- Track audits activities
- Monitoring progress
- Archiving documentation

This application is implemented with the support of Group Internal Audit. The application is realized with the Meteor-Kitchen framework.


### With docker-compose
- prerequisites: docker, docker-compose

- git clone https://github.com/mttstt/AuditTool.git
- cd Audittool
- ./lin-docker.sh -u [passwordAD] [Docker-Hub release] (ex: ./lin-docker -u password 0.0.7.5)
- http://ip-host:81 (Audittool)
- http://ip-host:5488 (jsreport)
  
  
### Without docker (for development/test)
- prerequisites: meteor, meteorkitchen

- git clone https://github.com/mttstt/AuditTool.git
- cd AuditTool
- ./lin-docker.sh -m
- http://ip-host:3000 (Audittool)
- http://ip-host:5488 (jsreport)
