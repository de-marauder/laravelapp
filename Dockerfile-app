FROM php:fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    gnupg2 \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    libonig-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd \
    --with-jpeg=/usr/include/ \
    --with-freetype=/usr/include/ 
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 appuser
RUN useradd -u 1000 -ms /bin/bash -g appuser appuser

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=appuser:www-data . /var/www

# Change current user to www
USER appuser

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

