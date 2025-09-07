#!/bin/bash
docker ps --format 'table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Command}}'
