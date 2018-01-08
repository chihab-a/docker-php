FROM debian:stretch-slim

MAINTAINER Chihab ASRIH <chihab.asrih@gmail.com>

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 wget apt-transport-https lsb-release ca-certificates

RUN set -x \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y php7.2-fpm

# Install composer
RUN php -r 'readfile("https://getcomposer.org/installer");' > composer-setup.php \
	&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
	&& rm composer-setup.php

# Clean up
RUN apt-get remove --purge --auto-remove -y gnupg1 wget apt-transport-https lsb-release ca-certificates \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get clean

COPY php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf

EXPOSE 9000
CMD ["php"]