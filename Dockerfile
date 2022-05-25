FROM php:8.0.10-cli-alpine3.14
ENV MAKEFLAGS "-j8"

ENV PHPIZE_DEPS \
        autoconf \
        dpkg-dev \
        dpkg \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        wget

RUN set -eux; \
        cd /; \
        apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
            icu-dev \
            libmcrypt-dev \
            libpng-dev \
            libxml2-dev \
            linux-headers \
            oniguruma-dev \
            procps \
            unzip \
            zip \
            libzip-dev \
            zlib-dev \
            zstd-dev \
            postgresql-libs \
            postgresql-dev
RUN set -eux; \
        cd /; \
        yes "" | pecl install  apcu-5.1.20 xdebug \
        ;\
        docker-php-ext-install intl; \
        docker-php-ext-install mbstring; \
        docker-php-ext-install opcache; \
        docker-php-ext-install zip; \
        docker-php-ext-install pcntl; \
        docker-php-ext-install sockets; \
        docker-php-ext-install sysvshm; \
        \
        docker-php-ext-enable apcu; \
        docker-php-ext-enable xdebug; \
        runDeps="$( \
                scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
                | tr ',' '\n' \
                | sort -u \
                | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        )"; \
        apk add --no-cache $runDeps; \
        apk del --no-network .build-deps; \
        rm -rf /var/www/html

# composer
RUN set -eu; \
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"; \
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; \
    then \
        >&2 echo 'ERROR: Invalid installer checksum'; \
        rm composer-setup.php; \
        exit 1; \
    fi; \
    php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer; \
    RESULT=$?; \
    rm composer-setup.php; \
    exit $RESULT;

RUN apk add bash supervisor

WORKDIR /var/www/html

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
