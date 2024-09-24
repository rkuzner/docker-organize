#!/bin/bash

# exit immediately on any shell error
set -e

scriptFolder=$( cd "$( dirname "${0}" )" && pwd )
scriptBaseName=$( basename "${0}" .sh )
logFolder="/logs"
logFile="${logFolder}/${scriptBaseName}-$( date +%F ).log"

# logs a message to console AND to logfile
function log_message() {
	local message2log="${*}"
	if [ -n "${message2log}" ]; then
		timeStamp=$( date "+%Y/%m/%d %H:%M:%S,%3N" )		# ej: 2018/02/02 15:34:02,241
		echo "${timeStamp} | ${message2log}" | tee -a "${logFile}"
	fi
}

configFileName="${scriptFolder}/${scriptBaseName}.conf"
if [ -f "${configFileName}" ]; then
	log_message "Found Config file!"
	# shellcheck disable=SC1090
	source "${configFileName}"
else
	log_message "Config file not-found: ${configFileName}, using default values"
fi

[ -z "${ORGANIZE_CONFIG}" ] && [ -n "${THE_ORGANIZE_CONFIG}" ] && export ORGANIZE_CONFIG="${THE_ORGANIZE_CONFIG}"
[ -z "${THE_ORGANIZE_COMMAND}" ] && THE_ORGANIZE_COMMAND="run"

log_message "Organize Tool: Start"
/usr/local/bin/organize "${THE_ORGANIZE_COMMAND}" 2>&1 | tee -a "${logFile}"
log_message "Organize Tool: Finish"
