DOCKER_TAG ?= 2.15.3-win
DOCKER_IMAGE = pigeosolutions/geoserver

all: build

pull:
		docker pull tomcat:9-jre8

build:
		docker build -t $(DOCKER_IMAGE):latest .

push:
		docker push $(DOCKER_IMAGE):latest ;\
		docker tag $(DOCKER_IMAGE) $(DOCKER_IMAGE):$(DOCKER_TAG) ;\
		docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
