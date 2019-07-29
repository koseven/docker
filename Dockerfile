FROM ubuntu:18.04
MAINTAINER Koseven Team

# noninteractive to prevent user input forms
ARG DEBIAN_FRONTEND=noninteractive

# Set ENV treavis_test to 1 (true) - This can be used inside Unittests to detrmine the env
ENV TRAVIS_TEST=1;

# Install Required Packages
# First add 'deb-src' so we can 'build-dep'
# Update an upgrade system
# Install (without recommends and silent) basic system tools and required libs
# Compile imagemagick from source
# Add PHP 7.3 repository and install php7.3 with all required extensions
# Install imagick via pecl, otherwise it will install with Imagemagick v6 instead of v7
# Finally: install composer and configure services
RUN cp /etc/apt/sources.list /etc/apt/sources.list~ && \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -qq upgrade && \
    apt-get -qq install --no-install-recommends \
    apt-utils \
    software-properties-common \
    ca-certificates \
    language-pack-en \
    curl \
    unzip \
    wget \
    gcc \
    git \
    libcurl4-openssl-dev \
    libde265-dev \
    libwebp-dev \
    libmagic-dev \
    libmcrypt-dev \
    redis-server \
    webp && \
    apt-get -qq build-dep imagemagick && \
    wget https://www.imagemagick.org/download/ImageMagick.tar.gz && \
    tar xf ImageMagick.tar.gz && \
    cd ImageMagick-7* && \
    ./configure --with-webp=yes && \
    make && \
    make install && \
    ldconfig /usr/local/lib && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -qq install --no-install-recommends \
    php7.3 \
    php7.3-dev \
    php7.3-common \
    php7.3-cli \
    php7.3-mbstring \
    php7.3-gd \
    php7.3-mysql \
    php7.3-curl \
    php7.3-xml \
    php7.3-sqlite3 \
    php7.3-opcache \
    php7.3-pgsql \
    php7.3-mysql \
    php-xdebug \
    php-redis \
    php-pear \
    php-yaml \
    php-raphf \
    php-raphf-dev \
    php-propro \
    php-propro-dev \
    php-http \
    php-pecl-http \
    php-redis && \
    printf "\n" | pecl install imagick && \
    printf "\n" | pecl install mcrypt-1.0.2 && \
    echo "extension=imagick.so" > /etc/php/7.3/cli/php.ini && \
    echo "extension=mcrypt.so" > /etc/php/7.3/cli/php.ini && \
    curl -s https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    mkdir -p /tmp/koseven && \
    echo "requirepass password" >> /etc/redis/redis.conf && \
    sed -i "s/bind .*/bind 127.0.0.1/g" /etc/redis/redis.conf