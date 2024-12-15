# Learn How to Install Prometheus and Grafana using Docker.

## Step-by-Step Guide to Install Prometheus on Docker:

1. **Create a Docker network for Prometheus and Grafana:**
    ```bash
        docker network create monitoring
        # Note: You can use default network space
    ```
2. **Create a Prometheus configuration file named `prometheus.yml`:**
    ```yaml
        global:
        scrape_interval: 15s

        scrape_configs:
        - job_name: 'prometheus'
            static_configs:
            - targets: ['localhost:9090']
    ```
3. **Create a Docker Compose file named `docker-compose.yml`:**
    ```yml
        version: '3'
        services:
        prometheus:
            image: prom/prometheus
            ports:
            - 9090:9090
            volumes:
            - ./prometheus.yml:/etc/prometheus/prometheus.yml # give the proper path
            networks:
            - monitoring

        networks:
        monitoring:
            external: true
    ```
4. **nstalling Grafana on Docker:**
    ```yml
        version: '3'
        services:
        prometheus:
            image: prom/prometheus
            ports:
            - 9090:9090
            volumes:
            - ./prometheus.yml:/etc/prometheus/prometheus.yml # give the proper path
            networks:
            - monitoring

        grafana:
            image: grafana/grafana
            ports:
            - 3000:3000
            environment: # either mention or not
            - GF_SECURITY_ADMIN_PASSWORD=your_password
            networks:
            - monitoring

        networks:
        monitoring:
            external: true
    ```
5. **Run Docker Compose configuration:**
    ```bash
        docker-compose up -d
    ```
6. **Access the Prometheus and Grafana services:**
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000`