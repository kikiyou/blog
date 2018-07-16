# mtail 的使用

简单使用：
monkey ➜  mtail cat linecounter.mtail
# simple line counter
counter line_count
/$/ {
  line_count++
}

###################################
touch test.log

./mtail_exporter --progs linecounter.mtail --logs test.log

echo "111" >> test.log

查看指标:
curl http://127.0.0.1:3903/metrics