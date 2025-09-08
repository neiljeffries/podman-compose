# Scripts overview

All scripts assume they are run from this repo via VS Code tasks or by double‑clicking. Each script pushes to the project root, executes, then pauses.

- up.bat — Resolve Windows host IP and write `prometheus.yml`, then `podman-compose up -d`.
- up-external.bat — Generate `prometheus.yml` pointing to an app running on your Windows host (outside the pod), then `podman-compose up -d`.
- up-with-app.bat — Use internal template and start stack with the `app` profile (`podman-compose --profile app up -d`).
- stop.bat — Stop containers without removing them (`podman-compose stop`).
- down.bat — Bring down the stack, keep volumes (`podman-compose down`).
- rebuild-clean.bat — Down with volumes, rebuild images without cache (app), then start (`up -d`).
- build-app.bat — Build only the `app` image (`podman-compose build app`).
- restart-pod.bat — Restart the Podman pod `monitoring-pod`.
- restart-containers.bat — Restart compose services `prometheus grafana app`.
- prometheus-reload.bat — Send HUP to Prometheus to reload config (`kill -HUP 1`).
- logs.bat — Tail compose logs for all services (`podman-compose logs -f`).
- pod-status.bat — Show pod status and containers.
- pod-logs.bat — Tail logs for pod `monitoring-pod`.
- shell-app.bat — Open a shell in the `app` container.
- shell-grafana.bat — Open a shell in the `grafana` container.
- shell-prometheus.bat — Open a shell in the `prometheus` container.
- open-ui.bat — Open Grafana, Prometheus, and app actuator URLs in your browser.
- resolve-windows-host-ip.ps1 — PowerShell helper that detects your Windows host IP and writes `prometheus.yml` from template.
