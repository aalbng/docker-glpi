#!/bin/bash

#Unalias cp/rm/mv
unalias rm > /dev/null 2>&1
unalias mv > /dev/null 2>&1
unalias cp > /dev/null 2>&1

#Sourcing gplpi environment
. /entrypoint.env

#Setting timezone
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
echo "[Date]" > /etc/php.d/50-timezone.ini && echo "date.timezone="$TZ >> /etc/php.d/50-timezone.ini

#Redirect httpd log to stdout/stderr
ln -sf /proc/self/fd/1 /var/log/httpd/access_log && \
    ln -sf /proc/self/fd/1 /var/log/httpd/error_log

#Setup GLPI
#Create folder structure
mkdir -p ${GLPI_FOLDER_WEB} ${GLPI_FOLDER_SRC} ${GLPI_FOLDER_MIG}

#Install\Update GLPI if not already installed
if [ -f ${GLPI_VERSION_FILE} ]; then
	echo "--Version ${GLPI_TARGET_VERSION} already installed--"
elif [ -d ${GLPI_VERSION_DIR} ]; then

	echo "--Updating GLPI version--"
	echo "-Backup files and folders-"
	mv -f ${GLPI_FOLDER_WEB}glpi/config ${GLPI_FOLDER_WEB}glpi/files ${GLPI_FOLDER_WEB}glpi/marketplace ${GLPI_FOLDER_WEB}glpi/plugins ${GLPI_FOLDER_MIG}
	
	echo "-Clean GLPI directory-"
	rm -Rf ${GLPI_FOLDER_WEB}/glpi
	
	echo "-Installing new version-"
	wget -N -P ${GLPI_FOLDER_SRC} ${GLPI_URL} \
		&& echo "-Unpacking GLPI-" \
		&& tar -xzf ${GLPI_FOLDER_SRC}${GLPI_TAR_PACKAGE} -C ${GLPI_FOLDER_WEB} \
		&& echo "-Cleainnig source-" \
		&& rm -f ${GLPI_FOLDER_SRC}${GLPI_TAR_PACKAGE}
	
	echo "-Restore backup files and delete backup-"
	cp -Rf ${GLPI_FOLDER_MIG}config ${GLPI_FOLDER_MIG}files ${GLPI_FOLDER_MIG}marketplace ${GLPI_FOLDER_MIG}plugins ${GLPI_FOLDER_WEB}glpi/ \
		&& rm -Rf ${GLPI_FOLDER_MIG}config ${GLPI_FOLDER_MIG}files ${GLPI_FOLDER_MIG}marketplace ${GLPI_FOLDER_MIG}plugins
		
else
	echo "--Instlling GLPI ${GLPI_TARGET_VERSION}--"
	wget -N -P ${GLPI_FOLDER_SRC} ${GLPI_URL} \
		&& echo "-Unpacking GLPI-" \
		&& tar -xzf ${GLPI_FOLDER_SRC}${GLPI_TAR_PACKAGE} -C ${GLPI_FOLDER_WEB} \
		&& echo "-Cleainnig source-" \
		&& rm -f ${GLPI_FOLDER_SRC}${GLPI_TAR_PACKAGE}
fi


#FIX User/Group
chown -R apache:apache ${GLPI_FOLDER_WEB} ${GLPI_FOLDER_SRC}

#Starting supervisor
/usr/bin/supervisord -c /supervisord.conf -n


