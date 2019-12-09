# AuditTool
Web Application for audits, the main function are:
- Track audits activities
- Monitoring progress
- Archiving documentation

This application is implemented with the support of Group Internal Audit. The application is realized with the Meteor-Kitchen framework.


### Startup
    
    DEFAULT:mantain data (MongoDB and JReport) and update AuditTool 
    CONFIG: reset all (included MongoDB and JReport) and start a new config implementation  
    DEMO: reset all  (included MongoDB and JReport) and start a new demo implementation
  
 
### Quick start with docker-compose
(Prerequisites: docker, docker-compose)

    git clone https://github.com/mttstt/AuditTool.git
    sudo service docker restart
    cd AuditTool
    chmod +x lin-docker.sh
    ./lin-docker.sh -u [passwordAD] [Docker-Hub release] (e.g.: ./lin-docker -u Passw0rd 0.0.16)
    (Jsreport) Access to http://ip-host:5488 and import jsreport.zip contained in git repository
    http://ip-host:81 (AuditTool)
  
  
### For development/test
(Prerequisites: meteor, meteorkitchen, docker)

    sudo docker run -d -p 5488:5488 --restart always jsreport/jsreport:2.0.0-full
    git clone https://github.com/mttstt/AuditTool.git
    cd AuditTool
    ./lin-docker.sh -m
    http://ip-host:3000 (Audittool)
    http://ip-host:5488 (jsreport)
