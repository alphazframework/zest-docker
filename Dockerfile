FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties

RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y curl apt-transport-https apt-utils curl git-core php7.2-cli php7.2-mysql php7.2-curl
RUN apt-get install -y php7.2-xml php7.2-dom php7.2-xsl php7.2-json php7.2-mbstring php7.2-zip
RUN apt-get install -y libcurl3-openssl-dev apache2 libapache2-mod-php7.2

RUN apt-get clean

RUN cd /root && curl -sS https://getcomposer.org/installer | php
RUN cd /var/www/html && php /root/composer.phar create-project -n zest/zest:dev-master blog
RUN chown -R www-data:www-data /var/www/html/blog

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
RUN a2enmod php7.2 && a2enmod rewrite

ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD php-dev.ini /etc/php/7.2/apache2/php.ini

EXPOSE 80
CMD apachectl -D FOREGROUND
