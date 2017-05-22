FROM ubuntu:16.04

MAINTAINER Martian At Work <deshmukhn8gmail.com>

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list;\
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list;\
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list;\
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list


RUN export DEBIAN_FRONTEND=noninteractive;\
	apt-get update;\
	apt-get -qq install mariadb-server mariadb-client \
	php-fpm php-mysqlnd php-mcrypt php-cli \
	nginx-full \
	curl openssh-server

RUN apt-get -y install pwgen python-setuptools git nano sudo unzip  openssl vim htop

RUN mkdir /var/run/sshd;\
	echo "root:root"|chpasswd;\
	sed -i 's|session.*required.*pam_loginuid.so|session optional pam_loginuid.so|' /etc/pam.d/sshd;\
	echo LANG="en_US.UTF-8" > /etc/default/locale

RUN curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar;\
	chmod +x wp-cli.phar;\
	mv wp-cli.phar /usr/bin/wp

RUN sed -i '0,/listen.*=.*/ s/listen.*=.*/listen=127.0.0.1:9000/' /etc/php/7.0/fpm/pool.d/www.conf;\
	sed -i 's|;cgi.fix_pathinfo.*=.*|cgi.fix_pathinfo=0|' /etc/php/7.0/fpm/php.ini;\
	sed -i 's|;date.timezone.*=.*|date.timezone=Europe/Sofia|' /etc/php/7.0/fpm/php.ini

RUN useradd -m -d /home/topix -p $(openssl passwd -1 'topix') -G root -s /bin/bash topix \
    && usermod -a -G www-data topix \
    && usermod -a -G sudo topix


RUN mkdir -p /var/www/wordpress;\
	chown -R www-data:www-data /var/www;\
	chmod 0755 /var/www

ADD nginx.conf /etc/nginx/sites-available/default

ADD start.sh /
ADD start-all.sh /
EXPOSE 80 22

RUN cd /
RUN chmod +x start*

CMD ["sh", "/start-all.sh"]
ADD ./wp-content/plugins /var/www/wordpress/wp-content/plugins
ADD ./wp-content/themes /var/www/wordpress/wp-content/themes

