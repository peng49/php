FROM php:7.4-fpm

COPY . /docker

RUN apt-get update && apt-get install -y \
        curl \
        gnupg2 \
        ca-certificates \
        lsb-release \
&& echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list \
&& \
        NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
        found=''; \
        for server in \
                ha.pool.sks-keyservers.net \
                hkp://keyserver.ubuntu.com:80 \
                hkp://p80.pool.sks-keyservers.net:80 \
                pgp.mit.edu \
        ; do \
                echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
        apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
apt-get update && apt-get install nginx \
&& pecl install redis-5.1.1 && docker-php-ext-enable redis && docker-php-ext-install pdo_mysql &&  \
    apt-get install -y librabbitmq-dev libldb-dev libldap2-dev && \
    pecl install amqp-1.11.0 && \
    docker-php-ext-enable amqp && \
    docker-php-ext-install ldap && \
    cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /usr/local/etc/php/php.ini

# run shell script
RUN sed -i 's/\r//g' /docker/setting.sh && bash /docker/setting.sh && \
     cp /docker/entrypoint.sh /entrypoint.sh && sed -i 's/\r//g' /entrypoint.sh

EXPOSE 80
VOLUME /var/www/html
VOLUME /etc/nginx

ENV TZ="Asia/Shanghai"

ENTRYPOINT ["/entrypoint.sh"]
