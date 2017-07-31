$ pip install virtualenv
$ virtualenv venv
$ source venv/bin/activate
(venv) $ pip install docker-compose
(venv) $ docker-compose --version
docker-compose version: 1.4.2


- name: "alerta"
  webhook_configs:
  - url: 'http://localhost:8080/api/webhooks/prometheus?api-key=dWo31pZXZXnhh12YYAT-7FQFxctwdlZz2kuaWTV9'
    send_resolved: true