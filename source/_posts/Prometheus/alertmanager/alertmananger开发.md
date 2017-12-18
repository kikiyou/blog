---
go get -u github.com/prometheus/promu

make build BINARIES=alertmanager
------
monkey ➜  alertmanager git:(master) ./alertmanager -version
alertmanager, version 0.11.0 (branch: master, revision: d75ff37a387672560e9445cd456ff5325dc6da58)
  build user:       monkey@monkey.fonsview.com
  build date:       20171215-03:28:27
  go version:       go1.9.2