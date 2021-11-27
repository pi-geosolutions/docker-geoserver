DOCKER_TAG ?= latest
DOCKER_IMAGE = pigeosolutions/geoserver

all: build

pull:
		docker pull tomcat:9-jre8

build:
		docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

push:
		docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest ;\
		docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
