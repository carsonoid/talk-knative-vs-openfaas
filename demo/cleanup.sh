#!/bin/bash

docker-compose kill

# Delete containers and volumess
docker-compose down -v
