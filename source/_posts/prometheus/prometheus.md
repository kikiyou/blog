## prometheus 数据库使用

vi /prometheus.yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'

    static_configs:
      - targets: ['localhost:9090', 'localhost:9100']
        labels:
          group: 'prometheus'



启动一个数据库
mkdir -p /prometheus/data
docker run -d --net=host \
    -v /prometheus.yml:/etc/prometheus/prometheus.yml \
    -v /prometheus/data:/prometheus \
    --name prometheus-server \
    prom/prometheus


+ 导出数据
docker run -d -p 9100:9100 \
  -v "/proc:/host/proc" \
  -v "/sys:/host/sys" \
  -v "/:/rootfs" \
  --net="host" \
  --name=promethus \
  quay.io/prometheus/node-exporter:v0.13.0 \
    -collector.procfs /host/proc \
    -collector.sysfs /host/sys \
    -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"