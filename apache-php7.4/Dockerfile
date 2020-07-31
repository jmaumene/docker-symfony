FROM debian:buster
MAINTAINER jmaumene
ARG DEBIAN_FRONTEND=noninteractive

ARG HOST_NAME="hostname.local"

# Tools
RUN apt-get update \
&& apt-get install -y \
curl \
git \
wget \
vim

# Apache 2
RUN apt-get install -y \
apache2 \
ssl-cert
RUN rm /etc/apache2/sites-available/*
COPY sites-available/  /etc/apache2/sites-available/
RUN mkdir -p /etc/apache2/ssl/
RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/server.key -out /etc/apache2/ssl/server.crt -subj "/C=FR/ST=France/L=Paris/O=Docker/OU=Docker/CN=Docker"
RUN echo "Replace hostname.local with ${HOST_NAME} in apache sites conf"
RUN sed -i -r "s/hostname.local/${HOST_NAME}/g" /etc/apache2/sites-available/*
RUN echo "ServerName $HOST_NAME" >> /etc/apache2/apache2.conf
RUN a2ensite default-ssl.conf 000-default.conf
RUN a2enmod \
rewrite \
headers \
ssl \
proxy_fcgi \
setenvif

# PHP Package https://packages.sury.org/php/README.txt
RUN apt-get -y install apt-transport-https lsb-release ca-certificates curl
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt-get update

# Installation of php need dialog and apt-utils are installed before to configure mod
RUN apt-get install --no-install-recommends -y \
apt-utils \
dialog

# Symfony 5.0 Requirements
# https://symfony.com/doc/current/setup.html#technical-requirements
# Ctype, iconv, JSON, PCRE, Session, SimpleXML, and Tokenizer;
RUN apt-get install -y \
php7.4 \
php7.4-cli \
php7.4-fpm \
php7.4-ctype \
php7.4-iconv \
php7.4-json \
php7.4-xml \
php7.4-mbstring \
php7.4-intl \
php7.4-pgsql \
libpcre3 libpcre3-dev \
libapache2-mod-php7.4
RUN a2enmod php7.4

# Php xdebug
RUN apt-get install -y \
php-xdebug

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

# set locale to FR
RUN apt-get install --no-install-recommends -y \
locales
RUN locale-gen "fr_FR.UTF-8"
RUN export LC_ALL=fr_FR.UTF-8
RUN export LANG="fr_FR.UTF-8"

# Composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
&& chmod +x /usr/local/bin/composer
#RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
#&& chmod a+x /usr/local/bin/symfony

#Symfony
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv ~/.symfony/bin/symfony /usr/local/bin/symfony
# Clear apt cache
RUN rm -rf /var/lib/apt/lists/*

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html/
VOLUME /var/www/html/

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
