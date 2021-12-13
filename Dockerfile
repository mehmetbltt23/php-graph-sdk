ARG PHP_VERSION=8.0
ARG COMPOSER_VERSION=2.1.3

FROM composer:${COMPOSER_VERSION}
FROM php:${PHP_VERSION}-fpm

RUN apt-get update && \
      apt-get install -y autoconf pkg-config \
                curl \
                libmemcached-dev \
                libz-dev \
                libpq-dev \
                libzip-dev \
                zlib1g-dev \
                libfreetype6-dev \
                libssl-dev \
                libmcrypt-dev \
                vim \
                unzip \
                locales \
                zip \
                libonig-dev \
                libcurl4-openssl-dev pkg-config libssl-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install the PHP xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install the PHP mbstring
RUN docker-php-ext-install mbstring && docker-php-ext-enable mbstring

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

EXPOSE 9000

WORKDIR /var/www

COPY . .

CMD ["php-fpm"]
