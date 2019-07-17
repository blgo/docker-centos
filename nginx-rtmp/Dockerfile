FROM blgo/centos-systemd:base
WORKDIR /tmp
# How To Setup Nginx For HLS Video Streaming On Centos 7:
# https://dev.to/samuyi/how-to-setup-nginx-for-hls-video-streaming-on-centos-7-3jb8

RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install git wget -q gcc gcc-c++ tar gd gd-devel perl-ExtUtils-Embed geoip geoip-devel
RUN yum -y install make

RUN wget -q ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.43.tar.gz
RUN tar -zxf pcre-8.43.tar.gz
RUN rm -rf pcre-8.43.tar.gz
WORKDIR /tmp/pcre-8.43
RUN ./configure
RUN make
RUN make install

WORKDIR /tmp
RUN wget -q http://zlib.net/zlib-1.2.11.tar.gz
RUN tar -zxf zlib-1.2.11.tar.gz
RUN rm -rf zlib-1.2.11.tar.gz
WORKDIR /tmp/zlib-1.2.11
RUN ./configure
RUN make
RUN make install

WORKDIR /tmp
RUN wget -q http://www.openssl.org/source/openssl-1.0.2q.tar.gz
RUN tar -zxf openssl-1.0.2q.tar.gz
RUN rm -rf openssl-1.0.2.tar.gz
WORKDIR /tmp/openssl-1.0.2q
RUN ./config
RUN make
RUN make install

WORKDIR /tmp
RUN git clone git://github.com/arut/nginx-rtmp-module.git

RUN wget -q https://nginx.org/download/nginx-1.14.2.tar.gz
RUN tar zxf nginx-1.14.2.tar.gz
RUN rm -rf nginx-1.14.2.tar.gz
WORKDIR /tmp/nginx-1.14.2
 
RUN ./configure  --add-module=../nginx-rtmp-module \
--sbin-path=/usr/sbin/nginx \ 
--lock-path=/var/run/nginx.lock \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/run/nginx.pid \   
--with-pcre=../pcre-8.43 \    
--with-zlib=../zlib-1.2.11 \  
--with-openssl=../openssl-1.0.2q \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--user=nginx \                 
--group=nginx \                
--with-http_auth_request_module \
--with-http_degradation_module \
--with-http_geoip_module \     
--with-http_gunzip_module \    
--with-http_gzip_static_module \
--with-http_image_filter_module \
--with-http_mp4_module \
--with-http_perl_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module  \
--with-http_stub_status_module \
--with-http_v2_module \
--with-stream_ssl_module \
--with-stream \
--with-threads \
--with-debug \
--prefix=/etc/nginx

RUN make 
RUN make install

RUN nginx -V #The output should be the Nginx version, compiler version, and configure script parameters.

RUN cp /tmp/nginx-1.14.2/man/nginx.8 /usr/share/man/man8
RUN gzip /usr/share/man/man8/nginx.8

WORKDIR /tmp
RUN rm -rf nginx-1.14.2 nginx-rtmp-module openssl-1.0.2q pcre-8.42 zlib-1.2.11

RUN useradd --system --home /var/lib/nginx --shell /sbin/nologin --comment "nginx system user" nginx
RUN chown nginx:nginx /var/log/nginx 
COPY nginx.service  /lib/systemd/system/nginx.service 
COPY nginx.conf  /etc/nginx/nginx.conf
RUN systemctl enable nginx

RUN mkdir -p /var/www/live/
RUN mkdir -p /var/www/hls/live
RUN wget -q https://archive.org/download/BigBuckBunny_124/Content/big_buck_bunny_720p_surround.mp4
RUN cp /tmp/big_buck_bunny_720p_surround.mp4 /var/www/live/sample.mp4

RUN wget -q https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
RUN tar xf ffmpeg-release-amd64-static.tar.xz --strip-components=1
RUN mv /tmp/ffmpeg  /usr/local/bin/
RUN mv /tmp/ffprobe  /usr/local/bin/
RUN ln -s /usr/local/bin/ffmpeg/ffmpeg /usr/bin/ffmpeg
RUN ln -s /usr/local/bin/ffmpeg/ffprobe /usr/bin/ffprobe #for ffprobe
RUN ffmpeg -version


WORKDIR /tmp
# CMD cannot be used in Centos 7 containers or it will not start /init command and therefore systemd wont work
# CMD ffmpeg -i /tmp/big_buck_bunny_720p_surround.mp4  -c:v h264 -c:a aac  -strict -2 -f flv rtmp://server_ip:1935/app/unique_stream_name 
# vlc http://localhost/live/unique_stream_key/index.m3u8
# vlc rtmp://localhost/vod/sample.mp4

# Start container - privileged mode:
# 
# docker run -it --privileged -e "container=docker" -v /sys/fs/cgroup:/sys/fs/cgroup:ro blgo/centos-systemd:base
# 
# Start container -without privileged mode (experimental):
# 
# docker run -it --tmpfs /tmp --tmpfs /run -e "container=docker" -v /sys/fs/cgroup:/sys/fs/cgroup:ro blgo/centos-systemd:base
# 
# Interact with the container:
# 
# docker exec -it container_name
# docker run -p 80:80 -p 1935:1935 -it --privileged  -e "container=docker" -v /sys/fs/cgroup:/sys/fs/cgroup:ro  0147711ead28

