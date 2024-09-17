#!/bin/bash

dockerUserName="rkuzner"
imageVersion="0.1.1"

# to run this commands, you should be logged to docker-hub!
#docker login -u ${dockerUserName}

# build platform specific images
docker build --platform linux/amd64 -t ${dockerUserName}/docker-organize:${imageVersion}-amd64 .
docker push ${dockerUserName}/docker-organize:${imageVersion}-amd64

docker build --platform linux/arm64 -t ${dockerUserName}/docker-organize:${imageVersion}-arm64 .
docker push ${dockerUserName}/docker-organize:${imageVersion}-arm64

# create version specific manifest
docker manifest create ${dockerUserName}/docker-organize:${imageVersion} \
--amend ${dockerUserName}/docker-organize:${imageVersion}-amd64 \
--amend ${dockerUserName}/docker-organize:${imageVersion}-arm64

docker manifest push ${dockerUserName}/docker-organize:${imageVersion}

# create latest manifest
docker manifest create ${dockerUserName}/docker-organize:latest \
--amend ${dockerUserName}/docker-organize:${imageVersion}-amd64 \
--amend ${dockerUserName}/docker-organize:${imageVersion}-arm64

docker manifest push ${dockerUserName}/docker-organize:latest
