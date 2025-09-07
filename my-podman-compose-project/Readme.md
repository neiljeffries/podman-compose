# Podman + Grafana + Prometheus + Spring Boot

## PODMAN

- Force image rebuild (ignore cache):
  podman-compose build --no-cache app

- Prepare Prometheus config with your Windows host IP:
  powershell -ExecutionPolicy Bypass -File .\resolve-windows-host-ip.ps1

- Start stack:
  podman-compose up -d

- Reload Prometheus:
  podman-compose restart prometheus

- Grafana Prometheus datasource URL (inside pod):
  <http://localhost:9090>

## DOCKER

- Grafana Prometheus datasource URL (Docker Desktop):
  <http://host.docker.internal:9090>

- Run an oracle image dynamically:
  docker run --rm -e ORACLE_PASSWORD=oracle gvenzl/oracle-xe:21-slim-faststart

- If you don't have a Dockerfile, run this from root project directory to create one:
  docker init