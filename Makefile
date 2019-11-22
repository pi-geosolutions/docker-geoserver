DOCKER_TAG ?= latest
DOCKER_IMAGE = pigeosolutions/geoserver

all: build

pull:
		docker pull tomcat:9-jre8

build:
		docker build -t $(DOCKER_IMAGE) .

push:
		docker tag $(DOCKER_IMAGE) $(DOCKER_IMAGE):$(DOCKER_TAG) ;\
		docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
