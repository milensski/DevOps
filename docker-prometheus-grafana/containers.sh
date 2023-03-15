#!/bin/bash


docker build -t goprom /vagrant/goprom/.


docker run -d --name=goprom1 -p 8081:8080 goprom
docker run -d --name=goprom2 -p 8082:8080 goprom
docker run -d --name=prometheus -p 9090:9090 -v /vagrant/prometheus:/etc/prometheus prom/prometheus
docker run -d --name=grafana -p 3000:3000 grafana/grafana