---
title: Running Wordpress with php 8, docker-compose, and traefik
author: ''
date: '2022-10-14'
categories:
  - tech
tags:
  - wordpress
subtitle: ''
summary: ''
authors: []
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

This is an update of [a previous post](../testing-wordpress-with-different-php-versions-with-docker-compose-and-traefik) on running a fresh Wordpress installation with Docker. Details on the `docker-compose.yml` in that post remain basically accurate, but I'm reporting here an updated `Dockerfile` based on php 8, as well as some quick fixes for common problems.


## Dockerfile ready for Wordpress based on Php 8 (`php:8.0-apache`)

N.B. This is a basic Docker image that comes with an empty server directory, no Worpdress pre-installed. It just comes with the main things required by a fresh Wordpress install.


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

## Fix ownership on the server after having installed Wordpress

After you have manually installed Wordpress, you may need to fix ownership of the `wp-content` folder. The need may appear, for example, if Wordpress asks for FTP credentials in order to install plugins.  

```
docker exec -u root -it {CONTAINER_ID} /bin/bash
chown -R www-data wp-content
chmod -R 755 wp-content
```

To prevent Wordpress from asking about FTP credentials, you may also want to add the following line to `wp-config.php`:

```
define('FS_METHOD', 'direct');
```

Keep in mind that if you are using Traefik or similar reverse proxy, as described in the [Wordpress documentation](https://wordpress.org/support/article/administration-over-ssl/) you need to add the following chunk __at the beginning__ of your `wp-config.php` file. [^1]


```
define('FORCE_SSL_ADMIN', true);
// in some setups HTTP_X_FORWARDED_PROTO might contain 
// a comma-separated list e.g. http,https
// so check for https existence
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
$_SERVER['HTTPS']='on';
```

## Docker compose based on Traefik for Wordpress

Finally, here's again a template for `docker-compose.yml` based on Traefik that should get you up and running if you have already pointed your A records to your server. (phpmyadmin can of course be safely removed). 


```
version: "3.3"

services:

  traefik:
    image: "traefik:v2.8"
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
    networks:
      - network1
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
    networks:
      - network1
    environment:
      MYSQL_ROOT_PASSWORD: Ez2oogha5ogh4woh
      MYSQL_DATABASE: ieseehahF0oo
      MYSQL_USER: ii4eshaeZ9ta
      MYSQL_PASSWORD: lae7gia4MohW

  example_com:
    depends_on:
      - example_com_db
    image: giocomai/php_8_0:latest
    networks:
      - network1
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

