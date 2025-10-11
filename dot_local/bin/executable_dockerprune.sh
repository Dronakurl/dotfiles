#!/bin/sh
# Prune docker containers, images, and volumes

docker container prune -f
docker image prune -f
docker volume prune -f
