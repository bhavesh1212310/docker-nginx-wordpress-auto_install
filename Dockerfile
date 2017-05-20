FROM ubuntu:16.04
MAINTAINER Nick

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install pwgen python-setuptools curl git nano sudo unzip openssh-server openssl vim htop
RUN apt-get -y install mariadb-server mariadb-client nginx php-fpm php-mysql 
RUN apt-get -y install php-xml php-mbstring php-bcmath php-zip php-pdo-mysql php-curl php-gd php-intl php-pear php-imagick php-imap php-mcrypt php-memcache php-apcu php-pspell php-recode php-tidy 
#RUN apt-get -y install ruby-full 
#RUN apt-get -y install build-essential curl git m4  texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev

#guard sass
#RUN gem install bundler sass 
#RUN ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
#RUN echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> .bashrc
#RUN echo 'export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"' >> .bashrc
#RUN echo 'export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"' >> .bashrc
#RUN brew install node
#RUN npm install grunt-cli grunt-contrib-watch sass-autoprefixer



RUN sed -i -e"s/user\s*www-data;/user topix www-data;/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i -e "s/user\s*=\s*www-data/user = topix/g" /etc/php/7.0/fpm/pool.d/www.conf

ADD ./nginx-site.conf /etc/nginx/sites-available/default
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
#ADD ./supervisord.conf /etc/supervisord.conf


# Add system user for topix
RUN useradd -m -d /home/topix -p $(openssl passwd -1 'topix') -G root -s /bin/bash topix \
    && usermod -a -G www-data topix \
    && usermod -a -G sudo topix \
    && ln -s /usr/share/nginx/www /home/topix/www

RUN mkdir /home/topix/site \
    && touch /home/topix/site/index.php \
    && echo "Hello World" > /home/topix/site/index.php \
    && mv /home/topix/site /usr/share/nginx/www

RUN chown -R topix:www-data /usr/share/nginx/www \
    && chmod -R 775 /usr/share/nginx/www

RUN curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar;\
	chmod +x wp-cli.phar;\
	mv wp-cli.phar /usr/bin/wp
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
EXPOSE 80
EXPOSE 22
CMD ["/bin/bash", "/start.sh"]
ADD ./wp-content/plugins /usr/share/nginx/www/wp-content/plugins
ADD ./wp-content/themes /usr/share/nginx/www/wp-content/themes
