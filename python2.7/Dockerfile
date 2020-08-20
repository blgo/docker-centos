FROM blgo/centos-systemd:base
RUN yum -y install gcc openssl-devel bzip2-devel make

WORKDIR /usr/src
RUN curl https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz -o Python.tgz \
    && tar xzf Python.tgz \
    && cd Python* \
    && ./configure --enable-optimizations \
    && make altinstall \
    && /usr/local/bin/python2.7 -V

RUN python2.7 -m ensurepip

RUN rm -r /usr/src/Python* --force \
    && yum -y remove gcc openssl-devel bzip2-devel make \
    && yum -y clean all

EXPOSE 443 4433 
