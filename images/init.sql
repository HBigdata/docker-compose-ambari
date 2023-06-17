# 创建数据库
CREATE DATABASE IF NOT EXISTS ambari default charset utf8 COLLATE utf8_general_ci;
CREATE DATABASE IF NOT EXISTS hive default charset utf8 COLLATE utf8_general_ci;
CREATE DATABASE IF NOT EXISTS oozie default charset utf8 COLLATE utf8_general_ci;

# 创建 ambari 用户
CREATE USER 'ambari'@'%'IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON ambari.* TO 'ambari'@'%';

#创建 hive用户
CREATE USER 'hive'@'%'IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON hive.* TO 'hive'@'%';

# 创建 oozie 用户
CREATE USER 'oozie'@'%'IDENTIFIED BY 'oozie';
GRANT ALL PRIVILEGES ON *.* TO 'oozie'@'%';
FLUSH PRIVILEGES;
