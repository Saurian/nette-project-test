FROM ubuntu:21.04
MAINTAINER Pavel Paulik <p.paulik@pixman.cz>

#ARG CACHEBUST=1

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get  update
RUN apt-get  upgrade -y
RUN apt-get install -y software-properties-common

# pro spravne nastaveni casove zony
RUN apt-get install tzdata -y
ENV DATE_TIMEZONE "Europe/Prague"
ENV TIME_ZONE "Europe/Prague"
ENV TZ "Europe/Prague"

ADD debconf.selections /tmp/debconf.selections
RUN debconf-set-selections /tmp/debconf.selections

RUN add-apt-repository ppa:ondrej/php

# Install selected extensions and other stuff
RUN apt-get  -o Acquire::Check-Valid-Until=false update \
    && apt-get -y --no-install-recommends install git curl unzip php8.0-mbstring php8.0-mysql php-redis php8.0-bz2 php8.0-gd php-imagick php8.0-imap php8.0-soap php8.0-tidy php-xmlrpc php8.0-xsl \
        php-xdebug \
    	php8.0-cgi \
    	php8.0-cli \
    	php8.0-common \
    	php8.0-curl \
    	php8.0-dev \
    	php8.0-enchant \
    	php8.0-fpm \
    	php8.0-gmp \
    	php8.0-imap \
    	php8.0-interbase \
    	php8.0-intl \
    	php-json \
    	php8.0-ldap \
    	php8.0-opcache \
    	php8.0-phpdbg \
    	php8.0-pspell \
    	php8.0-readline \
    	php8.0-sqlite3 \
    	php8.0-zip \
    	php8.0-sybase

RUN apt-get install apache2 libapache2-mod-php8.0 -y
#RUN apt-get install mysql-server -y
RUN apt-get install mariadb-common mariadb-client -y
RUN apt-get install nano curl -y
RUN apt-get install openssl -y
RUN apt-get install imagemagick -y
RUN apt-get install -y sendmail
RUN apt-get install -y redis
RUN apt-get install -y cron
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install composer tree -y
#RUN npm install -g sass
#RUN npm cache verify
#RUN npm i -g npm
#RUN npm i

ADD sendmail.ini /usr/local/etc/php/conf.d/

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV TERM dumb

ADD run-server.sh /tmp/run-server.sh
RUN chmod a+x /tmp/run-server.sh

RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers

RUN chown -R www-data:www-data /var/www/html
#RUN chmod -R 777 /var/www/log


#ADD cron/root /etc/cron.d/root
#RUN chown root:root -R /etc/cron.d
#RUN chmod 0644 -R /etc/cron.d
#RUN touch /var/log/cron.log
#RUN crontab /etc/cron.d/root

EXPOSE 80
EXPOSE 443
EXPOSE 6379

ENTRYPOINT ["/tmp/run-server.sh"]
#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
