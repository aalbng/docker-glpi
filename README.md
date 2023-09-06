
# Table of Contents
- [Introduction](#introduction)
  - [Default accounts](#default-accounts)
- [Deploy with CLI](#deploy-with-cli)
  - [Deploy GLPI](#deploy-glpi)
  - [Deploy GLPI with external database](#deploy-glpi-with-external-database)
  - [Deploy GLPI with database and persistence data](#deploy-glpi-with-database-and-persistence-data)
- [Deploy with docker-compose](#deploy-with-docker-compose)
  - [Deploy without persistence data](#deploy-without-persistence-data)
  - [Deploy with persistence data](#deploy-with-persistence-data)

# Introduction

Install, update and run an GLPI instance with docker
PHP 8.2 / httpd OS latest / GLPI 10.0.9

## Default accounts

More info in the 📄[Docs](https://glpi-install.readthedocs.io/en/latest/install/wizard.html#end-of-installation)

| Login/Password     	| Role              	|
|--------------------	|-------------------	|
| glpi/glpi          	| admin account     	|
| tech/tech          	| technical account 	|
| normal/normal      	| "normal" account  	|
| post-only/postonly 	| post-only account 	|

# Deploy with CLI

## Deploy GLPI (quick and dirty) 
```sh
docker run --name mariadb -e TZ=Europe/Berlin -e MARIADB_ROOT_PASSWORD=glpi -e MARIADB_DATABASE=glpi -d mariadb:11.1.2
docker run --link mariadb:mariadb -e TZ=Europe/Berlin -p 80:80 --name glpi -d aalbng/glpi:latest
```

## Deploy GLPI with external database
```sh
docker run -e TZ=Europe/Berlin -p 80:80 --name glpi -d aalbng/glpi:latest
```

## Deploy GLPI with database and persistence data

For an usage on production environnement or daily usage, it's recommanded to use container with volumes to persistent data.

* First, create MariaDB container with volume

```sh
docker run --name mariadb -e TZ=Europe/Berlin -e MARIADB_ROOT_PASSWORD=glpi -e MARIADB_DATABASE=glpi --volume mysql:/var/lib/mysql -d mariadb:11.1.2
```

* Then, create GLPI container with volume and link MariaDB container

```sh
docker run --link mariadb:mariadb -e TZ=Europe/Berlin -p 80:80 --name glpi --volume glpi:/glpi/www -d aalbng/glpi:latest
```


# Deploy with docker-compose

## Deploy without persistence data
```yaml
version: "3.8"

services:
#MariaDB Container
  mariadb:
    image: mariadb:11.1.2
    container_name: mariadb
    hostname: mariadb
    environment:
      - TZ=Europe/Berlin
      - MARIADB_ROOT_PASSWORD=glpi
      - MARIADB_DATABASE=glpi

#GLPI Container
  glpi:
    image: aalbng/glpi:latest
    container_name : glpi
    hostname: glpi
    ports:
      - "80:80"
    environment:
      - TZ=Europe/Berlin
```

## Deploy with persistence data

```yaml
version: "3.2"

services:
#MariaDB Container
  mariadb:
    image: mariadb:11.1.2
    container_name: mariadb
    hostname: mariadb
    volumes:
      - mysql:/var/lib/mysql
    environment:
      - TZ=Europe/Berlin
      - MARIADB_ROOT_PASSWORD=glpi
      - MARIADB_DATABASE=glpi
    restart: always

#GLPI Container
  glpi:
    image: aalbng/glpi:latest
    container_name : glpi
    hostname: glpi
    ports:
      - "80:80"
    volumes:
      - glpi:/glpi/www 
    environment:
      - TZ=Europe/Berlin
    restart: always
```

To deploy, just run the following command on the same directory as files

```sh
docker-compose up -d
```
