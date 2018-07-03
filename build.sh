#!/bin/bash
sed -i "s/FROM hbase:.*/FROM hbase:$1/" hbase-master/Dockerfile
sed -i "s/FROM hbase:.*/FROM hbase:$1/" hbase-regionserver/Dockerfile
sed -i "s/FROM hbase:.*/FROM hbase:$1/" hbase-phoenix/Dockerfile

docker build -t hbase:$1 hbase/
docker build -t hbase-master:$1 hbase-master/
docker build -t hbase-regionserver:$1 hbase-regionserver/
docker build -t hbase-phoenix:$1 hbase-phoenix/

docker tag hbase:$1 docker-registry.infra.petr.kaz:5000/hbase:$1
docker tag hbase-master:$1 docker-registry.infra.petr.kaz:5000/hbase-master:$1
docker tag hbase-regionserver:$1 docker-registry.infra.petr.kaz:5000/hbase-regionserver:$1
docker tag hbase-phoenix:$1 docker-registry.infra.petr.kaz:5000/hbase-phoenix:$1

docker push docker-registry.infra.petr.kaz:5000/hbase:$1
docker push docker-registry.infra.petr.kaz:5000/hbase-master:$1
docker push docker-registry.infra.petr.kaz:5000/hbase-regionserver:$1
docker push docker-registry.infra.petr.kaz:5000/hbase-phoenix:$1
