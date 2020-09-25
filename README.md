# Docker image for GeoServer

A docker image that runs GeoServer version 2.17

## To run

```bash
docker build . -t pigeosolutions/geoserver
docker run -p 8600:8080 pigeosolutions/geoserver
```

Visit http://localhost:8600/geoserver/web/
