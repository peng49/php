#!/usr/bin/env bash
# 启动php-fpm
php-fpm --daemonize

# 已守护进程的方式启动nginx
nginx

# 如果存在gocron-node,自动启动
if [ -f /app/gocron-node ]
then
  nohup /app/gocron-node -allow-root > /var/log/gocron-node.log 2>&1 &
fi

chown -R apache:root /var/www/html

tail -f /var/log/nginx/access.log
