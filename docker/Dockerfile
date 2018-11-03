FROM debian:jessie MAINTAINER Jesse Rosenberger
ENV METEORD_DIR /opt/meteord COPY scripts $METEORD_DIR
ARG NODE_VERSION ENV NODE_VERSION ${NODE_VERSION:-8.11.3} ONBUILD ENV NODE_VERSION ${NODE_VERSION:-8.11.3}
RUN bash $METEORD_DIR/lib/install_base.sh RUN bash $METEORD_DIR/lib/install_node.sh

RUN addgroup --system jsreport RUN adduser --system --ingroup jsreport jsreport
VOLUME ["/jsreport"] RUN mkdir -p /appjsreport WORKDIR /appjsreport
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
RUN npm install -g jsreport-cli RUN /opt/nodejs/bin/jsreport init
RUN npm uninstall -g jsreport-cli && 
RUN npm cache clean -f
COPY editConfig.js /appjsreport/editConfig.js RUN node editConfig.js
ADD run.sh /appjsreport/run.sh COPY . /app
ENV NODE_ENV production ENV templatingEngines:strategy http-server
CMD ["bash", "/appjsreport/run.sh"]

RUN bash $METEORD_DIR/lib/install_phantomjs.sh RUN bash $METEORD_DIR/lib/cleanup.sh
EXPOSE 80 5488 RUN chmod +x $METEORD_DIR/run_app.sh ENTRYPOINT exec $METEORD_DIR/run_app.sh
