FROM arm64v8/nginx

VOLUME [ "/laravel" ]
WORKDIR /laravel
ENV ACCEPT_EULA=Y

RUN ln -fs /usr/share/zoneinfo/America/Rio_Branco /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt update && \
    apt -y upgrade && \
    echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen && \
    apt install -y ca-certificates \
                   apt-transport-https \
                   lsb-release \
                   gnupg \
                   curl \
                   wget \
                   vim \
                   dirmngr \
                   software-properties-common \
                   rsync \
                   gettext \
                   locales \
                   gcc \
                   g++ \
                   make \
                   unzip && \
    locale-gen && \
    curl -o /etc/apt/trusted.gpg.d/php.gpg -fSL "https://packages.sury.org/php/apt.gpg" && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list && \
    apt -y update && \
    apt -y install --allow-unauthenticated php8.2 \
                   php8.2-fpm \
                   php8.2-mysql \
                   php8.2-mbstring \
                   php8.2-soap \
                   php8.2-gd \
                   php8.2-xml \
                   php8.2-intl \
                   php8.2-dev \
                   php8.2-curl \
                   php8.2-zip \
                   php8.2-imagick \
                   php8.2-gmp \
                   php8.2-ldap \
                   php8.2-bcmath \
                   php8.2-bz2 \
                   php8.2-phar \
                   php8.2-sqlite3 \
                   gcc \
                   g++ \
                   autoconf \
                   libc-dev \
                   pkg-config && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    curl -s https://deb.nodesource.com/setup_16.x | bash && \
    apt-get update && \
    apt install nodejs -y && \
    npm install -g npm && \
    phpenmod 8.2  && \
    rm -rf /var/lib/apt/lists/* && \
    apt upgrade -y && \
    apt autoremove -y && \
    apt clean && \
    printf "# priority=30\nservice php8.2-fpm start\n" > /docker-entrypoint.d/30-php8.2-fpm.sh && \
    chmod 755 /docker-entrypoint.d/30-php8.2-fpm.sh && \
    chmod 755 /docker-entrypoint.d/30-php8.2-fpm.sh && \
    composer create-project laravel/laravel . && \
    chgrp -R www-data /laravel/storage /laravel/bootstrap/cache /laravel/storage/logs &&  \
    chmod -R ug+rwx /laravel/storage /laravel/bootstrap/cache /laravel/storage/logs

COPY config_cntr/php.ini /etc/php/8.2/fpm/php.ini
COPY config_cntr/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY config_cntr/nginx.conf /etc/nginx
COPY config_cntr/default.conf /etc/nginx/conf.d

