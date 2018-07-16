Register a new service with bash
$ curl --upload-file register_service.json \ 
http://localhost:8500/v1/agent/service/register
register_service.json
{
  "ID": "myservice1",
  "Name": "myservice",
  "Address": "127.0.0.1",
  "Port": 8080,
  "Check": {
    "Interval": "10s",
    "TTL": "15s"
  }
}


列出有那些服务：
curl http://sd.csk.rhel.cc:8500/v1/agent/services | python3 -m json.tool

查看对应服务的信息：
curl http://sd.csk.rhel.cc:8500/v1/health/service/host:sdjn-fhcdn-sec-lgs064-rh2288h-a2201 | python3 -m json.tool