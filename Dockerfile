FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
        curl \
        gnupg2 \
        ca-certificates \
        lsb-release \
&& echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list \
&& curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key \
&& gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key \
&& mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc \
&& apt-get update && apt-get install nginx
