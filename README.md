# php开发镜像
|文件|说明|
|:---:|:---:|
|Dockerfile|生产环境|
|Dockerfile.dev|开发环境|
|Dockerfile.gocron| 生产环境+gocron-node |

## 构建Docker镜像
```shell
docker build -f Dockerfile.gocron -t peng49/php:gocron .
```
启动一个laravel项目

```shell
docker run -it -d -p 8080:80 -p 5921:5921 -v F://laravel:/var/www/html peng49/php:gocron 
```
