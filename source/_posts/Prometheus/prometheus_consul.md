#prometheus 使用consul做服务发现

prometheus配置：
scrape_configs:
  - job_name: node
    consul_sd_configs:
      - server: 'localhost:8500'
    relabel_configs: &DEFAULT_RELABEL
      - source_labels: [__meta_consul_tags]
        regex: .*,prod,.*
        action: keep
    #   - source_labels: [__meta_consul_service]
    #     target_label: job
     - source_labels: [__meta_consul_tags]
        regex: .*,job-([^,]+),.*
        replacement: '${1}'
        target_label: job
      - source_labels: [__meta_consul_tags]
        regex: '.*,cache=([^,]+),.*'
        replacement: '${1}'
        target_label: 'cache'
      - source_labels: [__meta_consul_tags]
        regex: '.*,group=([^,]+),.*'
        replacement: '${1}'
        target_label: 'group'

consul 配置：
以UI形式后台启动：
./consul agent -bind=172.16.12.41 -server -ui -bootstrap-expect 1 -data-dir /tmp/consul &

注册：
curl -X PUT -d '{"id": "node4","name": "node","address": "node4","port": 9104,"tags": ["prod","cache=CSX","group=济南节点"],"checks": [{"http": "http://node4:9104/","interval": "5s"}]}'     http://localhost:8500/v1/agent/service/register


ansible consul模块使用：
http://docs.ansible.com/ansible/latest/modules/consul_module.html


["prod","job-node","cache=CSX","group=济南节点"]


参考：
https://www.robustperception.io/finding-consul-services-to-monitor-with-prometheus/
https://www.robustperception.io/extracting-full-labels-from-consul-tags/


可以instance 和 __address__ 不一样，
__address__ 是ip ，id 是 主机名，最后把标签 替换为instance

id 设置成主机名，然后
      - source_labels: [__meta_consul_service_id]
        target_label: instance