#!/bin/bash

# exit immediately on any shell error
set -e

scriptFolder=$( cd "$( dirname "${0}" )" && pwd )
scriptBaseName=$( basename "${0}" .sh )
logFolder="/logs"
logFile="${logFolder}/${scriptBaseName}-$( date +%F ).log"

configFileName="${scriptFolder}/${scriptBaseName}.conf"
if [ -f "${configFileName}" ]; then
	source ${configFileName}
else
	echo "Config file not-found: ${configFileName}, using default values"
fi
[ -z "${THE_ORGANIZE_COMMAND}" ] && THE_ORGANIZE_COMMAND="run"

/usr/local/bin/organize ${THE_ORGANIZE_COMMAND} >> ${logFile} 2>&1
