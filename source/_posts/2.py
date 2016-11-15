# -*- coding: utf-8 -*-
import sys, urllib, urllib2, json

url = 'http://apis.baidu.com/3023/time/time'


req = urllib2.Request(url)

req.add_header("apikey", "55dff40f36e04edc8c3e79bd0ae85798")

resp = urllib2.urlopen(req)
content = resp.read()
if(content):
    print(content)
