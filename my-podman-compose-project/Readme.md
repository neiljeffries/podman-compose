# Run the below command from the same directory this file is in.
podman-compose up -d

# use this datasource url in the grafana > prometheus settings
http://host.containers.internal:9090

# Force image rebuild (ignore cache):
podman-compose build --no-cache app
podman-compose up -d app