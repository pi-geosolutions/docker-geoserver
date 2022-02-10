# Docker image for GeoServer

A docker image that runs GeoServer version 2.20

- To use Jetty servlet server : `docker build -f Dockerfile-jetty . -t pigeosolutions/geoserver`
- To use Tomcat servlet server : `docker build -f Dockerfile-tomcat . -t pigeosolutions/geoserver`

## To run

```bash
docker build -f Dockerfile-jetty . -t pigeosolutions/geoserver
docker run -p 8600:8080 pigeosolutions/geoserver
```

Visit http://localhost:8600/geoserver/web/
