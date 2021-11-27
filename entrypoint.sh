#!/bin/bash

# Initialize the datadir content if not done(Windows don't)
if [ -d "/mnt/geoserver_datadir" ] ; then
	echo "checking if /mnt/geoserver_datadir need init"
	if [ ! "$(ls -A /mnt/geoserver_datadir)" ] ;then
		echo "Initializing /mnt/geoserver_datadir"
		cp -r $CATALINA_HOME/webapps/${WEBAPP_PATH}/data/* /mnt/geoserver_datadir
	else
		echo "already initialized"
	fi
else
	echo "/mnt/geoserver_datadir does not exist"
fi

if [[ "$ENABLE_CORS" == "true" ]]; then
	mv /usr/local/tomcat/webapps/geoserver/WEB-INF/web.xml /usr/local/tomcat/webapps/geoserver/WEB-INF/web-orig.xml 
	cp /usr/local/tomcat/webapps/geoserver/WEB-INF/web-cors.xml /usr/local/tomcat/webapps/geoserver/WEB-INF/web.xml
fi

exec "$@"
