1. 列出当前系统的依赖
pip freeze  > requirements.txt

2. 打包当前依赖的软件包
mkdir pkg
mv requirements.txt  pkg
cd pkg
pip download -r requirements.txt --trusted-host mirrors.aliyun.com


3. 部署
1. 安装python3
2. 安装pip
cd pkg/
python pip-9.0.1-py2.py3-none-any.whl/pip install --no-index pip-9.0.1-py2.py3-none-any.whl

3. 安装源码
pip install -r ./pkg/requirements.txt --no-index --find-links=./pkg/
