FROM tomcat:9-jre8
MAINTAINER pi-Geosolutions "jp@pigeosolutions.fr"
# highly inspired by camptocamp's

ARG GEOSERVER_VERSION=2.20
ARG GEOSERVER_MINOR_VERSION=1
# ARG WEBAPP_PATH "ROOT"
ARG WEBAPP_PATH="geoserver"

RUN mkdir /tmp/geoserver /mnt/geoserver_datadir /mnt/geoserver_geodata /mnt/geoserver_tiles

# Install geoserver
RUN curl -L https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}.${GEOSERVER_MINOR_VERSION}/geoserver-${GEOSERVER_VERSION}.${GEOSERVER_MINOR_VERSION}-war.zip/download > /tmp/geoserver.zip && \
    unzip -o /tmp/geoserver.zip -d /tmp/geoserver && \
    unzip -o /tmp/geoserver/geoserver.war -d $CATALINA_HOME/webapps/${WEBAPP_PATH} && \
    rm -rf $CATALINA_HOME/webapps/${WEBAPP_PATH}/WEB-INF/lib/marlin-*.jar && \
    rm -r /tmp/*

# Install Marlin
RUN cd /usr/local/tomcat/lib && \
    wget https://github.com/bourgesl/marlin-renderer/releases/download/v0.9.0/marlin-0.9.0-Unsafe.jar -O $CATALINA_HOME/webapps/${WEBAPP_PATH}/WEB-INF/lib/marlin.jar && \
    wget https://github.com/bourgesl/marlin-renderer/releases/download/v0.9.0/marlin-0.9.0-Unsafe-sun-java2d.jar -O $CATALINA_HOME/webapps/${WEBAPP_PATH}/WEB-INF/lib/marlin-sun-java2d.jar

VOLUME [ "/mnt/geoserver_datadir", "/mnt/geoserver_geodata", "/mnt/geoserver_tiles", "/tmp" ]

# space-separate list of plugins to install
ARG PLUGINS_EXT="css control-flow vectortiles"
ARG PLUGINS_COMMUNITY=""

# Install plugins if some listed
# Official plugins
RUN for plugin in $PLUGINS_EXT; do \
    echo "https://build.geoserver.org/geoserver/${GEOSERVER_VERSION}.x/ext-latest/geoserver-${GEOSERVER_VERSION}-SNAPSHOT-${plugin}-plugin.zip > /tmp/${plugin}-plugin.zip" &&\
    curl -L https://build.geoserver.org/geoserver/${GEOSERVER_VERSION}.x/ext-latest/geoserver-${GEOSERVER_VERSION}-SNAPSHOT-${plugin}-plugin.zip > /tmp/${plugin}-plugin.zip && \
    unzip -o /tmp/${plugin}-plugin.zip -d $CATALINA_HOME/webapps/${WEBAPP_PATH}/WEB-INF/lib/ &&\
    rm /tmp/* ; \
  done

# Community plugins
RUN for plugin in $PLUGINS_COMMUNITY; do \
    echo "https://build.geoserver.org/geoserver/${GEOSERVER_VERSION}.x/community-latest/geoserver-${GEOSERVER_VERSION}-SNAPSHOT-${plugin}-plugin.zip > /tmp/${plugin}-plugin.zip" &&\
    curl -L https://build.geoserver.org/geoserver/${GEOSERVER_VERSION}.x/community-latest/geoserver-${GEOSERVER_VERSION}-SNAPSHOT-${plugin}-plugin.zip > /tmp/${plugin}-plugin.zip && \
    unzip -o /tmp/${plugin}-plugin.zip -d $CATALINA_HOME/webapps/${WEBAPP_PATH}/WEB-INF/lib/ &&\
    rm /tmp/* ; \
  done

ENV CATALINA_OPTS "-Xms1024M \
 -Xbootclasspath/a:$CATALINA_HOME/webapps/${WEBAPP_PATH}/WEB-INF/lib/marlin.jar \
 -Xbootclasspath/p:$CATALINA_HOME/webapps/${WEBAPP_PATH}/WEB-INF/lib/marlin-sun-java2d.jar \
 -Dsun.java2d.renderer=org.marlin.pisces.MarlinRenderingEngine \
 -DGEOSERVER_DATA_DIR=/mnt/geoserver_datadir \
 -DGEOWEBCACHE_CACHE_DIR=/mnt/geoserver_tiles \
 -DENABLE_JSONP=true \
 -Dorg.geotools.coverage.jaiext.enabled=true \
 -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2 \
 -XX:SoftRefLRUPolicyMSPerMB=36000 \
 -XX:+UnlockExperimentalVMOptions \
 -XX:+UseCGroupMemoryLimitForHeap"

# change this variable to change the datadir used
#ARG DATADIR="min_data_dir"
# Use data dir template
#COPY $DATADIR/ /mnt/geoserver_datadir/
# Use basic default datadir
#RUN mv $CATALINA_HOME/webapps/${WEBAPP_PATH}/data/* /mnt/geoserver_datadir/

# Copy CORS-enabled web.xml in Tomcat (used of not, depends on env var, see entrypoint)
COPY web-cors.xml /usr/local/tomcat/webapps/geoserver/WEB-INF/

ADD entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

# Make an env var out of the ARG variable, to make it available to the entrypoint
ENV WEBAPP_PATH=${WEBAPP_PATH}
ENV ENABLE_CORS="false"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]
