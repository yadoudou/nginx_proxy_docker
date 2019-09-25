FROM centos:7

RUN yum install -y patch gcc glibc-devel make openssl-devel pcre-devel zlib-devel gd-devel geoip-devel perl-devel

RUN groupadd -g 101 nginx \
          && adduser  -u 101 -d /var/cache/nginx -s /sbin/nologin  -g nginx nginx 

COPY ./workdir /workdir

WORKDIR /workdir

RUN tar -zxvf nginx-1.17.4.tar.gz && cd nginx-1.17.4 \
       && patch -p1 < /workdir/nginx_proxy/patch/proxy_connect_rewrite_101504.patch \
      && ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.17.1/debian/debuild-base/nginx-1.17.1=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' --add-module=/workdir/nginx_proxy \
     && make && make install \
    && cd /workdir && rm -rf /workdir/* 

CMD ["nginx", "-g", "daemon off;"]
