FROM centos:7
ADD * /root/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done);\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*;\
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /lib/systemd/system/sockets.target.wants/*udev*;\
rm -f /lib/systemd/system/sockets.target.wants/*initctl*;\
mkdir /www;\
cp /root/index.php /www/;\
cp /root/index.html /www/;\
mkdir /data;\
mkdir /data/mysql;\
useradd www;\
useradd mysql;\
chown -R www:www /www;\
chown -R mysql:mysql /data/mysql;\
# 全局准备
cp /root/epel-7.repo /etc/yum.repos.d/epel-ali.repo;\
yum install yum-fastestmirror git zip unzip -y;\
# 安装Nginx
## 1准备工作
yum install gcc-c++ make perl -y;\
## 2安装pcre
cd /root/pcre-8.39;\
./configure;\
make;\
make install;\
## 3安装zlib
cd /root/zlib-1.2.11;\
./configure;\
make;\
make install;\
## 4安装openssl
## (已经通过ADD解压，无需操作)
## 5安装nginx
cd /root/nginx-1.17.8;\
./configure \
--prefix=/usr/local/nginx/ \
--with-http_v2_module \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_stub_status_module \
--with-pcre=/root/pcre-8.39/ \
--with-zlib=/root/zlib-1.2.11/ \
--with-openssl=/root/openssl-1.0.2l;\
make;\
make install;\
cp /root/nginx.conf /usr/local/nginx/conf/nginx.conf;\
cp /root/nginx.service /etc/systemd/system/nginx.service;\
cp /root/nginx.service /etc/systemd/system/multi-user.target.wants/nginx.service;\
chown -R www:www /usr/local/nginx;\
# 安装php
## 1准备工作
yum install autoconf libxml2-devel openssl-devel re2c -y;\
## 2安装php
cd /root/php-7.3.14;\
./configure \
--prefix=/usr/local/php7 \
--enable-mysqlnd \
--with-openssl \
--enable-fpm;\
make;\
make install;\
cp /root/composer /usr/local/php7/bin/composer;\
cp /root/php.ini /usr/local/php7/lib/php.ini;\
cp /root/php-fpm.conf /usr/local/php7/etc/php-fpm.conf;\
cp /root/www.conf /usr/local/php7/etc/php-fpm.d/www.conf;\
cp /root/php7.service /etc/systemd/system/php7.service;\
cp /root/php7.service /etc/systemd/system/multi-user.target.wants/php7.service;\
chmod -R 755 /usr/local/php7/bin/composer;\
## 3扩展安装
### bcmath
cd /root/php-7.3.14/ext/bcmath;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### curl
yum install curl-devel -y;\
cd /root/php-7.3.14/ext/curl;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### gd
yum install libXpm-devel libpng-devel libjpeg-devel libwebp-devel freetype-devel -y;\
cd /root/php-7.3.14/ext/gd;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config \
--with-png-dir \
--with-xpm-dir \
--with-jpeg-dir \
--with-webp-dir \
--with-zlib-dir \
--with-freetype-dir;\
make;\
make install;\
### intl
yum install libicu-devel -y;\
cd /root/php-7.3.14/ext/intl;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### mbstring
cd /root/php-7.3.14/ext/mbstring;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### mcrypt
yum install libmcrypt-devel -y;\
cd /root/mcrypt-1.0.3;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### mysqli
cd /root/php-7.3.14/ext/mysqli;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### pdo_mysql
cd /root/php-7.3.14/ext/pdo_mysql;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### sockets
cd /root/php-7.3.14/ext/sockets;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### bz2
yum install bzip2-devel -y;\
cd /root/php-7.3.14/ext/bz2;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### zlib
cd /root/php-7.3.14/ext/zlib;\
cp config0.m4 config.m4;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### opcache
cd /root/php-7.3.14/ext/opcache;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### redis
cd /root/redis-3.1.2;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### memcached
yum install libmemcached-devel -y;\
cd /root/memcached-3.1.5;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config;\
make;\
make install;\
### swoole
cd /root/swoole-4.4.16;\
/usr/local/php7/bin/phpize;\
./configure --with-php-config=/usr/local/php7/bin/php-config --enable-sockets --enable-openssl --enable-http2 --enable-mysqlnd;\
make;\
make install;\
## 3目录权限
chown -R www:www /usr/local/php7;\
# 安装Nodejs
## 1安装Nodejs
cd /root;\
mv node-v13.9.0-linux-x64 /usr/local/node;\
## 2更新npm
/usr/local/node/bin/npm config set registry https://registry.npm.taobao.org -g;\
/usr/local/node/bin/npm install npm -g;\
## 3目录权限
chown -R www:www /usr/local/node;\
# 安装MySQL
## 1安装MySQL
cp /root/limits.conf /etc/security/limits.conf;\
cd /root/;\
rpm -ivh mysql57-el7-10.noarch.rpm;\
yum install mysql-server -y;\
cp /root/my.cnf /etc/my.cnf;\
cp /root/mysqld.service /usr/lib/systemd/system/mysqld.service;\
cp /root/mysqld.service /etc/systemd/system/multi-user.target.wants/mysqld.service;\
# 目录权限
cp /root/owner /usr/bin;\
chmod -R 755 /usr/bin/owner;\
cp /root/owner.service /usr/lib/systemd/system/owner.service;\
cp /root/owner.service /etc/systemd/system/multi-user.target.wants/owner.service;\
# 作者信息
cp /root/作者信息.md /作者信息.md;\
# 删除所有安装包
rm -rf /root/*
# 环境变量
ENV PATH $PATH:/usr/local/php7/bin:/usr/local/php7/sbin:/usr/local/nginx/sbin:/usr/local/node/bin
# 创建卷
VOLUME ["/www","/data/mysql","/sys/fs/cgroup"]
# 初始化
CMD ["/usr/sbin/init"]
