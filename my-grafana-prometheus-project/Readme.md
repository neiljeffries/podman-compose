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

---

## VS Code quick start

- In the `podman-compose` folder, press Ctrl+Shift+B to run the default task “Dev: start stack + app”. This:
  - Generates Prometheus config for your Windows host IP
  - Starts Prometheus and Grafana
  - Runs Spring Boot locally with debug on port 5005
- To attach a debugger, open the Spring project and use “Debug (Attach) Spring Boot: DemoApplication”.

## Two ways to run the app

- External app (developer mode):
  - Use task “Podman: up (external)” or run `scripts/up-external.bat`.
  - Prometheus scrapes your locally running Spring Boot at `<http://localhost:8080/actuator/prometheus>`.
- In‑pod app (compose profile `app`):
  - Use task “Podman: up (with app)” or run `scripts/up-with-app.bat`.
  - Requires env vars (put these in a `.env` next to `docker-compose.yml`):
    - `APP_BUILD_CONTEXT=../spring-boot-micrometer-docker` (path to Spring project)
    - `MYSQL_PASSWORD=changeme`

## Useful URLs

- Grafana: <http://localhost:3000> (default login admin/admin on first run; you will be prompted to change)
- Prometheus: <http://localhost:9090>
- Spring Boot actuator: <http://localhost:8080/actuator/health>
- Spring Prometheus metrics: <http://localhost:8080/actuator/prometheus>

## Operations

- Reload Prometheus config: task “Podman: prometheus reload” (sends HUP)
- Logs: tasks “Podman: logs (compose services)” or “Podman: pod logs”
- Status: task “Podman: pod status”
- Stop: task “Podman: stop”
- Down (keep volumes): task “Podman: down”
- Clean volumes: task “Podman: clean volumes” (removes named volumes)


## Notes

- The compose service `app` expects `MYSQL_PASSWORD` if you run it in the pod.
- Memory settings for the in‑pod app can be tuned via `JAVA_TOOL_OPTIONS` in `docker-compose.yml`.
- See `scripts/README.md` for a description of all helper scripts.