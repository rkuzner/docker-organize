#!/bin/bash

# exit immediately on any shell error
set -e

scriptFolder=$( cd "$( dirname "${0}" )" && pwd )
scriptBaseName=$( basename "${0}" .sh )
logFolder="/logs"
logFile="${logFolder}/${scriptBaseName}-$( date +%F ).log"

configFileName="${scriptFolder}/${scriptBaseName}.conf"
if [ -f "${configFileName}" ]; then
	# shellcheck disable=SC1090
	source "${configFileName}"
else
	echo "Config file not-found: ${configFileName}, using default values"
fi

[ -z "${ORGANIZE_CONFIG}" ] && [ -n "${THE_ORGANIZE_CONFIG}" ] && export ORGANIZE_CONFIG="${THE_ORGANIZE_CONFIG}"
[ -z "${THE_ORGANIZE_COMMAND}" ] && THE_ORGANIZE_COMMAND="run"

/usr/local/bin/organize "${THE_ORGANIZE_COMMAND}" 2>&1 | tee -a "${logFile}"
