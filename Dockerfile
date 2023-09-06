FROM almalinux:9
MAINTAINER Aalb-ng
LABEL Build 2023-09-06 / PHP 8.2 / apache2 OS latest / GLPI 10.0.9

#Variables needed for start upscript
ARG TZ=Europe/Berlin
ENV TZ ${TZ}

#Install epel repos / additional tools / nginx / php (https://wiki.crowncloud.net/?How_to_Install_PHP_8_2_in_AlmaLinux_8)
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
	&& dnf -y install https://rpms.remirepo.net/enterprise/remi-release-9.rpm \
	&& dnf -y install yum-utils \
	&& dnf -y install procps-ng \
	&& dnf -y install jq \
	&& dnf -y install cronie \
	&& dnf -y install supervisor \
	&& dnf -y install httpd \
	&& dnf -y module reset php \
	&& dnf -y module install php:remi-8.2 \
	&& dnf -y install wget \
	&& dnf -y install php php-fpm php-intl php-mysql php-curl php-gd php-ldap php-xml php-mbstring php-zip php-ldap \
	&& mkdir /run/php-fpm \
	&& dnf -y update \
	&& dnf clean all \
	&& sed -E -i -e 's/session.cookie_httponly =/session.cookie_httponly = On/' /etc/php.ini

#Copy configuration and files
COPY ["src/glpi.conf", "/etc/httpd/conf.d/glpi.conf"]
COPY ["src/crontab", "/etc/crontab"]
COPY ["src/supervisord.conf", "src/entrypoint.sh", "src/entrypoint.env","src/removeInstall.sh", "/"]
RUN chmod 755 ./entrypoint.sh \
	&& chmod 755 ./removeInstall.sh \
	&& chmod 644 /etc/crontab 

CMD "./entrypoint.sh"
