FROM registry.cn-hangzhou.aliyuncs.com/bigdata_cloudnative/centos-jdk:7.7.1908

# install sshd
RUN yum install openssh openssh-clients -y
# 生成ssh密钥对
RUN ssh-keygen -f ~/.ssh/id_rsa -P '' -q

# 添加yum 源
COPY ambari.repo /etc/yum.repos.d/
COPY hdp.repo /etc/yum.repos.d/

# install client mysql
COPY mysql /usr/bin/

# add mysql-connector
# wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar
RUN mkdir /usr/share/java
COPY mysql-connector-java-5.1.39.jar /var/lib/ambari-server/resources/
COPY mysql-connector-java-5.1.39.jar /usr/share/java/
COPY mysql-connector-java-5.1.39.jar /usr/lib/ambari-server/

COPY init.sql /tmp/

COPY dbConfiguration.py /tmp/

# copy bootstrap.sh
COPY bootstrap.sh /opt/apache/
RUN chmod +x /opt/apache/bootstrap.sh

WORKDIR /opt/apache
