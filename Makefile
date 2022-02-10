SHELL := /bin/bash
IMAGE=pigeosolutions/geoserver
SIBIMAGE=outils-patrinat.mnhn.fr/sib-geoserver
REV=`git rev-parse --short HEAD`
DATE=`date +%Y%m%d-%H%M`
VERSION=2.20.2

all: build

build:
	docker build -f Dockerfile-jetty -t ${IMAGE}:latest . ;\
	docker tag  ${IMAGE}:latest ${IMAGE}:${VERSION}-${DATE}-${REV} ;\
	echo tagged ${IMAGE}:${VERSION}-${DATE}-${REV}

push:
	docker push ${IMAGE}:latest ;\
	docker tag  ${IMAGE}:latest ${IMAGE}:${VERSION}-${DATE}-${REV} ;\
	docker push ${IMAGE}:${VERSION}-${DATE}-${REV}

docker-tag-sib: build
	docker tag  ${IMAGE}:latest ${SIBIMAGE}:latest ;\
	docker tag  ${IMAGE}:latest ${SIBIMAGE}:${VERSION}-${DATE}-${REV} ;\
	echo tagged ${SIBIMAGE}:${VERSION}-${DATE}-${REV}

docker-push-sib: docker-tag-sib
	docker push ${SIBIMAGE}:latest ;\
	docker tag  ${SIBIMAGE}:latest ${SIBIMAGE}:${VERSION}-${DATE}-${REV} ;\
	docker push ${SIBIMAGE}:${VERSION}-${DATE}-${REV}


run: build
	docker run -it --rm -p 8600:8080 ${IMAGE}:latest
