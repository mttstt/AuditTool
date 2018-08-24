# AuditTool
Web Application for audits, the main function are:
- Track audits activities
- Monitoring progress
- Archiving documentation

This application is implemented with the support of Group Internal Audit. The application is realized with the Meteor-Kitchen framework.

### Start quickly
- docker pull mttstt/audittool:0.0.7.5


### With docker-compose
- git clone https://github.com/mttstt/AuditTool.git
- cd Audittool
- ./lin-docker -u [passwordAD] [release]
- http://ip-host:81 (Audittool)
- http://ip-host:5488 (jsreport)
  
  
### Without docker (for test)
- git clone https://github.com/mttstt/AuditTool.git
- cd Audittool
- ./lin-docker -m
- http://ip-host:3000 (Audittool)
- http://ip-host:5488 (jsreport)
