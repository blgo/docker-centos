FROM blgo/centos-systemd:base
WORKDIR /tmp

RUN yum -y install \
    openssl-devel

RUN wget -nv https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm \
    && md5sum mysql80-community-release-el7-1.noarch.rpm \
    && rpm -ivh mysql80-community-release-el7-1.noarch.rpm \
    && rm -r mysql80-community-release-el7-1.noarch.rpm --force

RUN yum -y update \
    && yum -y install \
    mysql-devel \
    mysql-server 

RUN systemctl enable mysqld

RUN yum -y clean all

VOLUME /var/lib/mysql
EXPOSE 3306 33060