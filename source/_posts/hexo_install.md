# hexo 安装方法

``` bash
1.
sudo dnf install npm
2. 配置 淘宝 npm软件源
#####
$ echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"' >> ~/.zshrc && source ~/.zshrc
#####
3. 
sudo npm install hexo -g
4.
hexo # 測試 hexo 是否被正確安裝
5.
建置你的 Hexo Blog
hexo init Blog
cd Blog
npm install

6.
npm install hexo-renderer-ejs --save
npm install hexo-renderer-marked --save
npm install hexo-renderer-stylus --save

7.
hexo g  # 產生 blog
hexo s  # 讓 blog 可以在 local 端檢視
```