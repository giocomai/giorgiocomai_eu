---
title: Testing Wordpress with different php versions with docker-compose and traefik
author: ''
date: '2019-11-09'
slug: testing-wordpress-with-different-php-versions-with-docker-compose-and-traefik
categories:
  - tech
tags:
  - wordpress
subtitle: ''
summary: ''
authors: []
lastmod: '2019-11-09T16:33:07+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

*__2023 update__: if you are just looking for a basic and updated php-based Dockerfile for Wordpress, with its own Traefik-based docker-compose.yml, [check out this post](../2022-10-14-running-wordpress-with-docker-compose-and-traefik). If you are interested in testing older php versions, read on.*

---

As of Autumn 2019, many Wordpress users will likely have found a warning suggesting they *must* update php on their server. As [php 5.6 has reached end of life in 2018](https://haydenjames.io/php-5-6-eol-end-of-life-php-7-compatibility-check/), this is well needed. Yet, many Wordpress installations that have been running for years may be using a plugin or a theme that is not compatible with php 7.3. 

Being to some extent responsible for a number (undisclosed, but not negligible) of Worpress installations scattered across a number of servers, I needed a way to make sure that updates go smoothly, and be best-positioned to change back and forth between php versions to introduce all necessary fixes. 

As some of these websites have been around for many years, not all of them are currently using a secure connection, so I take this also as a chance to make sure they will all be on https after the update.

__Warning__: not much of what you'll find here follows best practices in terms of security or privacy. This works for me, and should work for some basic testing purposes, but... you have been warned.

## Step 1: Set up a basic Docker image with php 5.6 and php 7.3

The first step is to prepare a basic php Docker image with apache installed. I also installed some basic libraries such as zip and pdo which are used by a number of plugins. You may need to install others, keeping in mind that you need to take care of installing dependencies in the Dockerfile yourself.

You can safely^[*Safely*, that is, keeping in mind you'll be using a php version with known vulnerabilities] use the Docker images I created, `giocomai/php_5_6_20`. For more recent versions, you'll find `giocomai/php_7_3` and `giocomai/php_7_4`.


### Custom Dockerfile
Here's my full Dockerfile for php 5.6.20.

```
FROM php:5.6.20-apache

RUN apt-get update

RUN apt-get install -y libzip-dev zlib1g-dev php5-mysql

RUN docker-php-ext-install zip mysqli pdo pdo_mysql

RUN a2enmod rewrite

RUN service apache2 restart

```

Here's my full Dockerfile for php 5.6.40.


```
FROM php:5.6.40-apache

RUN apt-get update

RUN apt-get install -y libzip-dev zlib1g-dev 

RUN docker-php-ext-install mysql zip mysqli pdo pdo_mysql

RUN a2enmod rewrite

RUN service apache2 restart


```

And here's my full Dockerfile for php 7.3

```
FROM php:7.3-apache

RUN apt-get update

RUN apt-get install -y libzip-dev zlib1g-dev 

RUN docker-php-ext-install zip mysqli pdo pdo_mysql

RUN a2enmod rewrite

RUN service apache2 restart
```

Again, keep in mind that you'll need to install dependencies in your Dockerfile, so installing php extensions may not necessarily be as straightforward as expected. As usual, error messages and search engines are your friends.


This is, for example, what you'd need to get the IMAP php extension in the above php 7.3 image.

```

RUN apt-get install -y libc-client-dev libkrb5-dev
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

```

Finally [updated on 2020-04-30], here's a Dockerfile for 7.4 that includes imagick and gd modules, and does not raise any flags with the latest Worpress site health check. 

```
FROM php:7.4-apache

RUN apt-get update

RUN apt-get install -y libzip-dev zlib1g-dev 

#imagick
RUN apt-get -y install gcc make autoconf libc-dev pkg-config
RUN apt-get -y install libmagickwand-dev --no-install-recommends
RUN pecl install imagick
RUN docker-php-ext-enable imagick

RUN docker-php-ext-install zip mysqli pdo pdo_mysql gd exif

RUN rm -r /var/lib/apt/lists/*

RUN a2enmod rewrite

RUN service apache2 restart
```

[2022-10-14 - update with php 8]

```
FROM php:8.0-apache

RUN apt-get update

RUN apt-get install -y libzip-dev zlib1g-dev 

#imagick
RUN apt-get -y install gcc make autoconf libc-dev pkg-config
RUN apt-get -y install libmagickwand-dev --no-install-recommends
RUN pecl install imagick
RUN docker-php-ext-enable imagick

RUN docker-php-ext-install zip mysqli pdo pdo_mysql gd exif

RUN rm -r /var/lib/apt/lists/*

RUN a2enmod rewrite

RUN sed -i -e 's/Listen 80/Listen 80\nServerName localhost/' /etc/apache2/ports.conf

RUN service apache2 restart

EXPOSE 80

```
## Step 2: Get your docker-compose up and running

Here's a basic docker-compose.yml with Traefik that should get you up and running. Search for all instances of "example.com" and put your own domain. Make sure the relevant domain (or subdomain) points at your server. Also, make sure you set a random password for both database and wordpress host, and make sure they correspond (of course, e.g. the database name, user, and password you set up in the _db docker should be the same that Wordpress uses to access them). I also included a phpmyadmin Docker just in case, this can of course safely be removed. 


```
version: "3.3"

services:

  traefik:
    image: "traefik:v2.1"
    container_name: "traefik"
    restart: always
    command:
      #- "--log.level=DEBUG"
      - "--api"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myhttpchallenge.acme.httpchallenge=true"
      - "--certificatesresolvers.myhttpchallenge.acme.httpchallenge.entrypoint=web"
      #- "--certificatesresolvers.myhttpchallenge.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory"
      - "--certificatesresolvers.myhttpchallenge.acme.email=youremail@example.com"
      - "--certificatesresolvers.myhttpchallenge.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - "./letsencrypt:/letsencrypt"
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
    labels:
      - "traefik.enable=true"
      # global redirect to https
      - "traefik.http.routers.redirs.rule=hostregexp(`{host:.+}`)"
      - "traefik.http.routers.redirs.entrypoints=web"
      - "traefik.http.routers.redirs.middlewares=redirect-to-https"
      # middleware redirect
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
      # dashboard
      - "traefik.http.routers.traefik.rule=Host(`traefik.example.com`)"
      - "traefik.http.routers.traefik.service=api@internal"
      - "traefik.http.routers.traefik.tls.certresolver=myhttpchallenge"
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.middlewares=authtraefik"


  example_com_db:
    image: mysql:5.7
    volumes:
      - example_com_db:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: Ez2oogha5ogh4woh
      MYSQL_DATABASE: ieseehahF0oo
      MYSQL_USER: ii4eshaeZ9ta
      MYSQL_PASSWORD: lae7gia4MohW

  example_com:
    depends_on:
      - example_com_db
    image: giocomai/php_7_4:latest
    volumes:
      - example_com:/var/www/html/
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: example_com_db:3306
      WORDPRESS_DB_NAME: ieseehahF0oo
      WORDPRESS_DB_USER: ii4eshaeZ9ta
      WORDPRESS_DB_PASSWORD: lae7gia4MohW
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.example_com.rule=Host(`test.example.com`)"
      - "traefik.http.routers.example_com.entrypoints=websecure"
      - "traefik.http.routers.example_com.tls.certresolver=myhttpchallenge"

  phpmyadmin:
    depends_on:
      - example_com_db
    image: phpmyadmin/phpmyadmin:latest
    restart: always
    links:
      - example_com_db:db
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.phpmyadmin.rule=Host(`phpmyadmin.example.com`)"
      - "traefik.http.routers.phpmyadmin.entrypoints=websecure"
      - "traefik.http.routers.phpmyadmin.tls.certresolver=myhttpchallenge"

volumes:
  example_com:
  example_com_db:
  
```



## Step 3: Move your website with Wordpress Duplicator plugin


The installation will work fine, but as you'll move on to finalise your installation going to the admin part of your wordpress installation, it just won't work. 

This is due the fact that we're using a reverse proxy (i.e. Traefik), so as described in the [Wordpress documentation](https://wordpress.org/support/article/administration-over-ssl/) we need to add the following chunk __at the beginning__ of our wp-config.php file. [^1]

[^1]: I can't stress enough the __at the beginning__ part, since this is not mentioned in the official Wordpress documentation, and you'll get only silly error messages if you paste this code at the bottom of the wp-config.php file.


```
define('FORCE_SSL_ADMIN', true);
// in some setups HTTP_X_FORWARDED_PROTO might contain 
// a comma-separated list e.g. http,https
// so check for https existence
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
$_SERVER['HTTPS']='on';
```
