SET dir1=C:\Users\matteo\Documents\GitHub\AuditTool
del /Q "%dir1%"\AuditTool.json

curl https://www.meteorkitchen.com/api/getapp/json/Tqq4JcxsuGEBZrben  -o "%dir1%"\AuditTool.json

rmdir AuditTool /S /Q
mkdir emptyfolder
robocopy emptyfolder AuditTool /purge
rmdir emptyfolder
rmdir AuditTool

meteor-kitchen ./AuditTool.json ./AuditTool

copy  "%dir1%"\files\hacking\fileinput.js "%dir1%"\AuditTool\client\styles\framework\bootstrap3-plugins\bootstrap-fileinput\fileinput.js /Y

cd ./AuditTool
meteor --port 5000