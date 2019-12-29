#!/bin/bash
source env.sh
docker build --build-arg HAPROXY_VERSION=$HAPROXY_VERSION -t brunneis/haproxy .
docker tag brunneis/haproxy brunneis/haproxy:$(echo $HAPROXY_VERSION | cut -c1-3)

docker push brunneis/haproxy:latest
docker push brunneis/haproxy:$HAPROXY_VERSION
docker push brunneis/haproxy:$(echo $HAPROXY_VERSION | cut -c1-3)
