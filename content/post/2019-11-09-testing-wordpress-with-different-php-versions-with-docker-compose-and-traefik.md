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

As of Autumn 2019, many Wordpress users will likely have found a warning suggesting they *must* update php on their server. As [php 5.6 has reached end of life in 2018](https://haydenjames.io/php-5-6-eol-end-of-life-php-7-compatibility-check/), this is well needed. Yet, many Wordpress installations that have been running for years may be using a plugin or a theme that is not compatible with php 7.3. 

Being to some extent responsible for a number (undisclosed, but not negligible) of Worpress installations scattered across a number of servers, I needed a way to make sure that updates go smoothly, and be best-positioned to change back and forth between php versions to introduce all necessary fixes. 

As some of these websites have been around for many years, not all of them are currently using a secure connection, so I take this also as a chance to make sure they will all be on https after the update.

__Warning__: not much of what you'll find here follows best practices in terms of security or privacy. This works for me, and should work for some basic testing purposes, but... you have been warned.

## Step 1: Set up a basic Docker image with php 5.6 and php 7.3

The first step is to prepare a basic php Docker image with apache installed. I also installed some basic libraries such as zip and pdo which are used by a number of plugins. You may need to install others, keeping in mind that you need to take care of installing dependencies in the Dockerfile yourself.

You can safely^[*Safely*, that is, keeping in mind you'll be using a php version with known vulnerabilities] use the Docker images I created, `giocomai/php_5_6_20` and `giocomai/php_7_3`


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


## Step 2: Get your docker-compose up and running



## Step 3: Move your website with Wordpress Duplicator plugin


The installation will work fine, but as you'll move on to finalise your installation going to the admin part of your wordpress installation, it just won't work. 

This is due the fact that we're using a reverse proxy (i.e. Traefik), so as described in the [Wordpress documentation](https://wordpress.org/support/article/administration-over-ssl/) we need to add the following chunk __at the beginning__ of our wp-config.php file.^[I can't stress enough the __at the beginning__ part, since this is not mentioned in the official Wordpress documentation, and you'll get only silly error messages if you paste this code at the bottom of the wp-config.php file.] 

```
define('FORCE_SSL_ADMIN', true);
// in some setups HTTP_X_FORWARDED_PROTO might contain 
// a comma-separated list e.g. http,https
// so check for https existence
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
$_SERVER['HTTPS']='on';
```
