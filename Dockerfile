FROM centos:7

MAINTAINER Sam, sam@mixmedia.com

# Docker Build Arguments
ARG RESTY_VERSION="1.13.6.1"
ARG RESTY_CONFIG_OPTIONS="\
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "
RUN yum install -y \
        pcre-devel \
        openssl-devel \
        gcc \
        gd-devel \
        gettext \
        curl \
        GeoIP-devel \
        libxslt-devel \
        make \
        perl \
        perl-ExtUtils-Embed \
        readline-devel \
        unzip \
        zlib-devel \
    && cd /tmp \
    && curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -o openresty.tar.gz \
    && tar xzf ./openresty.tar.gz \
    && cd /tmp/openresty-${RESTY_VERSION} \
    && ./configure ${RESTY_CONFIG_OPTIONS} \
    && gmake \
    && gmake install \
    && yum remove -y gcc make \
    && yum autoremove -y \
    && yum clean all \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/bin/nginx \
    && ln -s /usr/local/openresty/bin/resty /usr/bin/resty \
    && cd /tmp \
    && rm -Rf ./*
