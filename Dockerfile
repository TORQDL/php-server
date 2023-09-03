FROM php:8.1-apache-bookworm

# get the UID variable passed in the build command. this will be the UID of the user/owner of the dist folder on the host machine
ARG UID
# get the GID variable passed in the build command. this will be the GID of the group/owner of the dist folder on the host machine
ARG GID

# setting the UID and GID environment variables to the values passed in the build command so that we can use them later in the Dockerfile
ENV UID=${UID}
ENV GID=${GID}

RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        zlib1g-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable mysqli
# setting the max_execution_time to 10800 seconds (3 hours) to allow for long running scripts, such as importing data from a database
RUN echo 'max_execution_time = 10800' >> /usr/local/etc/php/conf.d/docker-php-maxexectime.ini
RUN echo 'log_errors = On' >> /usr/local/etc/php/conf.d/docker-php-logerrors.ini
RUN echo 'error_log = /dev/stderr' >> /usr/local/etc/php/conf.d/docker-php-errorlog.ini

RUN mkdir -p /opt/.secrets
COPY .env/* /opt/.secrets/

# adding a group with the GID passed in the build command because no group with that GID exists in the container
RUN addgroup --gid ${GID} --system php-www-data
# changing the UID of the www-data user to match the UID that was passed in the build command to allow the www-data user to write to the host filesystem
RUN usermod --non-unique --uid ${UID} --gid ${GID} www-data
