
### PODMAN:
# Run the below command from the same directory this file is in.
podman-compose up -d

# Force image rebuild (ignore cache):
podman-compose build --no-cache app

# for podman, use this datasource url in the grafana > prometheus settings
http://host.containers.internal:9090







### DOCKER:
# for docker, use this datasource url in the grafana > prometheus settings
http://host.docker.internal:9090

# Run an oracle image dynamically:
docker run --rm -e ORACLE_PASSWORD=oracle gvenzl/oracle-xe:21-slim-faststart

# if you don't have a docker file, run this from root project directory to create one.
docker init