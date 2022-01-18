## QQ群669756510

## 使用教程(Quick start)

### 下载(Download)
```
# 主流版本
## CentOS7 + Nginx + Node.js + MySQL + php-^7.4 + php5.6.40
docker pull 2233466866/lnmp
docker pull 2233466866/lnmp:1.13

# nosql版本
## CentOS7 + Nginx + Node.js + MySQL + php-^7.4 + php5.6.40 + Redis
docker pull 2233466866/lnmp:nosql
docker pull 2233466866/lnmp:1.13-nosql

# newest版本
## CentOS7 + Nginx + Node.js + MySQL + php-^8.1 + php-^7.4 + php5.6.40 + Redis
docker pull 2233466866/lnmp:newest

# mini版本
## CentOS7 + Nginx + php-^7.4
docker pull 2233466866/lnmp:mini
```

### 配置(Config)
```
# 配置文件路径(Config file path)
# Nginx
/usr/local/nginx/conf/nginx.conf

# MySQL
/etc/my.cnf

# Redis
/usr/local/redis/redis.conf

# php-5
/usr/local/php5/lib/php.ini
/usr/local/php5/etc/php-fpm.conf

# php-7
/usr/local/php7/lib/php.ini
/usr/local/php7/etc/php-fpm.conf
/usr/local/php7/etc/php-fpm.d/www.conf

# php-8
/usr/local/php8/lib/php.ini
/usr/local/php8/etc/php-fpm.conf
/usr/local/php8/etc/php-fpm.d/www.conf
```

### 启动(Start)
```
# 端口映射自行指定,容器名称自行指定为lnmp
docker run -dit --privileged=true --name=lnmp 2233466866/lnmp

# 高级用法(Advanced usage)
docker run -dit \
-p 80:80 \
-p 443:443 \
-p 3306:3306 \
-p 9000:9000 \
-v /宿主机自定义目录/www:/www \
-v /宿主机自定义目录/mysql:/data/mysql \
--privileged=true \
--name=lnmp \
2233466866/lnmp

# 如对配置文件比较熟悉，也可以通过宿主机挂载使用自定义的配置文件
```

### 连接(Connect)
```
# 容器名称与上一步保持一致
docker exec -it lnmp /bin/bash
```

### 状态(Status)
```
ps aux|grep nginx
ps aux|grep mysql
ps aux|grep php5
ps aux|grep php7
ps aux|grep php8
ps aux|grep redis
# 或者(Or)
systemctl status nginx
systemctl status mysqld
systemctl status php5
systemctl status php7
systemctl status php8
systemctl status redis
```

### 初始密码(Default password)
```
cat /var/log/mysqld.log|grep 'A temporary password'
# 或
password=`cat /var/log/mysqld.log|grep 'A temporary password'`;password=${password:91};echo $password
```

### 初始化(initialize)
```
如你的mysql数据是全新的，那么你可以在^1.11 or ^1.11-nosql版本中，使
用 mysql_init 脚本将数据库密码初始化为：ASDFqwer1234####，该脚本如无
法正常运行，请通过上一步获取的初始密码，用mysql_secure_installation
手动初始化mysql。
```

### 警告(Warning)
```
# 请保持清醒头脑，明确自己是在容器内还是在服务器本身执行命令，以及-v挂载对文件的影响，以免造成不可挽回的损失
```

### PHP扩展(PHP extension)
```
# 默认已安装部分扩展在目录：/usr/local/php7/lib/php/extensions/no-debug-non-zts-20170718/
# 如果要启用指定扩展，则需要修改php.ini，加上
extension=xxx.so
# xxx为PHP扩展的文件名，然后重启php
systemctl restart php7
```

### 版本(Version)
```
# 各版本详细信息请参考
https://github.com/2233466866/lnmp/wiki
```
