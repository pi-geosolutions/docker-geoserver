#!/bin/bash

# Initialize the datadir content if not done (Windows doesn't)
if [ -d "/mnt/geoserver_datadir" ] ; then
	echo "checking if /mnt/geoserver_datadir need init"
	if [ -f /mnt/geoserver_datadir/global.xml ]
	then
	    echo 'Datadir already initialized'
	else
		echo "Initializing /mnt/geoserver_datadir"
		cp -r $JETTY_BASE/webapps/${WEBAPP_PATH}/data/* /mnt/geoserver_datadir

		# Setting some customization
		# Set proxyBaseUrl if defined
		if [[ -n $PROXY_BASE_URL ]]; then
			sed -i "s|</settings>|<proxyBaseUrl>$PROXY_BASE_URL</proxyBaseUrl></settings>|" /mnt/geoserver_datadir/global.xml
		fi
	fi

  echo 'Change log config according to docker setup'
  sed -i 's:stdOutLogging>false:stdOutLogging>true:g' /mnt/geoserver_datadir/logging.xml

  echo 'deactivate oshi logs (hardware monitoring, fails on docker, the error logs pollute the geoserver logs)'
  echo "log4j.category.oshi.hardware.platform.linux=OFF" >> /mnt/geoserver_datadir/logs/PRODUCTION_LOGGING.properties
else
	echo "/mnt/geoserver_datadir does not exist"
fi


if [[ "$ENABLE_CORS" == "true" ]]; then
	mv $JETTY_BASE/webapps/${WEBAPP_PATH}/WEB-INF/web.xml $JETTY_BASE/webapps/${WEBAPP_PATH}/WEB-INF/web-orig.xml
	cp $JETTY_BASE/webapps/${WEBAPP_PATH}/WEB-INF/web-cors.xml $JETTY_BASE/webapps/${WEBAPP_PATH}/WEB-INF/web.xml
fi

exec "$@"
