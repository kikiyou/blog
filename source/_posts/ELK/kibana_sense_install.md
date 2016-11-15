---
title: kibana sense 插件 离线安装
date: 2016-10-30 11:31:44
tags: 
- elk
---
# kibana sense 离线安装
<!-- more -->
* 手动下载
https://download.elasticsearch.org/elastic/sense/sense-latest.tar.gz

* 安装
bin/kibana plugin -i sense -u file:///PATH_TO_SENSE_TAR_FILE

安装后要重启kibana 安装后要重启kibana 安装后要重启kibana
``` bash
Installing sense
Attempting to transfer from file:////tmp/20161025-182856-8340/sense-2.0.0-beta7.tar.gz
Transferring 1386775 bytes....................
Transfer complete
Extracting plugin archive
Extraction complete
Optimizing and caching browser bundles..
```

* 配置

sense.proxyConfig:
  - match:
      host: "*.internal.org" # allow any host that ends in .internal.org
      port: "{9200..9299}" # allow any port from 9200-9299

    ssl:
      ca: "/opt/certs/internal.ca"
      # "key" and "cert" are also valid options here

  - match:
      protocol: "https"

    ssl:
      verify: false # allows any certificate to be used, even self-signed certs

  # since this rule has no "match" section it matches everything
  - timeout: 180000 # 3 minutes