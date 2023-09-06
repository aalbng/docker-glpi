
# Table of Contents
- [Introduction](#introduction)
  - [Default accounts](#default-accounts)
- [Deploy with CLI](#deploy-with-cli)
  - [Deploy GLPI](#deploy-glpi)
  - [Deploy GLPI with existing database](#deploy-glpi-with-existing-database)
  - [Deploy GLPI with database and persistence data](#deploy-glpi-with-database-and-persistence-data)
  - [Deploy a specific release of GLPI](#deploy-a-specific-release-of-glpi)
- [Deploy with docker-compose](#deploy-with-docker-compose)
  - [Deploy without persistence data ( for quickly test )](#deploy-without-persistence-data--for-quickly-test-)
  - [Deploy a specific release](#deploy-a-specific-release)
  - [Deploy with persistence data](#deploy-with-persistence-data)
    - [mariadb.env](#mariadbenv)
    - [docker-compose .yml](#docker-compose-yml)
- [Environnment variables](#environnment-variables)
  - [TIMEZONE](#timezone)

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
docker run --link mariadb:mariadb -e TZ=Europe/Berlin -p 80:80 --name glpi -d aalbng/glpi:10.0.9
```

## Deploy GLPI with external database
```sh
docker run -e TZ=Europe/Berlin -p 80:80 --name glpi -d aalbng/glpi:10.0.9
```
