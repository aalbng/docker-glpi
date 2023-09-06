#!/bin/bash

#Source environment
. /entrypoint.env

#Unalias cp/rm/mv
unalias rm > /dev/null 2>&1
unalias mv > /dev/null 2>&1
unalias cp > /dev/null 2>&1

#Remove install directory
rm -Rf ${GLPI_FOLDER_WEB}/glpi/install
