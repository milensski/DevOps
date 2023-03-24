#!/bin/bash

docker run -d --name=prometheus -p 9090:9090 -v /vagrant/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus 
docker run -d --name=grafana -p 3000:3000 grafana/grafana