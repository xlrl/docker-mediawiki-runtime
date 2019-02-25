FROM alpine:3.9
MAINTAINER Alexander Mueller <XelaRellum@web.de>

RUN apk update --no-cache

RUN apk upgrade --no-cache

RUN apk add --no-cache \
    libwebp icu-libs \
    php7 php7-apcu php7-ctype php7-curl php7-dom php7-fileinfo \
    php7-fpm php7-gd php7-gd php7-iconv php7-intl php7-json \
    php7-mbstring php7-mcrypt php7-mysqli php7-mysqlnd php7-openssl php7-pgsql \
    php7-phar php7-session php7-sqlite3 php7-xml php7-xmlreader \
    nginx supervisor

RUN set -xe && \
    mkdir -p /run/nginx && \
    mkdir -p /var/www

ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php7/php-fpm.ini && \
    sed -i -e "s|;daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf && \
    sed -i -e "s|listen\s*=\s*127\.0\.0\.1:9000|listen = /var/run/php-fpm7.sock|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i -e "s|;listen\.owner\s*=\s*|listen.owner = |g" /etc/php7/php-fpm.d/www.conf && \
    sed -i -e "s|;listen\.group\s*=\s*|listen.group = |g" /etc/php7/php-fpm.d/www.conf && \
    sed -i -e "s|;listen\.mode\s*=\s*|listen.mode = |g" /etc/php7/php-fpm.d/www.conf && \
    chmod +x /start.sh

EXPOSE 80
VOLUME ["/var/www"]

CMD /start.sh
