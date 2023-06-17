#!/bin/bash

mysql_host=mysql-test
mysql_passwd=123456
mysql_port=3306

ambari_db=ambari
ambari_username=ambari
ambari_password=ambari
java_home=/opt/apache/jdk1.8.0_212
mysql_driver=/usr/share/java/mysql-connector-java-5.1.39.jar

wait_for() {
    echo Waiting for $1 to listen on $2...
    while ! nc -z $1 $2; do echo waiting...; sleep 1s; done
}

setup_ambari() {
  # 强制替换文件
  cp -f /tmp/dbConfiguration.py /lib/ambari-server/lib/ambari_server/dbConfiguration.py
  yum -y install expect >/dev/null 2>&1
  expect -c "
      set timeout -1;
      spawn ambari-server setup;
      expect {
          continue*                                                     {send -- y\r;exp_continue;}
          Customize*                                                    {send -- y\r;exp_continue;}
          Change*                                                       {send -- n\r;exp_continue;}
          daemon*                                                       {send -- ambari\r;exp_continue;}
          change*                                                       {send -- y\r;exp_continue;}
          choice*                                                       {send -- 2\r;exp_continue;}
          JAVA_HOME*                                                    {send -- $java_home\r;exp_continue;}
          LZO*                                                          {send -- y\r;exp_continue;}
          configuration*                                                {send -- y\r;exp_continue;}
          choice*                                                       {send -- 2\r;exp_continue;}
          Hostname*                                                     {send -- ${mysql_host}\r;exp_continue;}
          Port*                                                         {send -- ${mysql_port}\r;exp_continue;}
          Database*                                                     {send -- ${ambari_db}\r;exp_continue;}
          Username*                                                     {send -- ${ambari_username}\r;exp_continue;}
          Password*                                                     {send -- ${ambari_password}\r;exp_continue;}
          Re-enter*                                                     {send -- ${ambari_password}\r;exp_continue;}
          driver*                                                       {send -- ${mysql_driver}\r;exp_continue;}
          connection*                                                   {send -- y\r;exp_continue;}
          eof                                                           {exit 0;}
      };"
}

# wait for mysql and httpd
wait_for mysql-test 3306
wait_for httpd 80

# 开始ambari安装
yum -y install ambari-server

re=`mysql -uroot -h${mysql_host} -p${mysql_passwd} -P${mysql_port} -e "show databases"|grep ambari|wc -l`
if [ $re -eq 0 ];then
   # sql 初始化
   mysql -uroot -h${mysql_host} -p${mysql_passwd} -P${mysql_port} </tmp/init.sql
   mysql -uroot -h${mysql_host} -p${mysql_passwd} -P${mysql_port} ${ambari_db}  </var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql
fi

# 配置
setup_ambari

# 启动ambari服务
/usr/sbin/ambari-server start

# 输出公钥
cat ~/.ssh/id_rsa

tail -f /var/log/ambari-server/ambari-server.log
