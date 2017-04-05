# -*- coding: utf-8 -*-
# flake8: noqa
from qiniu import Auth, put_file, etag, urlsafe_base64_encode
import qiniu.config
import sys,os
input_argv = str(sys.argv[1])
file_path = input_argv
#需要填写你的 Access Key 和 Secret Key
access_key = 'xxxx'
secret_key = 'xxxxx'
domian_name = 'http://xxxxxx.bkt.clouddn.com/'
#构建鉴权对象
q = Auth(access_key, secret_key)
#要上传的空间
bucket_name = 'file'
#上传到七牛后保存的文件名
file_name = os.path.basename(file_path)
key = file_name;
#生成上传 Token，可以指定过期时间等
token = q.upload_token(bucket_name, key, 3600)
#要上传文件的本地路径
localfile = file_path
ret, info = put_file(token, key, localfile)
if ret is not None:
    print("Upload Success,url:")
    print("          " + domian_name + file_name)
else:
    print("info=", info)
    print("ret=", ret)

assert ret['key'] == key
assert ret['hash'] == etag(localfile)