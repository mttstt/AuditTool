FROM abernix/meteord:node-8.9.4-onbuild
EXPOSE 5488

RUN addgroup -S jsreport && adduser -S -G jsreport jsreport 

VOLUME ["/jsreport"]
RUN mkdir -p /app
WORKDIR /app

RUN npm install -g jsreport-cli && \
    jsreport init && \
    npm uninstall -g jsreport-cli && \
    npm cache clean -f 

COPY editConfig.js /app/editConfig.js
RUN node editConfig.js    

ADD run.sh /app/run.sh
COPY . /app

ENV NODE_ENV production
ENV templatingEngines:strategy http-server

CMD ["bash", "/app/run.sh"]
