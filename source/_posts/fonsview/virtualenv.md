# python 虚拟环境
离线安装pip
wget http://7xw819.com1.z0.glb.clouddn.com/pip-9.0.1-py2.py3-none-any.whl
python pip-9.0.1-py2.py3-none-any.whl/pip install --no-index pip-9.0.1-py2.py3-none-any.whl

1. 安装
pip install virtualenv

2. 创建
virtualenv --no-site-packages venv

3. 使用虚拟环境

4. 推出虚拟环境
   deactivate

5. 单个软件包安装

pip install ansible  -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com