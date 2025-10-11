#!/bin/sh
# Prune all docker containers, images, and system

docker container prune -f
docker image prune -f
docker system prune -a -f
