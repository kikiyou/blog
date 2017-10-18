for i in $(seq 20 50); do echo $i; done


for i in $(seq 20 50); do grep "2017:10:19 10:$i"  zzz_tomcat.log|wc -l ; done