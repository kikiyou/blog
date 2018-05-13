
[参考](http://testing.freeideas.cz/subdom/testing/2017/01/04/prometheus-federation/)


Prometheus – federation

Setting federation between Prometheus instances is quite simple. See in following links:

[Federation in Prometheus documentation](https://prometheus.io/docs/operating/federation/)
[Settings on slaves](https://www.robustperception.io/scaling-and-federating-prometheus/)


Only small gotcha is when you try plain “/federate” link on your slave Prometheus you will get empty page. This is OK. You just have to use “match” condition like this:

1
http://localhost:9090/federate?match[]={__name__=~"[a-z].*"}
This version will show you all available metrics + you should see also external labels you added according to link 2. (Note: link contains placeholder “__name__” – underscores may not be visible in code highlighter.)

If you need to add more conditions it looks like this:

1
http://localhost:9090/federate?match[]={__name__=~"node.*"}&match[]={__name__=~"mysql.*"}
Point 2 shows how to configure external labels