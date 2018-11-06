FROM abernix/meteord:onbuild
MAINTAINER Jesse Rosenberger

RUN addgroup --system jsreport
RUN adduser --system --ingroup jsreport jsreport

RUN mkdir -p /app 
WORKDIR /appjsreport

RUN npm install -g jsreport-cli
RUN /opt/nodejs/bin/jsreport init
RUN npm uninstall -g jsreport-cli
RUN npm cache clean -f

COPY editConfig.js /app/editConfig.js
RUN node editConfig.js

ADD run.sh /app/run.sh
COPY . /app

ENV NODE_ENV production
ENV templatingEngines:strategy http-server
CMD ["bash", "/app/run.sh"]
